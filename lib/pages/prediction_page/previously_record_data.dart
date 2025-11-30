import 'package:dia_assist/models/prediction_entry.dart';
import 'package:dia_assist/shared_data/prediction_data_store.dart';
import 'package:dia_assist/themes/colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordedDataScreen extends StatelessWidget {
  const RecordedDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Group entries by date
    final groupedByDate = _groupByDate(PredictionDataStore.entries);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 63, 94),
        title: const Text("Prediction History",
            style: TextStyle(color: AppColors.background)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: groupedByDate.keys.map((date) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DATE HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Date: ${date.day}-${date.month}-${date.year}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.background,
                      ),
                    ),
                  ),

                  // LIST OF ENTRIES FOR THIS DATE
                  ...groupedByDate[date]!.map((entry) {
                    return _buildPredictionCard(entry);
                  }).toList(),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // GROUPING LOGIC
  Map<DateTime, List<PredictionEntry>> _groupByDate(
      List<PredictionEntry> entries) {
    final Map<DateTime, List<PredictionEntry>> grouped = {};

    for (var entry in entries) {
      final date = DateTime(
          entry.timestamp.year, entry.timestamp.month, entry.timestamp.day);

      grouped.putIfAbsent(date, () => []);
      grouped[date]!.add(entry);
    }

    return grouped;
  }

  // CARD UI
  Widget _buildPredictionCard(PredictionEntry entry) {
    return Card(
      color: Colors.white70,
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row("Gender", entry.gender),
            _row("Age", entry.age.toString()),
            _row("BMI", entry.bmi.toString()),
            _row("HBA1C", entry.hba1c.toString()),
            _row("Glucose", entry.glucose.toString()),
            _row("Result", entry.result),
            _row("Time",
                "${entry.timestamp.hour}:${entry.timestamp.minute}:${entry.timestamp.second}"),
          ],
        ),
      ),
    );
  }

  // ROW UI
  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
