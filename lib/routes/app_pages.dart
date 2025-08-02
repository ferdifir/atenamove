import 'package:atenamove/pages/armada/select_armada_binding.dart';
import 'package:atenamove/pages/armada/select_armada_page.dart';
import 'package:atenamove/pages/barang/barang_binding.dart';
import 'package:atenamove/pages/barang/barang_page.dart';
import 'package:atenamove/pages/batalverifikasi/batalverifikasi_binding.dart';
import 'package:atenamove/pages/batalverifikasi/batalverifikasi_page.dart';
import 'package:atenamove/pages/dashboard/dashboard_binding.dart';
import 'package:atenamove/pages/dashboard/dashboard_page.dart';
import 'package:atenamove/pages/login/login_binding.dart';
import 'package:atenamove/pages/login/login_page.dart';
import 'package:atenamove/pages/outlet/outlet_binding.dart';
import 'package:atenamove/pages/outlet/outlet_page.dart';
import 'package:atenamove/pages/profile/profile_binding.dart';
import 'package:atenamove/pages/profile/profile_page.dart';
import 'package:atenamove/pages/rute_tak_dikunjungi/rutetakdikunjungi_binding.dart';
import 'package:atenamove/pages/rute_tak_dikunjungi/rutetakdikunjungi_page.dart';
import 'package:atenamove/pages/splash/splash_binding.dart';
import 'package:atenamove/pages/splash/splash_screen.dart';
import 'package:atenamove/pages/transaksi/transaksi_binding.dart';
import 'package:atenamove/pages/transaksi/transaksi_page.dart';
import 'package:atenamove/pages/verifikasi/verfikasi_page.dart';
import 'package:atenamove/pages/verifikasi/verifikasi_binding.dart';
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
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.OUTLET,
      page: () => const OutletPage(),
      binding: OutletBinding(),
    ),
    GetPage(
      name: AppRoutes.VERIFIKASI,
      page: () => const VerifikasiPage(),
      binding: VerifikasiBinding(),
    ),
    GetPage(
      name: AppRoutes.BATAL_VERIFIKASI,
      page: () => const BatalVerifikasiPage(),
      binding: BatalVerifikasiBinding(),
    ),
    GetPage(
      name: AppRoutes.TRANSAKSI,
      page: () => const TransaksiPage(),
      binding: TransaksiBinding(),
    ),
    GetPage(
      name: AppRoutes.BARANG,
      page: () => const BarangPage(),
      binding: BarangBinding(),
    ),
    GetPage(
      name: AppRoutes.RUTE_TAK_DIKUNJUNGI,
      page: () => const RuteTidakDikunjungiPage(),
      binding: RuteTidakDikunjungiBinding(),
    ),
  ];
}
