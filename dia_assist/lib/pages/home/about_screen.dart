import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Dia-Assist'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: homeController.logoAnimationController,
              child: const Text(
                'Diabetes Awareness',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: homeController.logoAnimationController,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: const Text(
                    'Diabetes is a condition with high blood sugar levels. There are two types: Type 1 (the body doesn’t produce insulin) and Type 2 (the body doesn’t use insulin properly). If untreated, it can lead to complications like heart and kidney disease. Managing it with medication, diet, and exercise is crucial.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
