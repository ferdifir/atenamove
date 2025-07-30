import 'package:atenamove/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  void _routeToNextPage() {
    print("route to next page");
    Future.delayed(
      const Duration(seconds: 2),
      () => Get.offAllNamed(AppRoutes.LOGIN),
    );
  }

  @override
  void onInit() {
    super.onInit();
    print("onInit");
    _routeToNextPage();
  }
}
