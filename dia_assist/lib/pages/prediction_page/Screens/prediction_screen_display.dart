import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/login_controller.dart';
import '../../../themes/colors_theme.dart';

class PredictionScreenDisplay extends GetView<LoginController> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController hba1cController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    BoxDecoration inputBoxShadow = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1), // Shadow color
          blurRadius: 6, // Blur intensity
          offset: Offset(0, 3), // Offset of the shadow
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: const Icon(Icons.arrow_back, color: Colors.white)),
        backgroundColor: AppColors.primary,
        title: Text(
          'Diabetics Prediction',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: AppColors.background),
        ),
      ),
      body: Container(
        decoration:const  BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff010129d3),
              Color(0xFF400D0D8A),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Fill the required data',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(height: 20),
                Text('Gender', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
                SizedBox(height: 8),
                Obx(() => Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none, // Hide the default border
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: ['Male', 'Female']
                        .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
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
                Text('Age', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
                Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: TextFormField(
                    controller: ageController, // Assign the controller
                    keyboardType: TextInputType.number, // Only numeric input
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none, // Hide the default border
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Hypertension', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
                SizedBox(height: 8),
                Obx(() => Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none, // Hide the default border
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: ['Yes', 'No']
                        .map((tension) => DropdownMenuItem(
                      value: tension,
                      child: Text(tension),
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
                Text('Smoking History', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
                SizedBox(height: 8),
                Obx(() => Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none, // Hide the default border
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: ['Never', 'No Info', 'Current']
                        .map((smoking) => DropdownMenuItem(
                      value: smoking,
                      child: Text(smoking),
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
                Text('Heart Disease', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
                SizedBox(height: 8),
                Obx(() => Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none, // Hide the default border
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: ['Yes', 'No']
                        .map((disease) => DropdownMenuItem(
                      value: disease,
                      child: Text(disease),
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
                Text('BMI', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
                Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: TextFormField(
                    controller: bmiController, // Assign the controller
                    keyboardType: TextInputType.number, // Only numeric input
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none, // Hide the default border
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('HBA1C', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
                Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: TextFormField(
                    controller: hba1cController, // Assign the controller
                    keyboardType: TextInputType.number, // Only numeric input
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none, // Hide the default border
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Blood Glucose Level', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
                Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: TextFormField(
                    controller: glucoseController, // Assign the controller
                    keyboardType: TextInputType.number, // Only numeric input
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none, // Hide the default border
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Weight (in KG)', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
                Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: TextFormField(
                    controller: weightController, // Assign the controller
                    keyboardType: TextInputType.number, // Only numeric input
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none, // Hide the default border
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                 SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(
                      'Submit',
                      style: GoogleFonts.openSans(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
