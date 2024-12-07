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
    try {
      interpreter = await Interpreter.fromAsset('assets/diabetes_model.tflite');
      print("Model loaded successfully.");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  performPrediction() async {
    // Parse inputs
    double age = double.tryParse(ageController.text) ?? 0.0;
    double bmi = double.tryParse(bmiController.text) ?? 0.0;
    double hba1c = double.tryParse(hba1cController.text) ?? 0.0;
    double glucose = double.tryParse(glucoseController.text) ?? 0.0;

    // Retrieve dropdown values
    String heartdisease = controller.selectedDisease.value;
    String gender = controller.selectedGender.value;
    String hypertension = controller.selectedTension.value;
    String smokingHistory = controller.selectedSmoking.value;

    // Convert dropdown values to numeric encoding
    int genderValue = gender == 'Male' ? 1 : 0;
    int hypertensionValue = hypertension == 'Yes' ? 1 : 0;
    int heartdiseaseValue = heartdisease == 'Yes' ? 1 : 0;
    int smokingHistoryValue = smokingHistory == 'Never'
        ? 0
        : (smokingHistory == 'No Info' ? 1 : 2); // 'Current'

    // Debugging: Print raw values
    print("Age: $age");
    print("BMI: $bmi");
    print("HBA1C: $hba1c");
    print("Glucose: $glucose");
    print("Gender: $gender -> $genderValue");
    print("Hypertension: $hypertension -> $hypertensionValue");
    print("Heart Disease: $heartdisease -> $heartdiseaseValue");
    print("Smoking History: $smokingHistory -> $smokingHistoryValue");

    // Validate inputs
    if (age == 0.0 || bmi == 0.0 || hba1c == 0.0 || glucose == 0.0 ||
        hypertension.isEmpty || smokingHistory.isEmpty || heartdisease.isEmpty || gender.isEmpty) {
      print("Error: Some input values are missing or invalid.");
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

    // Prepare input for the model
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

    // Debugging: Print input array
    print("Input to model: $input");

    // Prepare output tensor
    var output = List.filled(1, 0).reshape([1, 1]);

    // Run the model
    try {
      interpreter.run(input, output);
      print("Output from model: $output");
    } catch (e) {
      print('Error running the model: $e');
      return;
    }

    // Get the prediction result
    var prediction = output[0][0];
    print("Prediction result: $prediction");

    // Show the result in an AlertDialog
    _showSubmitDialog(context, prediction);
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration inputBoxShadow = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
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
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.background),
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
                  buildDropdown('Gender', ['Male', 'Female'], controller.selectedGender),
                  SizedBox(height: 20),
                  buildTextField('Age', ageController),
                  SizedBox(height: 20),
                  buildDropdown('Hypertension', ['Yes', 'No'], controller.selectedTension),
                  SizedBox(height: 20),
                  buildDropdown('Heart disease', ['Yes', 'No'], controller.selectedDisease),
                  SizedBox(height: 20),
                  buildDropdown('Smoking History', ['Never', 'No Info', 'Current'], controller.selectedSmoking),
                  SizedBox(height: 20),
                  buildTextField('BMI', bmiController),
                  SizedBox(height: 20),
                  buildTextField('HBA1C', hba1cController),
                  SizedBox(height: 20),
                  buildTextField('Blood Glucose Level', glucoseController),
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
                        style: GoogleFonts.openSans(color: AppColors.background, fontSize: 18),
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

  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.background)),
        SizedBox(height: 8),
        TextFormField(
          style: TextStyle(color: AppColors.background),
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget buildDropdown(String label, List<String> items, RxString selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.background)),
        SizedBox(height: 8),
        Obx(() => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.1),
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            dropdownColor: Colors.black,
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
            value: selectedValue.value.isEmpty ? null : selectedValue.value,
            onChanged: (value) {
              selectedValue.value = value!;
            },
          ),
        )),
      ],
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
        controller.selectedDisease.value.isNotEmpty;
  }

  void _showSubmitDialog(BuildContext context, var prediction) {
    String result = prediction > 0.5 ? "Positive" : "Negative";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Prediction Result'),
          content: Text('Your diabetes prediction is: $result'),
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
  }
}
