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
      // value: "https://csb.atena.id/",
      value: "http://192.168.1.29/ljc/",
    ),
  ];
  RxBool xIsShowPassword = false.obs;
  Rx<DropDownModel> selectedPerusahaan = DropDownModel(text: "", value: "").obs;
  final xPref = SharedPreferencesService();
  DataPerusahaanModel? xDataPerusahaan;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _checkLogin();
    });
  }

  _checkLogin() async {
    if (Get.arguments != null && Get.arguments) return;
    try {
      CustomWidget.customLoadingPopUp(context: Get.context!);
      final user = await xPref.getUser();
      if (user.iduser == null) {
        return Get.back();
      }
      final userPasswd = xPref.getString("UserPassword");
      ApiResponse? result = await ApiHelper().getLogin(
        pIsRelogin: user.login == "1",
        pIdPerusahaan: user.idperusahaan ?? "",
        pIdUser: user.iduser ?? "",
        pUsername: user.username ?? "",
        pPassword: userPasswd ?? "",
      );
      Get.back();
      if (result == null) return;
      if (result.code == 200 && result.success) {
        await xPref.setString("UserData", jsonEncode(result.data));
        Get.offAllNamed(AppRoutes.DASHBOARD);
      }
    } catch (e) {
      print(e);
    }
  }

  getDataPerusahaan(BuildContext context) async {
    CustomWidget.customLoadingPopUp(context: context);
    try {
      await xPref.setString("UrlAPI", selectedPerusahaan.value.value ?? "");
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
        if (result.success && result.code == 200) {
          final user = jsonEncode(result.data);
          await xPref.setString("UserData", user);
          await xPref.setString("UserPassword", pPassword);
          Get.toNamed(AppRoutes.SELECT_ARMADA);
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
