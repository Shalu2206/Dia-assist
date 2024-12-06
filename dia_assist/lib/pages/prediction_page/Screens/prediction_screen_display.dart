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
        backgroundColor:Color.fromARGB(255, 10, 63, 94),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gender', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.background)),
                SizedBox(height: 8),
                Obx(() => Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    dropdownColor: Colors.black,
                    items: ['Male', 'Female']
                        .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender,style: TextStyle(color: Colors.white),),
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
                Text('Age', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.background)),
                Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: TextFormField(
                    controller: ageController, // Assign the controller
                    keyboardType: TextInputType.number, // Only numeric input
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Hypertension', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.background)),
                SizedBox(height: 8),
                Obx(() => Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    dropdownColor: Colors.black,
                    items: ['Yes', 'No']
                        .map((tension) => DropdownMenuItem(
                      value: tension,
                      child: Text(tension,style: TextStyle(color: Colors.white),),
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
                Text('Smoking History', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.background)),
                SizedBox(height: 8),
                Obx(() => Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),

                      ),
                    ),
                    dropdownColor: Colors.black,
                    items: ['Never', 'No Info', 'Current']
                        .map((smoking) => DropdownMenuItem(
                      value: smoking,
                      child: Text(smoking,style: TextStyle(color: Colors.white),),
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
                Text('Heart Disease', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.background)),
                SizedBox(height: 8),
                Obx(() => Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    dropdownColor: Colors.black,
                    items: ['Yes', 'No']
                        .map((disease) => DropdownMenuItem(
                      value: disease,
                      child: Text(disease,style: TextStyle(color: Colors.white),),
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
                Text('BMI', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.background)),
                Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: TextFormField(
                    controller: bmiController, // Assign the controller
                    keyboardType: TextInputType.number, // Only numeric input
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),

                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('HBA1C', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.background)),
                Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: TextFormField(
                    controller: hba1cController, // Assign the controller
                    keyboardType: TextInputType.number, // Only numeric input
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Blood Glucose Level', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.background)),
                Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: TextFormField(
                    controller: glucoseController, // Assign the controller
                    keyboardType: TextInputType.number, // Only numeric input
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Weight (in KG)', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.background)),
                Container(
                  decoration: inputBoxShadow, // Add shadow decoration
                  child: TextFormField(
                    controller: weightController, // Assign the controller
                    keyboardType: TextInputType.number, // Only numeric input
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
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
                      backgroundColor: Color.fromARGB(255, 10, 63, 94),
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
    );
  }
}
