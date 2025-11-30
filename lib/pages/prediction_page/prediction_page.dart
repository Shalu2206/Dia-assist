import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../controllers/login_controller.dart';
import '../../themes/colors_theme.dart';
import '../../models/prediction_entry.dart';
import '../../shared_data/prediction_data_store.dart';

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController hba1cController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _result = "";

  late Interpreter interpreter;
  final LoginController controller = Get.find<LoginController>();

  final ScrollController _scrollController =
      ScrollController(); // 👈 For auto-scroll

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

  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/diabetes_model.tflite');
  }

  performPrediction() async {
    double age = double.tryParse(ageController.text) ?? 0.0;
    double bmi = double.tryParse(bmiController.text) ?? 0.0;
    double hba1c = double.tryParse(hba1cController.text) ?? 0.0;
    double glucose = double.tryParse(glucoseController.text) ?? 0.0;

    String gender = controller.selectedGender.value;
    String hypertension = controller.selectedTension.value;
    String heartDisease = controller.selectedDisease.value;
    String smokingHistory = controller.selectedSmoking.value;

    if (age == 0.0 ||
        bmi == 0.0 ||
        hba1c == 0.0 ||
        glucose == 0.0 ||
        gender.isEmpty ||
        hypertension.isEmpty ||
        heartDisease.isEmpty ||
        smokingHistory.isEmpty) {
      Get.defaultDialog(
        title: "Input Error",
        middleText: "Please fill all fields correctly.",
      );
      return;
    }

    // Encoding
    int genderValue = gender == 'Male' ? 0 : 1;
    int hypertensionValue = hypertension == 'Yes' ? 1 : 0;
    int heartDiseaseValue = heartDisease == 'Yes' ? 1 : 0;

    int smokingValue;
    if (smokingHistory == 'Never') {
      smokingValue = 0;
    } else if (smokingHistory == 'No Info') {
      smokingValue = 1;
    } else {
      smokingValue = 2;
    }

    var input = [
      [
        genderValue.toDouble(),
        age,
        hypertensionValue.toDouble(),
        heartDiseaseValue.toDouble(),
        smokingValue.toDouble(),
        bmi,
        hba1c,
        glucose
      ]
    ];

    var output = List.generate(1, (_) => List.filled(1, 0.0));

    try {
      interpreter.run(input, output);
    } catch (e) {
      print("Model error: $e");
      return;
    }

    double prediction = output[0][0];

    _processPrediction(prediction, gender, age, bmi, hba1c, glucose);
  }

  void _processPrediction(
    double prediction,
    String gender,
    double age,
    double bmi,
    double hba1c,
    double glucose,
  ) async {
    String result;

    if (prediction > 0.00012329) {
      result = "Positive 🙁";
    } else if (prediction > 0.00002576) {
      result = "Pre-Diabetes 😐";
    } else {
      result = "Negative 😃";
    }

    // Save to history
    PredictionDataStore.entries.add(
      PredictionEntry(
        gender: gender,
        age: age.toInt(),
        bmi: bmi,
        hba1c: hba1c,
        glucose: glucose,
        result: result,
        timestamp: DateTime.now(),
      ),
    );

    setState(() {
      _result = result;
    });

    // 👇 CLOSE KEYBOARD
    FocusScope.of(context).unfocus();

    // 👇 DELAY + AUTO SCROLL
    await Future.delayed(const Duration(milliseconds: 300));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration boxShadow = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.white60)],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 63, 94),
        title: Text("Diabetes Prediction",
            style: TextStyle(color: AppColors.background)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
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
            controller: _scrollController,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdown("Gender", controller.selectedGender,
                      ["Male", "Female"], boxShadow),
                  SizedBox(height: 20),
                  _buildTextField("Age", ageController, boxShadow),
                  SizedBox(height: 20),
                  _buildDropdown("Hypertension", controller.selectedTension,
                      ["Yes", "No"], boxShadow),
                  SizedBox(height: 20),
                  _buildDropdown("Heart Disease", controller.selectedDisease,
                      ["Yes", "No"], boxShadow),
                  SizedBox(height: 20),
                  _buildDropdown("Smoking History", controller.selectedSmoking,
                      ["Never", "No Info", "Current"], boxShadow),
                  SizedBox(height: 20),
                  _buildTextField("BMI", bmiController, boxShadow),
                  SizedBox(height: 20),
                  _buildTextField("HBA1C", hba1cController, boxShadow),
                  SizedBox(height: 20),
                  _buildTextField(
                      "Blood Glucose Level", glucoseController, boxShadow),
                  SizedBox(height: 20),

                  // SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          performPrediction();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 10, 63, 94),
                        elevation: 10,
                      ),
                      child: Text(
                        "Submit",
                        style: GoogleFonts.openSans(
                            color: AppColors.background, fontSize: 18),
                      ),
                    ),
                  ),

                  if (_result.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            _result,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary),
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

  // UI Widgets
  Widget _buildTextField(
      String label, TextEditingController controller, BoxDecoration shadow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(color: AppColors.background, fontSize: 16)),
        SizedBox(height: 8),
        Container(
          decoration: shadow,
          child: TextFormField(
            style: TextStyle(color: AppColors.secondary),
            controller: controller,
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? "Please enter $label" : null,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, RxString selectedValue,
      List<String> items, BoxDecoration shadow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(color: AppColors.background, fontSize: 16)),
        SizedBox(height: 8),
        Obx(() => Container(
              decoration: shadow,
              child: DropdownButtonFormField<String>(
                value: selectedValue.value.isEmpty ? null : selectedValue.value,
                items: items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                dropdownColor: AppColors.background,
                onChanged: (value) => selectedValue.value = value!,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            )),
      ],
    );
  }
}
