import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../../controllers/login_controller.dart';
import '../../themes/colors_theme.dart';

class PredictionScreenDisplay extends StatefulWidget {
  @override
  _PredictionScreenDisplayState createState() => _PredictionScreenDisplayState();
}

class _PredictionScreenDisplayState extends State<PredictionScreenDisplay> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController hba1cController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Interpreter interpreter;

  // Initialize the LoginController with Get.find()
  final LoginController controller = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  // Load the model
  loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/diabetes_model.tflite');
  }

  performPrediction() async {
    double age = double.tryParse(ageController.text) ?? 0.0;
    double bmi = double.tryParse(bmiController.text) ?? 0.0;
    double hba1c = double.tryParse(hba1cController.text) ?? 0.0;
    double glucose = double.tryParse(glucoseController.text) ?? 0.0;

    String heartdisease = controller.selectedDisease
        .value;
    String gender = controller.selectedGender
        .value;
    String hypertension = controller.selectedTension
        .value;
    String smokingHistory = controller.selectedSmoking
        .value;

    // Convert dropdown values to numeric encoding
    int genderValue = hypertension == 'Yes' ? 1 : 0;
    int hypertensionValue = hypertension == 'Yes' ? 1 : 0;
    int heartdiseaseValue = heartdisease == 'Yes' ? 1 : 0;
    int smokingHistoryValue;
    if (smokingHistory == 'Never') {
      smokingHistoryValue = 0;
    } else if (smokingHistory == 'No Info') {
      smokingHistoryValue = 1;
    } else {
      smokingHistoryValue = 2; // 'Current'
    }

    // Ensure no null values are passed
    if (age == 0.0 || bmi == 0.0 || hba1c == 0.0 || glucose == 0.0 ||
        hypertension.isEmpty || smokingHistory.isEmpty || heartdisease.isEmpty || gender.isEmpty) {
      // You can show an error message if any field is empty or invalid
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

    // Prepare output tensor
    var output = List.filled(1, 0).reshape([1, 1]);

    // Run the model
    try {
      interpreter.run(input, output);
    } catch (e) {
      print('Error running the model: $e');
      return;
    }

    // Get the prediction result (0 or 1)
    var prediction = output[0][0];

    // Show the result in an AlertDialog
    _showSubmitDialog(context, prediction);
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration inputBoxShadow = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1), // Shadow color
          blurRadius: 6,
          offset: Offset(0, 3),
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
                          dropdownColor: Colors.black,
                          items: ['Male', 'Female']
                              .map((gender) =>
                              DropdownMenuItem(
                                value: gender,
                                child: Text(gender,
                                    style: TextStyle(color: Colors.white)),
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
                      style: TextStyle(color: AppColors.background),
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
                          dropdownColor: Colors.black,
                          items: ['Yes', 'No']
                              .map((tension) =>
                              DropdownMenuItem(
                                value: tension,
                                child: Text(tension,
                                    style: TextStyle(color: Colors.white)),
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
                          dropdownColor: Colors.black,
                          items: ['Yes', 'No']
                              .map((disease) =>
                              DropdownMenuItem(
                                value: disease,
                                child: Text(disease,
                                    style: TextStyle(color: Colors.white)),
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
                          dropdownColor: Colors.black,
                          items: ['Never', 'No Info', 'Current']
                              .map((smoking) =>
                              DropdownMenuItem(
                                value: smoking,
                                child: Text(smoking,
                                    style: TextStyle(color: Colors.white)),
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
                      style: TextStyle(color: AppColors.background),
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
                      style: TextStyle(color: AppColors.background),
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
                      style: TextStyle(color: AppColors.background),
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
                        backgroundColor: isFormValid()
                            ? Colors.grey
                            : Color.fromARGB(255, 10, 63, 94),
                      ),
                      child: Text(
                        'Submit',
                        style: GoogleFonts.openSans(color: AppColors.background,
                            fontSize: 18),
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

  bool isFormValid() {
    return ageController.text.isNotEmpty &&
        bmiController.text.isNotEmpty &&
        hba1cController.text.isNotEmpty &&
        glucoseController.text.isNotEmpty &&
        controller.selectedGender.value.isNotEmpty &&
        controller.selectedTension.value.isNotEmpty &&
        controller.selectedSmoking.value.isNotEmpty &&
        controller.selectedDisease.value.isNotEmpty ;

  }


  void _showSubmitDialog(BuildContext context, var prediction) {
    String result = prediction > 0.5
        ? "Positive"
        : "Negative";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Prediction Result'),
          content: Text('Your diabetes prediction is: $result'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}