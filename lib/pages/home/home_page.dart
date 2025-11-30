import 'package:dia_assist/pages/prediction_page/dia_chatbot.dart';
import 'package:dia_assist/pages/prediction_page/prediction_page.dart';
import 'package:dia_assist/themes/colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../prediction_page/monitoring.dart';
import '../prediction_page/previously_record_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late HomeController homeController;

  @override
  void initState() {
    super.initState();
    homeController = Get.put(HomeController(vsync: this));
  }

  @override
  void dispose() {
    homeController.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 126, 202, 225),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 63, 94),
        title: const Text(
          'DIA-ASSIST',
          style: TextStyle(fontSize: 24, color: AppColors.background),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        actions: const [
          Icon(Icons.notifications, color: Colors.white),
          SizedBox(width: 10),
          Icon(Icons.settings, color: Colors.white),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 10, 63, 94),
              Color.fromARGB(255, 126, 202, 225),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.all(15),
                child: FadeTransition(
                  opacity: homeController.logoAnimationController,
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/logo.webp'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              // Menu Options (4 items)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: List.generate(4, (index) {
                    final titles = [
                      'Dia-Predict',
                      'Previously recorded data',
                      'Dia-Chat',
                      'Dia-Monitor'
                    ];

                    return AnimatedBuilder(
                      animation: homeController.listItemControllers[index],
                      builder: (context, child) {
                        return ScaleTransition(
                          scale: Tween<double>(begin: 0.5, end: 1.0)
                              .animate(CurvedAnimation(
                            parent: homeController.listItemControllers[index],
                            curve: Curves.bounceOut,
                          )),
                          child: Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: ListTile(
                              title: Text(titles[index]),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                if (index == 0) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PredictionPage()));
                                } else if (index == 1) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RecordedDataScreen()));
                                } else if (index == 2) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DiabetesChatBotApp()));
                                } else if (index == 3) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GrbsMonitoringPage()));
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
