import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'controllers/bindings/login_binding.dart';
import 'routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      initialBinding: LoginBinding(), // Global binding
      getPages: AppPages.routes,
      initialRoute: '/login',
    ),
  );
}