import 'package:get/get.dart';
import '../controllers/bindings/login_binding.dart';
import '../pages/login/screens/login_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/login',
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/home',
      page: () => LoginPage(),
    ),
  ];
}
