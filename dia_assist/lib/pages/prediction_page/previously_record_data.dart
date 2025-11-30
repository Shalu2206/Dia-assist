import 'package:dia_assist/themes/colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/prediction_entry.dart';
import '../../shared_data/prediction_data_store.dart';

class RecordedDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var groupedByDate = _groupEntriesByDate(PredictionDataStore.entries);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 63, 94),
        title: Text("Prediction History", style: TextStyle(color: AppColors.background)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
          width: double.infinity,
            height:double.infinity,
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
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: groupedByDate.keys.map((date) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        _formatDate(date),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: AppColors.background),
                      ),
                    ),
                    ...groupedByDate[date]!.map((entry) {
                      return _buildPredictionCard(entry);
                    }).toList(),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        ),
    );
  }

  Map<DateTime, List<PredictionEntry>> _groupEntriesByDate(List<PredictionEntry> entries) {
    Map<DateTime, List<PredictionEntry>> grouped = {};

    for (var entry in entries) {
      DateTime date = DateTime(entry.timestamp.year, entry.timestamp.month, entry.timestamp.day);

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }

      grouped[date]!.add(entry);
    }

    return grouped;
  }

  String _formatDate(DateTime timestamp) {
    return "Date : ${timestamp.day}-${timestamp.month}-${timestamp.year}";
  }

  // Helper method to create each prediction card
  Widget _buildPredictionCard(PredictionEntry entry) {
    return Card(
      color: Colors.white70,
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow("Gender", entry.gender),
            _buildRow("Age", entry.age.toString()),
            _buildRow("BMI", entry.bmi.toString()),
            _buildRow("HBA1C", entry.hba1c.toString()),
            _buildRow("Glucose", entry.glucose.toString()),
            _buildRow("Result", entry.result),
            _buildRow("Time", _formatTime(entry.timestamp)),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
  String _formatTime(DateTime timestamp) {
    return "${timestamp.hour}:${timestamp.minute}:${timestamp.second}";
  }
}
