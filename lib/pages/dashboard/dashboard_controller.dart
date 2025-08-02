import 'package:atenamove/api/api_response.dart';
import 'package:atenamove/config/apiHelper.dart';
import 'package:atenamove/model/CustomerModel.dart';
import 'package:atenamove/model/ModelCustomer.dart';
import 'package:atenamove/model/ModelTransaksi.dart';
import 'package:atenamove/routes/app_routes.dart';
import 'package:atenamove/utils/sharedpref.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  Rx<String> username = ''.obs;
  Rx<String> perusahaan = ''.obs;
  Rx<String> depo = ''.obs;
  Rx<String> xTotalTransaksi = ''.obs;
  RxMap<String, String> xListOmsetToko = Map<String, String>().obs;
  RxMap<String, String> xTotalPesananPerCustomer = <String, String>{}.obs;
  List xDataAO = [].obs;
  Rx<String> xJumlahAO = ''.obs;
  Rx<int> xJumlahCall = 0.obs;
  Rx<int> xJumlahOmzet = 0.obs;
  RxBool xIsLoading = false.obs;
  TextEditingController xSearch = TextEditingController(text: "");
  final xPref = SharedPreferencesService();
  final modelCustomer = ModelCustomer();
  RxInt xTotalsaldo = 0.obs;
  RxInt xTotalpenjualan = 0.obs;
  RxInt xTotalpermintaanretur = 0.obs;
  List<CustomerModel> listCustomer = [];
  RxList<CustomerModel> xCustomerList = RxList<CustomerModel>([]);
  List<Map> customerLisBlmCheckout = [];

  @override
  void onInit() {
    super.onInit();
    _setUserInfo();
    getCustomerList();
    _checkVerifikasi();
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

  void _setUserInfo() async {
    final user = await xPref.getUser();
    username.value = user.username ?? '';
    perusahaan.value = user.namaperusahaan ?? '';
    depo.value = user.namadepo ?? '';
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

  void searchCustomer(String query) {
    xCustomerList.clear();

    if (query.isEmpty) {
      print("Kosong");
      xCustomerList.addAll(listCustomer);
      xCustomerList.refresh();
      return;
    }
    print("Query: $query");
    final lowerCaseQuery = query.toLowerCase();
    xCustomerList.addAll(listCustomer.where(
      (customer) => customer.namacustomer!.toLowerCase().contains(lowerCaseQuery) || customer.kodecustomer!.toLowerCase().contains(lowerCaseQuery),
    ));
    xCustomerList.refresh();
  }

  Future<void> getCustomerList() async {
    try {
      final dataCustomer = await modelCustomer.selectWithGrandtotal(null);
      listCustomer.clear();
      for (var element in dataCustomer) {
        listCustomer.add(CustomerModel.fromJson(element));
        final grandTotal = element['grandtotal'].toString();
        final grandTotalPenjualan = element['grandtotalpenjualan'].toString();
        final grandTotalPermintaanRetur = element['grandtotalpermintaanretur'].toString();
        print("Grand Total: $grandTotal || Grand Total Penjualan: $grandTotalPenjualan || Grand Total Permintaan Retur: $grandTotalPermintaanRetur");

        xTotalsaldo += double.parse(grandTotal).toInt();
        xTotalpenjualan += double.parse(grandTotalPenjualan).toInt();
        xTotalpermintaanretur += double.parse(grandTotalPermintaanRetur).toInt();
        if (element['tglcheckin'] != null && element['tglcheckout'] == null) {
          customerLisBlmCheckout.add({
            'idcustomer': element["idcustomer"],
            'kodecustomer': element["kodecustomer"],
            'namacustomer': element["namacustomer"],
          });
        }
        print("Customer Blm Checkout: $customerLisBlmCheckout");
      }
      xCustomerList.addAll(listCustomer);
      ModelTransaksi modelTransaksi = ModelTransaksi();
      int? jmlData = await modelTransaksi.selectJmlData();
      xTotalTransaksi.value = (jmlData ?? 0).toString();
    } catch (e) {
      print("Error Get Customer: $e");
      Get.back();
    }
  }
}
