import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
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
      backgroundColor: const Color(0XFFD2F5F2),
      appBar: AppBar(
        backgroundColor: const Color(0XFF31F0E0),
        title: const Text('DIA-ASSIST', style: TextStyle(fontSize: 24)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(
                              [
                                'Dia-predict',
                                'Dia-Medicate',
                                'Previously recorded data',
                                'Dia-Chat',
                                'About'
                              ][index],
                            ),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              switch (index) {
                                case 0:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PredictScreen(),
                                    ),
                                  );
                                  break;
                                case 1:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MedicateScreen(),
                                    ),
                                  );
                                  break;
                                case 2:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const RecordedDataScreen(),
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
                                      builder: (context) => const AboutScreen(), // This should work now
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
    );
  }
}

class PredictScreen extends StatelessWidget {
  const PredictScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dia-predict'),
      ),
      body: Center(
        child: const Text('Prediction functionality goes here'),
      ),
    );
  }
}

class MedicateScreen extends StatelessWidget {
  const MedicateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dia-Medicate'),
      ),
      body: Center(
        child: const Text('Medication functionality goes here'),
      ),
    );
  }
}

class RecordedDataScreen extends StatelessWidget {
  const RecordedDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previously Recorded Data'),
      ),
      body: Center(
        child: const Text('Recorded data functionality goes here'),
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
