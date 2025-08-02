import 'package:atenamove/pages/transaksi/transaksi_controller.dart';
import 'package:get/get.dart';

class TransaksiBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransaksiController>(() => TransaksiController());
  }
}
