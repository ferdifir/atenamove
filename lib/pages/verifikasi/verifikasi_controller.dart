import 'package:atenamove/api/api_response.dart';
import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/apiHelper.dart';
import 'package:atenamove/model/ModelCustomer.dart';
import 'package:atenamove/model/ModelTransaksi.dart';
import 'package:atenamove/model/sopirModel.dart';
import 'package:atenamove/utils/sharedpref.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VerifikasiController extends GetxController {
  Rx<String> xSelectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  Rx<TextEditingController> xCatatan = TextEditingController().obs;
  RxList<SopirModel> xDataSopir = <SopirModel>[].obs;
  List<SopirModel> listSopir = [];
  final xPref = SharedPreferencesService();

  Future<void> selectDate() async {
    final DateTime today = DateTime.now();
    final DateTime initialDate = xSelectedDate.isNotEmpty ? DateTime.parse(xSelectedDate.value) : today;

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      firstDate: DateTime(2000),
      lastDate: today,
      initialDate: initialDate.isBefore(today) ? initialDate : today,
    );

    if (picked != null) {
      xSelectedDate.value = DateFormat('yyyy-MM-dd').format(picked);
      xSelectedDate.refresh();
    }
  }

  searchSopir(String value) async {
    xDataSopir.clear();
    if (value.isEmpty) {
      xDataSopir.addAll(listSopir);
      return;
    }
    xDataSopir.addAll(listSopir.where((element) => element.namapegawai!.toLowerCase().contains(value.toLowerCase())));
  }

  void getDataHelperSopir() async {
    try {
      CustomWidget.customLoadingPopUp(context: Get.context!);
      final user = await xPref.getUser();
      ApiResponse? result;
      if (user.jabatan == "HELPER") {
        result = await ApiHelper().getDataHelper(
          pIdPerusahaan: user.idperusahaan ?? '',
          pIdDepo: user.iddepo ?? '',
        );
      } else {
        result = await ApiHelper().getDataSopir(
          pIdPerusahaan: user.idperusahaan ?? '',
          pIdDepo: user.iddepo ?? '',
        );
      }
      if (result != null && result.code == 200 && result.success) {
        listSopir = List<SopirModel>.from(result.data.map((e) => SopirModel.fromJson(e)));
        xDataSopir.addAll(listSopir);
      }
      Get.back();
    } catch (e) {
      Get.back();
    }
  }

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getDataHelperSopir();
    });
  }

  Future<void> processVerifikasi({required String idUser2, catatan}) async {
    try {
      CustomWidget.customLoadingPopUp(context: Get.context!);
      final user = await xPref.getUser();
      final armada = await xPref.getArmada();
      final dataTransaksi = await ModelTransaksi().select(null);
      ApiResponse? result = await ApiHelper().verifikasiData(
        pIdPerusahaan: user.idperusahaan ?? '',
        pIdUser: user.iduser ?? '',
        pIdDepo: user.iddepo ?? '',
        pTglTrans: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        iduser2: idUser2,
        pIdArmada: armada.idarmada ?? '',
        pJabatan: user.jabatan ?? '',
        pCatatan: catatan ?? '',
        dataTransaksi: dataTransaksi,
      );
      if (result != null && result.code == 200 && result.success) {
        await ModelTransaksi().clear();
        _checkVerifikasi();
        await ModelCustomer().clear();
        resetArmadaLogin();
        CustomWidget.customSuccessPopUp(
          context: Get.context!,
          pInformation: CustomText(
            "Verifikasi Berhasil",
            fontSize: Listfontsize.h5,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        );
      } else {
        CustomWidget.customAlertPopUp(
          context: Get.context!,
          pInformation: CustomText(
            "Verifikasi Gagal",
            fontSize: Listfontsize.h5,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        );
      }
      Get.back();
    } catch (e) {
      Get.back();
    }
  }

  resetArmadaLogin() async {
    try {
      final user = await xPref.getUser();
      await ApiHelper().resetArmadaLogin(
        pIdPerusahaan: user.idperusahaan ?? '',
        pIdUser: user.iduser ?? '',
        pIdDepo: user.iddepo ?? '',
      );
    } catch (e) {
      print(e);
    }
  }

  void _checkVerifikasi() async {
    bool check = false;
    try {
      final user = await xPref.getUser();
      ApiResponse? result = await ApiHelper().cekVerifikasi(
        pIdPerusahaan: user.idperusahaan ?? '',
        idUser: user.iduser ?? '',
        tanggal: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        jabatan: user.jabatan ?? '',
      );
      if (result != null && result.code == 200 && result.success) {
        check = result.message == "SUDAH";
      }
    } catch (e) {
      print(e);
    }
    print("Check Verifikasi : $check");
    await xPref.setBool("SudahVerifikasi", check);
  }
}
