import 'dart:convert';

import 'package:atenamove/model/BarangModel.dart';
import 'package:atenamove/model/CustomerModel.dart';
import 'package:atenamove/model/ModelTransaksi.dart';
import 'package:atenamove/model/TransaksiModel.dart';
import 'package:get/get.dart';

class BarangController extends GetxController {
  final Rx<CustomerModel> xCustomer = CustomerModel().obs;
  final Rx<TransaksiModel> xTransaksi = TransaksiModel().obs;
  final RxList<BarangModel> xBarang = <BarangModel>[].obs;
  final modelTransaksi = ModelTransaksi();

  @override
  void onInit() {
    super.onInit();
    xCustomer.value = Get.arguments['customer'];
    xTransaksi.value = Get.arguments['transaksi'];
    final dataBarang = jsonDecode(xTransaksi.value.detail ?? '[]');
    print(dataBarang);
    dataBarang.forEach((element) => xBarang.add(BarangModel.fromJson(element)));
  }

  setBarangData(String idTransaksi, {String? alasan}) async {
    final catatan = alasan ?? "SESUAI PESANAN";
    await modelTransaksi.updateCatatan(catatan, idTransaksi);
  }
}
