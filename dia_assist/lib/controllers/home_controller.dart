import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  late AnimationController logoAnimationController;
  late List<AnimationController> listItemControllers;

  final TickerProvider vsync;

  HomeController({required this.vsync});

  @override
  void onInit() {
    super.onInit();
    logoAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    );

    listItemControllers = List.generate(5, (index) {
      return AnimationController(
        duration: const Duration(seconds: 2),
        vsync: vsync,
      );
    });

    logoAnimationController.forward();

    Future.delayed(const Duration(seconds: 1), () {
      for (int i = 0; i < listItemControllers.length; i++) {
        Future.delayed(Duration(milliseconds: 300 * i), () {
          listItemControllers[i].forward();
        });
      }
    });
  }

  @override
  void onClose() {
    logoAnimationController.dispose();
    for (var controller in listItemControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
