import 'package:get/get.dart';
import 'package:practical/pages/dashboard/dashboard_binding.dart';
import 'package:practical/pages/splash.dart';

import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => SplashScreen(),
      binding: DashboardBinding(),
    ),
  ];
}
