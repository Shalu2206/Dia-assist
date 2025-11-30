import 'package:dia_assist/controllers/home_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(vsync: Get.find()));
  }
}
