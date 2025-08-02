import 'package:atenamove/model/CustomerModel.dart';
import 'package:atenamove/model/ModelTransaksi.dart';
import 'package:atenamove/model/TransaksiModel.dart';
import 'package:atenamove/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransaksiController extends GetxController {
  RxString xNamaSopir = "".obs;
  final xPref = SharedPreferencesService();
  Rx<TextEditingController> xSearchTextField = TextEditingController().obs;
  RxList<TransaksiModel> xListTransaksi = <TransaksiModel>[].obs;
  List<TransaksiModel> listTransaksi = [];
  final modelTransaksi = ModelTransaksi();
  final CustomerModel customer = Get.arguments;
  RxDouble xTotalJual = 0.0.obs;
  RxDouble xTotalPr = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    final user = await xPref.getUser();
    xNamaSopir.value = user.username ?? '';
    await getListTransaksi();
  }

  searchTransaksi(String value) {
    xListTransaksi.clear();
    if (value.isEmpty) {
      xListTransaksi.addAll(listTransaksi);
    } else {
      xListTransaksi.addAll(listTransaksi.where((element) => element.kodetrans!.toLowerCase().contains(value.toLowerCase())).toList());
    }
    xListTransaksi.refresh();
  }

  getListTransaksi() async {
    final dataTransaksi = await modelTransaksi.selectByIDArmadaCustomer(customer.idcustomer);
    listTransaksi.clear();
    xListTransaksi.clear();
    xTotalJual.value = 0.0;
    xTotalPr.value = 0.0;
    for (var element in dataTransaksi) {
      listTransaksi.add(TransaksiModel.fromJson(element));
      if (element['jenistrans'] == 'PENJUALAN') {
        xTotalJual.value += double.parse(element['grandtotalraw'].toString());
      } else {
        xTotalPr.value += double.parse(element['grandtotalraw'].toString());
      }
    }
    xListTransaksi.addAll(listTransaksi);
  }
}
