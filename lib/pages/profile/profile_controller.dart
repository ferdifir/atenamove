import 'dart:async';
import 'dart:convert';

import 'package:atenamove/api/api_response.dart';
import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/apiHelper.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/model/DatabaseModelCustomer.dart';
import 'package:atenamove/model/ModelCustomer.dart';
import 'package:atenamove/model/ModelTransaksi.dart';
import 'package:atenamove/model/dataPerusahaanModel.dart';
import 'package:atenamove/model/sopirModel.dart';
import 'package:atenamove/routes/app_routes.dart';
import 'package:atenamove/utils/sharedpref.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  Rx<DataPerusahaanModel>? DataPerusahaan = new DataPerusahaanModel().obs;
  Rx<String> dataPassword = ''.obs;
  Rx<String> xUserJabatan = ''.obs;
  Rx<String> xUserNama = ''.obs;
  Rx<String> xUserUsername = ''.obs;

  final xPref = SharedPreferencesService();
  Rx<bool> xIsGetCustomerRunning = true.obs;
  Rx<bool> xIsGetSupplierRunning = true.obs;
  Rx<bool> xIsGetCustomerSupplierRunning = true.obs;
  Rx<bool> xIsGetDivisiSupplierRunning = true.obs;
  Rx<bool> xIsGetCustomerBarangRunning = true.obs;
  Rx<bool> xIsGetBarangRunning = true.obs;
  Rx<bool> xIsGetPenjualanTerakhirRunning = true.obs;
  String xJamMulai = '';
  Rx<int> xCountCatchError = 0.obs;
  Rx<int> xCountCatchCustomerError = 0.obs;
  Rx<int> xCountCatchTransaksiError = 0.obs;
  Rx<String> xGetCustomerEndTime = ''.obs;
  Rx<String> xGetTransaksiEndTime = ''.obs;
  Rx<String> currentTime = ''.obs;
  Rx<String> xCountDot = ''.obs;

  Rx<bool> isSyncRunning = true.obs;
  Rx<int> syncRetryCount = 0.obs;
  RxInt xSyncRetryCountSetoran = 0.obs;
  Rx<String> syncStartTime = ''.obs;
  Rx<String> syncEndTime = ''.obs;
  Rx<String> currentSyncItem = ''.obs;
  Rx<int> jmlTransaksi = 0.obs;
  Rx<int> currentIndexSO = 0.obs;
  RxInt xJmlSetoran = 0.obs;
  RxInt xCurrentIndexSetoran = 0.obs;

  Timer? _timer;

  Rx<TextEditingController> xPasswordLamaTextController = TextEditingController().obs;
  Rx<TextEditingController> xPasswordBaruTextController = TextEditingController().obs;
  RxBool xIsShowPasswordLama = false.obs;
  RxBool xIsShowPasswordBaru = false.obs;
  RxBool xIsErrorPassLama = false.obs;
  RxBool xIsErrorPassBaru = false.obs;
  RxString xErrorTextPassLama = ''.obs;
  RxString xErrorTextPassBaru = ''.obs;
  RxBool xIsLoading = false.obs;
  Rx<DateTime> xTglUnduh = DateTime.now().obs;
  RxBool hasUnduhData = false.obs;
  RxBool xIsVerified = false.obs;

  Future<bool> gantiPassword() async {
    final user = await xPref.getUser();
    try {
      ApiResponse? result = await ApiHelper().gantiPassword(
        pIdPerusahaan: user.idperusahaan ?? '',
        pIdSalesman: user.iduser ?? '',
        pPasswordLama: xPasswordLamaTextController.value.text,
        pPasswordBaru: xPasswordBaruTextController.value.text,
      );
      return result != null && result.code == 200 && result.success;
    } catch (e) {
      return false;
    }
  }

  unduhData() async {
    xCountDot.value = '.';
    xCountCatchCustomerError.value = 0;
    xCountCatchTransaksiError.value = 0;
    xIsGetCustomerRunning.value = true;
    xIsGetSupplierRunning.value = true;
    xJamMulai = "";
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        currentTime.value = DateFormat('HH:mm:ss').format(DateTime.now());
        if (xCountDot.value.length > 4) {
          xCountDot.value = '';
        }
        xCountDot.value = '${xCountDot.value}.';
      },
    );
    xJamMulai = DateFormat('HH:mm:ss').format(DateTime.now());
    hasUnduhData.value = true;
    await getCustomer();
    await getTransaksi();
    await updateTglUnduh();
    xTglUnduh.value = DateTime.now();
    String strTglUnduh = DateFormat("dd-MM-yyyy").format(DateTime.now());
    await xPref.setString("TglUnduh", strTglUnduh);
    hasUnduhData.value = true;
    _timer?.cancel();
    Get.back();
    showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        backgroundColor: const Color(ListColor.neutral100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 8)),
        child: Padding(
          padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: GlobalVariable.ratioWidth(context) * 60,
                height: GlobalVariable.ratioWidth(context) * 60,
                child: const CircularProgressIndicator(
                  color: Color(ListColor.infoMain),
                  strokeWidth: 3,
                  backgroundColor: Color(ListColor.neutral10),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: GlobalVariable.ratioWidth(context) * 8),
                child: CustomText(
                  "Perbarui Tanggal Unduh Pada Server",
                  fontSize: Listfontsize.h5,
                  textAlign: TextAlign.center,
                  color: const Color(ListColor.neutral10),
                ),
              )
            ],
          ),
        ),
      ),
    );

    Get.back();
    CustomWidget.customSuccessPopUp(
      context: Get.context!,
      pInformation: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: GlobalVariable.ratioWidth(Get.context!) * 8),
            child: CustomText(
              "Unduh Data Berhasil",
              fontSize: Listfontsize.h5,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: GlobalVariable.ratioWidth(Get.context!) * 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/icons/check.svg",
                  width: GlobalVariable.ratioWidth(Get.context!) * 14,
                ),
                SizedBox(
                  width: GlobalVariable.ratioWidth(Get.context!) * 2,
                ),
                CustomText(
                  "Customer Selesai Diunduh",
                  fontSize: Listfontsize.px14,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: GlobalVariable.ratioWidth(Get.context!) * 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/icons/check.svg",
                  width: GlobalVariable.ratioWidth(Get.context!) * 14,
                ),
                SizedBox(
                  width: GlobalVariable.ratioWidth(Get.context!) * 2,
                ),
                CustomText(
                  "Transaksi Selesai Diunduh",
                  fontSize: Listfontsize.px14,
                )
              ],
            ),
          ),
          CustomText(
            "Jam Mulai : $xJamMulai",
            fontSize: Listfontsize.px14,
          ),
          CustomText(
            "Jam Selesai : ${xGetTransaksiEndTime.value}",
            fontSize: Listfontsize.px14,
          ),
        ],
      ),
    );
  }

  getCustomer() async {
    try {
      final user = await xPref.getUser();
      final armada = await xPref.getArmada();
      xIsGetCustomerRunning.value = true;
      ApiResponse? result = await ApiHelper().getCustomer(
        pIdPerusahaan: user.idperusahaan ?? '',
        pIdUser: user.iduser ?? '',
        pIdDepo: user.iddepo ?? '',
        pTglKirim: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        pJabatan: user.jabatan ?? '',
        pIdArmada: armada.idarmada ?? '',
      );
      if (result != null && result.success) {
        xGetCustomerEndTime.value = DateFormat('HH:mm:ss').format(DateTime.now());
        final ModelCustomer modelCustomer = ModelCustomer();
        int? jmlData = await modelCustomer.selectJmlData();
        if (jmlData != null) {
          modelCustomer.update(result.data['rows']);
        } else {
          modelCustomer.insert(result.data['rows']);
        }
      }
    } catch (e) {
      xCountCatchCustomerError.value++;
    }
  }

  updateTglUnduh() async {
    try {
      final user = await xPref.getUser();
      await ApiHelper().updateTglUnduh(
        pIdDepo: user.iddepo ?? '',
        pIdPerusahaan: user.idperusahaan ?? '',
        pTglDownload: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        pVersion: GlobalVariable.xVersion,
        pIdSalesman: user.iduser ?? '',
      );
    } catch (e) {
      print(e);
    }
  }

  getTransaksi() async {
    try {
      final user = await xPref.getUser();
      final armada = await xPref.getArmada();
      ApiResponse? result = await ApiHelper().getTransaksi(
        pIdPerusahaan: user.idperusahaan ?? '',
        pIdUser: user.iduser ?? '',
        pIdDepo: user.iddepo ?? '',
        pTglKirim: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        pJabatan: user.jabatan ?? '',
        pIdArmada: armada.idarmada ?? '',
      );
      if (result != null && result.success) {
        xGetTransaksiEndTime.value = DateFormat('HH:mm:ss').format(DateTime.now());
        final ModelTransaksi modelTransaksi = ModelTransaksi();
        int? jmlData = await modelTransaksi.selectJmlData();
        if (jmlData != null) {
          modelTransaksi.update(result.data['rows']);
        } else {
          modelTransaksi.insert(result.data['rows']);
        }
      }
    } catch (e) {
      xCountCatchTransaksiError.value++;
    }
  }

  resetArmadaLogin() async {
    try {
      CustomWidget.customLoadingPopUp(context: Get.context!);
      final user = await xPref.getUser();
      ApiResponse? result = await ApiHelper().resetArmadaLogin(
        pIdPerusahaan: user.idperusahaan ?? '',
        pIdUser: user.iduser ?? '',
        pIdDepo: user.iddepo ?? '',
      );
      if (result != null && result.success) {
        ApiResponse? result2 = await ApiHelper().logout(
          pIdPerusahaan: user.idperusahaan ?? '',
          pIdUser: user.iduser ?? '',
        );
        Get.back();
        if (result2 != null && result2.success) {
          await xPref.clear();
          Get.offAllNamed(
            AppRoutes.LOGIN,
            arguments: true,
          );
        }
      } else {
        Get.back();
      }
    } catch (e) {
      print(e);
      Get.back();
    }
  }

  sinkronisasi() async {
    syncStartTime.value = '';
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        currentTime.value = DateFormat('HH:mm:ss').format(DateTime.now());
      },
    );
    syncStartTime.value = DateFormat('HH:mm:ss').format(DateTime.now());
    syncStartTime.refresh();
    syncRetryCount.value = 0;
    xSyncRetryCountSetoran.value = 0;
    await simpanAbsen();
    await simpanAll();
    syncEndTime.value = DateFormat('HH:mm:ss').format(DateTime.now());
    isSyncRunning.value = false;
  }

  simpanAbsen() async {
    try {
      final user = await xPref.getUser();
      final modelCustomer = ModelCustomer();
      var dataCustomer = await modelCustomer.selectAbsen();
      ApiResponse? result = await ApiHelper().simpanAbsen(
        pIdPerusahaan: user.idperusahaan ?? '',
        pIdDepo: user.iddepo ?? '',
        pIdUser: user.iduser ?? '',
        pJabatan: user.jabatan ?? '',
        pTglTrans: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        pDataAbsen: jsonEncode(dataCustomer),
      );
      return result != null && result.code == 200 && result.success;
    } catch (e) {
      print(e);
      return false;
    }
  }

  simpanAll() async {
    try {
      final user = await xPref.getUser();
      final modelCustomer = ModelTransaksi();
      var dataCustomer = await modelCustomer.select(null);
      ApiResponse? result = await ApiHelper().simpanAll(
        pIdPerusahaan: user.idperusahaan ?? '',
        pIdDepo: user.iddepo ?? '',
        pIdUser: user.iduser ?? '',
        pJabatan: user.jabatan ?? '',
        pDatatransaksi: jsonEncode(dataCustomer),
      );
      return result != null && result.code == 200 && result.success;
    } catch (e) {
      print(e);
      return false;
    }
  }

  updateAplikasi() async {
    CustomWidget.customLoadingPopUp(context: Get.context!);
    try {
      final user = await xPref.getUser();
      ApiResponse? result = await ApiHelper().updateAplikasi(
        idperusahaan: user.idperusahaan ?? '',
      );
      Get.back();
      if (result != null && result.code == 200 && result.success) {
        final link = result.data['link'];
        if (await canLaunchUrl(Uri.parse(link))) {
          await launchUrl(Uri.parse(link));
        } else {
          CustomWidget.customAlertPopUp(
            context: Get.context!,
            pInformation: CustomText(
              "Link Tidak Tersedia",
              fontSize: Listfontsize.h5,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  openHelpAplikasi() async {
    CustomWidget.customLoadingPopUp(context: Get.context!);
    try {
      final user = await xPref.getUser();
      ApiResponse? result = await ApiHelper().getLinkHelpAplikasi(
        idperusahaan: user.idperusahaan ?? '',
      );
      Get.back();
      if (result != null && result.code == 200 && result.success) {
        final link = result.data['link'];
        if (await canLaunchUrl(Uri.parse(link))) {
          await launchUrl(Uri.parse(link));
        } else {
          CustomWidget.customAlertPopUp(
            context: Get.context!,
            pInformation: CustomText(
              "Link Tidak Tersedia",
              fontSize: Listfontsize.h5,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    final user = await xPref.getUser();
    xIsVerified.value = xPref.getBool("SudahVerifikasi") ?? false;
    xUserJabatan.value = user.jabatan ?? '';
    xUserNama.value = user.username ?? '';
    xUserUsername.value = user.username ?? '';
    String tglunduh = xPref.getString("TglUnduh") ?? '';
    if (tglunduh.isNotEmpty) {
      xTglUnduh.value = DateFormat("dd-MM-yyyy").parse(tglunduh);
      hasUnduhData.value = true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
