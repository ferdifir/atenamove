import 'package:atenamove/pages/verifikasi/verifikasi_controller.dart';
import 'package:get/get.dart';

class VerifikasiBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifikasiController>(() => VerifikasiController());
  }
}
