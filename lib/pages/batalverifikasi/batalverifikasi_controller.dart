import 'package:atenamove/api/api_response.dart';
import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/apiHelper.dart';
import 'package:atenamove/model/armadaModel.dart';
import 'package:atenamove/utils/sharedpref.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BatalVerifikasiController extends GetxController {
  Rx<TextEditingController> xSearchTextField = TextEditingController().obs;
  RxList<ArmadaModel> xListArmada = <ArmadaModel>[].obs;
  List<ArmadaModel> armada = [];
  final xPref = SharedPreferencesService();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getListArmada();
    });
  }

  void selectBatalArmada(ArmadaModel armada) async {
    CustomWidget.customLoadingPopUp(context: Get.context!);
    try {
      final user = await xPref.getUser();
      ApiResponse? result = await ApiHelper().batalVerifikasiArmada(
        pIdPerusahaan: user.idperusahaan ?? '',
        pIdDepo: user.iddepo ?? '',
        pIdArmada: armada.idarmada ?? '',
        pTanggal: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      Get.back();
      if (result != null && result.code == 200 && result.success) {
        CustomWidget.customSuccessPopUp(
          context: Get.context!,
          pInformation: CustomText(
            "Pembatalan Verifikasi Armada Berhasil",
            fontSize: Listfontsize.h5,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        );
      }
    } catch (e) {
      Get.back();
    }
  }

  searchArmada(String value) {
    xListArmada.clear();
    if (value.isEmpty) {
      xListArmada.addAll(armada);
    } else {
      xListArmada.addAll(armada.where((element) => element.namaarmada!.toLowerCase().contains(value.toLowerCase())));
    }
  }

  void getListArmada() async {
    CustomWidget.customLoadingPopUp(context: Get.context!);
    xListArmada.clear();
    armada.clear();
    try {
      final user = await xPref.getUser();
      ApiResponse? result = await ApiHelper().getDataArmada(
        pIdPerusahaan: user.idperusahaan ?? '',
        pIdDepo: user.iddepo ?? '',
      );
      if (result != null && result.code == 200 && result.success) {
        armada = List<ArmadaModel>.from(result.data.map((e) => ArmadaModel.fromJson(e)));
        xListArmada.addAll(armada);
      }
      Get.back();
    } catch (e) {
      Get.back();
    }
  }
}
