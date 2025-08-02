import 'package:atenamove/model/DatabaseConnection.dart';
import 'package:atenamove/routes/app_pages.dart';
import 'package:atenamove/routes/app_routes.dart';
import 'package:atenamove/theme/app_color.dart';
import 'package:atenamove/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseConnection.initDatabase();
  await SharedPreferencesService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Atena Move',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(
            AppColor.primaryColor,
          ),
        ),
        useMaterial3: false,
      ),
      initialRoute: AppRoutes.LOGIN,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
    );
  }
}
