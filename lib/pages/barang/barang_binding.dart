import 'package:atenamove/pages/barang/barang_controller.dart';
import 'package:get/get.dart';

class BarangBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BarangController>(() => BarangController());
  }
}
