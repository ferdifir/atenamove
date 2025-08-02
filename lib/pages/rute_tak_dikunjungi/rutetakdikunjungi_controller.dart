import 'package:atenamove/api/api_response.dart';
import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/apiHelper.dart';
import 'package:atenamove/utils/sharedpref.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RuteTidakDikunjungiController extends GetxController {
  final xPref = SharedPreferencesService();
  final xSearch = TextEditingController();
  RxList<Map> xData = <Map>[].obs;
  List<Map> listData = [];
  final List<String> items = [
    "CHECK-IN BERMASALAH",
    "SUSAH SINYAL",
    "BUKAN ORDERNYA",
    "Alasan Lainnya",
  ];
  RxString xSelectedAlasan = ''.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      CustomWidget.customLoadingPopUp(context: Get.context!);
      await getRuteTakDikunjungi();
      Get.back();
    });
  }

  searchRute(String search) {
    xData.clear();
    if (search.isEmpty) {
      xData.addAll(listData);
    } else {
      xData.addAll(listData.where((element) => element['namacustomer'].toString().toLowerCase().contains(search.toLowerCase())));
    }
    xData.refresh();
  }

  approveAlasan(String id, urutan, alasan) async {
    try {
      final user = await xPref.getUser();
      ApiResponse? result = await ApiHelper().approveRuteTakDikunjungi(
        pIdPerusahaan: user.idperusahaan ?? '',
        pUrutan: urutan,
        pIdCustomer: id,
        pUserApprove: user.iduser ?? '',
        pTanggal: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        pAlasan: alasan,
      );
      Get.back();
      if (result != null && result.code == 200 && result.success) {
        CustomWidget.customSuccessPopUp(
          context: Get.context!,
          pInformation: CustomText(
            "Alasan tidak dikunjungi berhasil disimpan",
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

  getRuteTakDikunjungi() async {
    listData.clear();
    xData.clear();
    try {
      final user = await xPref.getUser();
      ApiResponse? result = await ApiHelper().getRuteTakDikunjungi(
        pIdPerusahaan: user.idperusahaan ?? '',
        pIdDepo: user.iddepo ?? '',
        pTanggal: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      if (result != null && result.code == 200 && result.success) {
        listData = result.data['rows'];
        xData.addAll(listData);
      }
    } catch (e) {
      print(e);
    }
  }
}
