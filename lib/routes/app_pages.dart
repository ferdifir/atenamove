import 'package:atenamove/pages/armada/select_armada_binding.dart';
import 'package:atenamove/pages/armada/select_armada_page.dart';
import 'package:atenamove/pages/dashboard/dashboard_binding.dart';
import 'package:atenamove/pages/dashboard/dashboard_page.dart';
import 'package:atenamove/pages/login/login_binding.dart';
import 'package:atenamove/pages/login/login_page.dart';
import 'package:atenamove/pages/splash/splash_binding.dart';
import 'package:atenamove/pages/splash/splash_screen.dart';
import 'package:atenamove/routes/app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static List<GetPage> routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.SELECT_ARMADA,
      page: () => const SelectArmadaPage(),
      binding: SelectArmadaBinding(),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
  ];
}