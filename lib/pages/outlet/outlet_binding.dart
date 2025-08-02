import 'package:atenamove/pages/outlet/outlet_controller.dart';
import 'package:get/get.dart';

class OutletBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OutletController>(() => OutletController());
  }
}
