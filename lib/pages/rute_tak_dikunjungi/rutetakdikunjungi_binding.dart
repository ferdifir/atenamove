import 'package:atenamove/pages/rute_tak_dikunjungi/rutetakdikunjungi_controller.dart';
import 'package:get/get.dart';

class RuteTidakDikunjungiBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RuteTidakDikunjungiController>(() => RuteTidakDikunjungiController());
  }
}
