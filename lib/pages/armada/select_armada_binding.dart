import 'package:atenamove/pages/armada/select_armada_controller.dart';
import 'package:get/get.dart';

class SelectArmadaBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectArmadaController>(() => SelectArmadaController());
  }
}
