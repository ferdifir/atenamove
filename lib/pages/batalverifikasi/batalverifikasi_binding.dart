import 'package:atenamove/pages/batalverifikasi/batalverifikasi_controller.dart';
import 'package:get/get.dart';

class BatalVerifikasiBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BatalVerifikasiController>(() => BatalVerifikasiController());
  }
}
