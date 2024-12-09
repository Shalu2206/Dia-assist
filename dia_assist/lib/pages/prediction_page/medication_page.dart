import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../../controllers/login_controller.dart';
import '../../themes/colors_theme.dart';

class MedicateScreen extends StatefulWidget {
  @override
  _MedicateScreenState createState() => _MedicateScreenState();
}

class _MedicateScreenState extends State<MedicateScreen> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController hba1cController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _result = '';

  late Interpreter interpreter;

  final LoginController controller = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  void dispose() {
    ageController.dispose();
    bmiController.dispose();
    hba1cController.dispose();
    glucoseController.dispose();

    controller.selectedGender.value = '';
    controller.selectedTension.value = '';
    controller.selectedDisease.value = '';
    controller.selectedSmoking.value = '';

    super.dispose();
  }

  loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/diabetes_model.tflite');
  }

  performPrediction() async {
    double age = double.tryParse(ageController.text) ?? 0.0;
    double bmi = double.tryParse(bmiController.text) ?? 0.0;
    double hba1c = double.tryParse(hba1cController.text) ?? 0.0;
    double glucose = double.tryParse(glucoseController.text) ?? 0.0;

    String heartdisease = controller.selectedDisease.value;
    String gender = controller.selectedGender.value;
    String hypertension = controller.selectedTension.value;
    String smokingHistory = controller.selectedSmoking.value;

    // Convert dropdown values to numeric encoding
    int genderValue = gender == 'Male' ? 0 : 1; // Male=0, Female=1
    int hypertensionValue = hypertension == 'Yes' ? 1 : 0; // Yes=1, No=0
    int heartdiseaseValue = heartdisease == 'Yes' ? 1 : 0; // Yes=1, No=0
    int smokingHistoryValue;
    if (smokingHistory == 'Never') {
      smokingHistoryValue = 0; // Never=0
    } else if (smokingHistory == 'No Info') {
      smokingHistoryValue = 1; // No Info=1
    } else {
      smokingHistoryValue = 2; // Current=2
    }

    // Ensure no null values are passed
    if (age == 0.0 || bmi == 0.0 || hba1c == 0.0 || glucose == 0.0 ||
        hypertension.isEmpty || smokingHistory.isEmpty ||
        heartdisease.isEmpty || gender.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Input Error'),
            content: Text('Please enter valid values for all fields.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Prepare the input for the model
    var input = [
      [
        genderValue.toDouble(),
        age,
        hypertensionValue.toDouble(),
        heartdiseaseValue.toDouble(),
        smokingHistoryValue.toDouble(),
        bmi,
        hba1c,
        glucose,
      ]
    ];

    var output = List.filled(1, 0).reshape([1, 1]);

    // Run the model
    try {
      interpreter.run(input, output);
    } catch (e) {
      print('Error running the model: $e');
      return;
    }
    var prediction = output[0][0];
    String formattedPrediction = prediction.toStringAsFixed(8);

    double finalPrediction = double.tryParse(formattedPrediction) ?? 0.0;

    _showSubmitDialog(context, finalPrediction);
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration inputBoxShadow = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.white60,
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 10, 63, 94),
        title: Text(
          'Diabetes Prediction',
          style: Theme
              .of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: AppColors.background),
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gender Dropdown
                  Text('Gender', style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.background)),
                  SizedBox(height: 8),
                  Obx(() =>
                      Container(
                        decoration: inputBoxShadow,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          dropdownColor: AppColors.background,
                          items: ['Male', 'Female']
                              .map((gender) =>
                              DropdownMenuItem(
                                value: gender,
                                child: Text(gender,
                                    style: TextStyle(
                                        color: AppColors.secondary)),
                              ))
                              .toList(),
                          value: controller.selectedGender.value.isEmpty
                              ? null
                              : controller.selectedGender.value,
                          onChanged: (value) {
                            controller.selectedGender.value = value!;
                          },
                        ),
                      )),
                  SizedBox(height: 20),

                  // Age Field
                  Text('Age', style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.background)),
                  Container(
                    decoration: inputBoxShadow,
                    child: TextFormField(
                      style: TextStyle(color: AppColors.secondary),
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter age';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  // Hypertension Dropdown
                  Text('Hypertension', style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.background)),
                  SizedBox(height: 8),
                  Obx(() =>
                      Container(
                        decoration: inputBoxShadow,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          dropdownColor: AppColors.background,
                          items: ['Yes', 'No']
                              .map((tension) =>
                              DropdownMenuItem(
                                value: tension,
                                child: Text(tension,
                                    style: TextStyle(
                                        color: AppColors.secondary)),
                              ))
                              .toList(),
                          value: controller.selectedTension.value.isEmpty
                              ? null
                              : controller.selectedTension.value,
                          onChanged: (value) {
                            controller.selectedTension.value = value!;
                          },
                        ),
                      )),
                  SizedBox(height: 20),

                  Text('Heart disease', style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.background)),
                  SizedBox(height: 8),
                  Obx(() =>
                      Container(
                        decoration: inputBoxShadow,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          dropdownColor: AppColors.background,
                          items: ['Yes', 'No']
                              .map((disease) =>
                              DropdownMenuItem(
                                value: disease,
                                child: Text(disease,
                                    style: TextStyle(
                                        color: AppColors.secondary)),
                              ))
                              .toList(),
                          value: controller.selectedDisease.value.isEmpty
                              ? null
                              : controller.selectedDisease.value,
                          onChanged: (value) {
                            controller.selectedDisease.value = value!;
                          },
                        ),
                      )),
                  SizedBox(height: 20),


                  // Smoking History Dropdown
                  Text('Smoking History', style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.background)),
                  SizedBox(height: 8),
                  Obx(() =>
                      Container(
                        decoration: inputBoxShadow,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          dropdownColor: AppColors.background,
                          items: ['Never', 'No Info', 'Current']
                              .map((smoking) =>
                              DropdownMenuItem(
                                value: smoking,
                                child: Text(smoking,
                                    style: TextStyle(
                                        color: AppColors.secondary)),
                              ))
                              .toList(),
                          value: controller.selectedSmoking.value.isEmpty
                              ? null
                              : controller.selectedSmoking.value,
                          onChanged: (value) {
                            controller.selectedSmoking.value = value!;
                          },
                        ),
                      )),
                  SizedBox(height: 20),

                  // BMI Field
                  Text('BMI', style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.background)),
                  Container(
                    decoration: inputBoxShadow,
                    child: TextFormField(
                      style: TextStyle(color: AppColors.secondary),
                      controller: bmiController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter BMI';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  // HBA1C Field
                  Text('HBA1C', style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.background)),
                  Container(
                    decoration: inputBoxShadow,
                    child: TextFormField(
                      style: TextStyle(color: AppColors.secondary),
                      controller: hba1cController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter HBA1C';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  // Blood Glucose Level Field
                  Text('Blood Glucose Level', style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.background)),
                  Container(
                    decoration: inputBoxShadow,
                    child: TextFormField(
                      style: TextStyle(color: AppColors.secondary),
                      controller: glucoseController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter glucose level';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          performPrediction();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        backgroundColor: Color.fromARGB(255, 10, 63, 94),
                      ),
                      child: Text(
                        'Submit',
                        style: GoogleFonts.openSans(color: AppColors.background,
                            fontSize: 18),
                      ),
                    ),
                  ),
                  // Display result after prediction
                  if (_result.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _result,
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSubmitDialog(BuildContext context, var prediction) {
    String result;

    if (prediction > 0.00012329) {
      result = "Positive 🙁";
    } else if (prediction > 0.00002576 && prediction <= 0.00012329) {
      result = "Pre-Diabetes 😐";
    } else {
      result = "Negative 😃";
    }
    print(prediction);
    print(result);
    setState(() {
      _result = result;
    });
  }

  bool isFormValid() {
    return ageController.text.isNotEmpty &&
        bmiController.text.isNotEmpty &&
        hba1cController.text.isNotEmpty &&
        glucoseController.text.isNotEmpty &&
        controller.selectedGender.value.isNotEmpty &&
        controller.selectedTension.value.isNotEmpty &&
        controller.selectedSmoking.value.isNotEmpty &&
        controller.selectedDisease.value.isNotEmpty;
  }
}