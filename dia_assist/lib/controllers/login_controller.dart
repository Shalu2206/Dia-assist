import 'dart:io';
import 'package:dia_assist/pages/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class LoginController extends GetxController {
  late Interpreter interpreter; // Declare the interpreter

  @override
  void onInit() {
    super.onInit();
    loadModel();
  }

  // Observable variables for username and password
  var username = ''.obs;
  var password = ''.obs;
  var selectedGender = ''.obs;
  var selectedTension = ''.obs;
  var selectedDisease = ''.obs;
  var selectedSmoking = ''.obs;

  // Text controllers for input fields
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Observables for managing UI state
  var isObscure = true.obs;
  var showUsernameError = false.obs;
  var showPasswordError = false.obs;

  // Toggle password visibility
  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }

  // Validate login fields
  void validateFields() {
    showUsernameError.value = usernameController.text.isEmpty;
    showPasswordError.value = passwordController.text.isEmpty;
  }

  // Load the model into the interpreter
  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/diabetes_model.tflite');
  }

  // Handle login functionality (logic-only, no storage)
  Future<void> login() async {
    // Validate fields
    validateFields();

    if (!showUsernameError.value && !showPasswordError.value) {
      try {
        // Simulate successful login
        // Replace this with logic to handle the login action locally
        print("Login successful for username: ${usernameController.text}");
        Get.to(HomePage()); // Adjust route name as per your project
      } catch (e) {
        // Handle local errors
        Get.snackbar(
          'Error',
          'Failed to perform the action. Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  // Simulated FCM token update logic (no storage)
  Future<void> updateFcmToken() async {
    if (!kIsWeb && !Platform.isWindows) {
      try {
        // Simulate fetching and using the FCM token
        const dummyFcmToken = "dummy_fcm_token";
        print('Simulated FCM token update: $dummyFcmToken');
      } catch (e) {
        // Handle exceptions
        print('Exception while updating FCM token: $e');
      }
    }
  }
}
