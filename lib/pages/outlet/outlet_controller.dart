import 'dart:convert';
import 'dart:io';

import 'package:atenamove/api/api_response.dart';
import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/apiHelper.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/model/CustomerModel.dart';
import 'package:atenamove/model/ModelCustomer.dart';
import 'package:atenamove/utils/sharedpref.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class OutletController extends GetxController {
  SharedPreferencesService xPref = SharedPreferencesService();
  Rx<String> status = ''.obs;
  Rx<String> xLatUser = ''.obs;
  Rx<String> xLongUser = ''.obs;
  Rx<String> xJarakUserOutlet = ''.obs;
  Rx<File?> xSelectedImage = Rx<File?>(null);
  Rx<String> xJamCheckIn = ''.obs;
  Rx<String> xJamCheckOut = ''.obs;
  Rx<String> xGrandTotal = ''.obs;
  RxMap<String, dynamic> xArguments = <String, dynamic>{}.obs;
  Rx<String> xStatusKunjungan = ''.obs;
  RxBool xIsLuarRute = false.obs;
  RxString xTglLuarRute = "".obs;
  final Rx<CustomerModel> customer = Rx<CustomerModel>(CustomerModel());
  final modelCustomer = ModelCustomer();

  Rx<bool> isAvailable = false.obs;
  RxBool xIsVerified = false.obs;

  final List<String> items = [
    "TOKO TUTUP",
    "PEMILIK TIDAK ADA DITEMPAT",
  ];
  RxString xSelectedAlasan = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    customer.value = Get.arguments;
    xIsVerified.value = xPref.getBool("SudahVerifikasi") ?? false;
    await checkPermission();
    await cekJarak();
  }

  Future<void> checkOut() async {
    if (customer.value.statuskunjungan == "BELUM DIKUNJUNGI") {
      await modelCustomer.checkAbsen(
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString(),
        'CHECK OUT',
        xSelectedAlasan.value,
        "SUDAH DIKUNJUNGI",
        '',
        '',
        '',
        '',
        customer.value.idcustomer.toString(),
      );
    } else if (customer.value.statuskunjungan == "SUDAH DIKUNJUNGI") {
      await modelCustomer.updateAbsen(
        'CHECK OUT',
        xSelectedAlasan.value,
        customer.value.idcustomer.toString(),
      );
    }
    Get.back();
  }

  simpanRuteTidakDikunjungi() async {
    try {
      final user = await xPref.getUser();
      ApiResponse? result = await ApiHelper().simpanRuteTidakDikunjungi(
        pIdPerusahaan: user.idperusahaan ?? '',
        pIdDepo: user.iddepo ?? '',
        pIdUser: user.iduser ?? '',
        pJabatan: user.jabatan ?? '',
        pIdCustomer: customer.value.idcustomer.toString(),
        pTanggal: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        pApprove: '0',
      );
      Get.back();
      if (result != null && result.code == 200 && result.success) {
        CustomWidget.customSuccessPopUp(
          context: Get.context!,
          pInformation: CustomText(
            "Lakukan Sinkronisasi, agar outlet menjadi tidak dikunjungi",
            fontSize: Listfontsize.h5,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        );
      } else {
        CustomWidget.customAlertPopUp(
          context: Get.context!,
          pInformation: CustomText(
            "Simpan Rute Tidak Di Kunjungi Gagal",
            fontSize: Listfontsize.h5,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        );
      }
    } catch (e) {
      print(e);
      Get.back();
    }
  }

  Future<bool> takePicture() async {
    final imgPicker = ImagePicker();
    XFile? imgPath = await imgPicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxHeight: 300,
      maxWidth: 400,
    );
    if (imgPath != null) {
      xSelectedImage.value = File(imgPath.path);
      await modelCustomer.checkAbsen(
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString(),
        'CHECK IN',
        "",
        "BELUM DIKUNJUNGI",
        xLatUser.value,
        xLongUser.value,
        base64Encode(xSelectedImage.value!.readAsBytesSync()),
        xSelectedImage.value!.path.split('/').last,
        customer.value.idcustomer.toString(),
      );
    }
    return imgPath != null;
  }

  Future<void> checkPermission() async {
    bool camera = await checkCameraPermission();
    bool loc = await checkLocationPermission();
    if (!camera || !loc) {
      CustomWidget.customAlertPopUp(
        context: Get.context!,
        pInformation: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "Harap Ijinkan Pemakaian Fitur Berikut ini di Pengaturan HP Anda",
              fontSize: Listfontsize.h5,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.left,
            ),
            Container(
              height: GlobalVariable.ratioWidth(Get.context!) * 10,
            ),
            CustomText(
              "1. Kamera",
              fontSize: Listfontsize.h5,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.left,
              color: const Color(ListColor.dangerMain),
              height: ListFontHeight.h5,
            ),
            CustomText(
              "2. GPS",
              fontSize: Listfontsize.h5,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.left,
              color: const Color(ListColor.dangerMain),
              height: ListFontHeight.h5,
            ),
          ],
        ),
      );
    }
  }

  Future<void> cekJarak() async {
    CustomerModel xDataCustomer = Get.arguments;
    final user = await xPref.getUser();
    status.value = "";
    isAvailable.value = false;
    final locPermission = await Geolocator.requestPermission();
    if (locPermission == LocationPermission.denied) {
      await Geolocator.openLocationSettings();
    }
    status.value = "loading";
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double jarak = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      double.parse(xDataCustomer.latitude ?? '0'),
      double.parse(xDataCustomer.longitude ?? '0'),
    );
    xLatUser.value = position.latitude.toString();
    xLongUser.value = position.longitude.toString();
    xJarakUserOutlet.value = jarak.toStringAsFixed(2);

    if (position.isMocked) {
      await sendEmailFakeGps();
      status.value = "Fake GPS";
      isAvailable.value = false;
    } else {
      print("jarak : $jarak");
      if (jarak > double.parse(user.toleransijarak ?? "0")) {
        status.value = "Diluar jarak";
        isAvailable.value = false;
      } else {
        status.value = "Valid";
        isAvailable.value = true;
      }

      //kalau mode debug, uncomment 2 baris dibawah. kalau sudah produksi, jangan lupa dicomment
      status.value = "Valid";
      isAvailable.value = true;
    }
    isAvailable.refresh();
    status.refresh();
  }

  Future<void> sendEmailFakeGps() async {
    CustomWidget.customLoadingPopUp(context: Get.context!);
    final user = await xPref.getUser();
    bool isSuccess = true;
    while (isSuccess) {
      try {
        ApiResponse? result = await ApiHelper().sendEmailFakeGPS(
          pIdPerusahaan: user.idperusahaan ?? '',
          pNamaSalesman: "Armada ${user.username ?? ''}",
        );

        if (result != null) {
          if (result.success && result.code == 200) {
            isSuccess = false;
            Get.back();
          }
        }
      } catch (e) {
        print("error send email fake gps : $e");
      }
    }
  }

  Future<bool> checkCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    } else {
      PermissionStatus newStatus = await Permission.camera.request();
      return newStatus.isGranted;
    }
  }

  Future<bool> checkLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    } else {
      PermissionStatus newStatus = await Permission.location.request();
      return newStatus.isGranted;
    }
  }
}
