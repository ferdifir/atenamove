// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:atenamove/api/api_response.dart';
import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/apiHelper.dart';
import 'package:atenamove/model/DatabaseConnection.dart';
import 'package:atenamove/model/dataPerusahaanModel.dart';
import 'package:atenamove/routes/app_routes.dart';
import 'package:atenamove/utils/sharedpref.dart';
import 'package:atenamove/widget/customDropDown.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> xPerusahaanTextController = TextEditingController().obs;
  Rx<TextEditingController> xUsernameTextController = TextEditingController(text: "deddy").obs;
  Rx<TextEditingController> xPasswordTextController = TextEditingController(text: "1234").obs;
  List<DropDownModel> xListUrlPerusahaan = <DropDownModel>[
    DropDownModel(
      text: "Cipta Sarana Bangun",
      value: "https://csb.atena.id/",
    ),
  ];
  RxBool xIsShowPassword = false.obs;
  Rx<DropDownModel> selectedPerusahaan = DropDownModel(text: "", value: "").obs;
  final xPref = SharedPreferencesService();
  DataPerusahaanModel? xDataPerusahaan;

  @override
  void onInit() async {
    super.onInit();
  }

  getDataPerusahaan(BuildContext context) async {
    CustomWidget.customLoadingPopUp(context: context);
    try {
      ApiResponse? result = await ApiHelper().getDataPerusahaan();
      if (result == null) return;
      if (result.code == 200 && result.success == true) {
        xDataPerusahaan = DataPerusahaanModel.fromJson(result.data);
        await xPref.setString("DataPerusahaan", jsonEncode(xDataPerusahaan!.toJson()));
      }
    } catch (e) {
      print(e);
    }
    Get.back();
  }

  deleteAllDatabases() async {
    await DatabaseConnection.resetDatabase();
  }

  getLogin({
    required BuildContext context,
    required bool pIsRelogin,
    required String pUsername,
    required String pPassword,
    String? pIduser,
  }) async {
    try {
      CustomWidget.customLoadingPopUp(context: context);
      ApiResponse? result = await ApiHelper().getLogin(
        pIsRelogin: pIsRelogin,
        pPassword: pPassword,
        pUsername: pUsername,
        pIdPerusahaan: xDataPerusahaan!.idperusahaan ?? "",
        pIdUser: pIduser,
      );
      Get.back();

      if (result != null) {
        print(result);
        if (result.success && result.code == 200) {
          final user = jsonEncode(result.data);
          await xPref.setString("UserData", user);
          Get.toNamed(AppRoutes.DASHBOARD);
        } else {
          CustomWidget.customAlertPopUp(
            context: context,
            pInformation: CustomText(
              result.message,
              fontSize: Listfontsize.px14,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
          );
        }
      }
    } catch (e) {
      Get.back();
      print(e);
    }
  }
}
