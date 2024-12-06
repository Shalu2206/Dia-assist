import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/login_controller.dart';
import '../../../themes/colors_theme.dart';


class LoginPage extends GetView<LoginController>{

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           const  CircleAvatar(
                radius: 100,
            backgroundImage: AssetImage('assets/images/logo.jpg'),),
            Text(
              'SignIn',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 24),

            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: controller.usernameController,
                  onChanged: (value) => controller.username.value = value,
                  decoration: InputDecoration(
                    suffixIcon:  Icon(Icons.person, color: AppColors.blacklite),
                    contentPadding: const EdgeInsets.all(18),
                    labelText: 'Username',
                    labelStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18,color: Colors.black),
                    hintText: 'Enter your username',
                    hintStyle: Theme.of(context).textTheme.displayLarge?.copyWith(color:AppColors.blacktextfield,fontSize: 16),
                    floatingLabelStyle: const TextStyle(color:AppColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color:AppColors.primary,width: 1.2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: Colors.black,width: 1.2),
                    ),
                  ),
                ),
                if (controller.showUsernameError.value)
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Username cannot be empty',
                      style:Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
              ],
            )),
            const SizedBox(height: 24),

            // Password TextField with Error Message
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: controller.passwordController,
                  onChanged: (value) => controller.password.value = value,
                  obscureText: controller.isObscure.value,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(18),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isObscure.value ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.blacklite,
                      ),
                      onPressed: controller.toggleObscure,
                    ),
                    labelStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18,color: Colors.black),
                    floatingLabelStyle: const TextStyle(color:AppColors.primary),
                    hintText: 'Enter your password',
                    hintStyle: Theme.of(context).textTheme.displayLarge?.copyWith(color:AppColors.blacktextfield,fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color:AppColors.primary,width: 1.2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: Colors.black,width: 1.2),
                    ),
                  ),
                ),
                if (controller.showPasswordError.value)
                  Padding(
                    padding:const  EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Password cannot be empty',
                      style:Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
              ],
            )),
            const SizedBox(height: 32),

            // Login Button
            Obx(() => SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Always validate fields when the button is pressed
                  controller.validateFields();

                  // If both fields are not empty, proceed to login
                  if (controller.username.value.isNotEmpty && controller.password.value.isNotEmpty) {
                    controller.login();
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: controller.username.value.isNotEmpty && controller.password.value.isNotEmpty
                      ? AppColors.primary // Active color when both fields are filled
                      : Colors.grey, // Inactive color when fields are empty
                  disabledBackgroundColor: Colors.grey,
                ),
                child:  Text(
                  'Login',
                  style:GoogleFonts.openSans(color: Colors.white, fontSize: 18),
                ),
              ),
            )),


          ],
        ),
      ),
    );
  }
}
