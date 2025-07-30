import 'package:atenamove/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  Rx<String> username = ''.obs;
  Rx<String> perusahaan = ''.obs;
  Rx<String> depo = ''.obs; 
  RxMap<String, String> xListOmsetToko = Map<String, String>().obs;
  RxMap<String, String> xTotalPesananPerCustomer = <String, String>{}.obs;
  List xDataAO = [].obs;
  Rx<String> xJumlahAO = ''.obs;
  Rx<int> xJumlahCall = 0.obs;
  Rx<int> xJumlahOmzet = 0.obs;
  RxBool xIsLoading = false.obs;
  TextEditingController xSearch = TextEditingController(text: "");
  final xPref = SharedPreferencesService();

  @override
  void onInit() {
    super.onInit();
    _setUserInfo();
  }

  void _setUserInfo() async {
    final user = await xPref.getUser();
    username.value = user.username ?? '';
    perusahaan.value = user.namaperusahaan ?? '';
    depo.value = user.namadepo ?? '';
  }
}
