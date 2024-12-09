import 'package:dia_assist/themes/colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../prediction_page/medication_page.dart';
import '../prediction_page/prediction_screen_display.dart';
import '../prediction_page/previously_record_data.dart';
import 'about_screen.dart';

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
        title: const Text('DIA-ASSIST', style: TextStyle(fontSize: 24,color: AppColors.background)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Back icon
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications,color: Colors.white,),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings,color: Colors.white,),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration:const  BoxDecoration(
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
              Padding(
                padding: const EdgeInsets.all(15.0),
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

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: List.generate(5, (index) {
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
                              title: Text(
                                [
                                  'Dia-predict',
                                  'Dia-Medicate',
                                  'Previously recorded data',
                                  'Dia-Chat',
                                  'Dia-Awareness'
                                ][index],
                              ),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PredictionScreenDisplay(),
                                      ),
                                    );
                                    break;
                                  case 1:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MedicateScreen(),
                                      ),
                                    );
                                    break;
                                  case 2:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        RecordedDataScreen(),
                                      ),
                                    );
                                    break;
                                  case 3:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ChatScreen(),
                                      ),
                                    );
                                    break;
                                  case 4:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const DiaAwarenessScreen(), // This should work now
                                      ),
                                    );
                                    break;
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

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dia-Chat'),
      ),
      body: Center(
        child: const Text('Chat functionality goes here'),
      ),
    );
  }
}
