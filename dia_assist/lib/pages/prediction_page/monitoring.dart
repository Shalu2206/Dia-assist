import 'package:dia_assist/themes/colors_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class GrbsMonitoringPage extends StatefulWidget {
  @override
  _GrbsMonitoringPageState createState() => _GrbsMonitoringPageState();
}

class _GrbsMonitoringPageState extends State<GrbsMonitoringPage> {
  final Map<int, double> grbsData = {};
  final TextEditingController weekController = TextEditingController();
  final TextEditingController readingController = TextEditingController();
  String feedbackMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 63, 94),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'GRBS Monitoring',
          style: TextStyle(fontSize: 24, color: AppColors.background),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.white24,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Enter Weekly GRBS Data',
                      style: TextStyle(fontSize: 18, color: AppColors.background),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: weekController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Week Number (1-8)',
                        labelStyle: const TextStyle(fontSize: 14, color: AppColors.background),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        filled: true,
                        fillColor: Colors.white30,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: readingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'GRBS (mg/dL)',
                        labelStyle: const TextStyle(fontSize: 14, color: AppColors.background),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        filled: true,
                        fillColor: Colors.white30,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addGrbsData,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.background, // Button background color
                      ),
                      child: const Text('Add Data'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final weekLabels = [
                            'W1',
                            'W2',
                            'W3',
                            'W4',
                            'W5',
                            'W6',
                            'W7',
                            'W8'
                          ];
                          if (value >= 0 && value < weekLabels.length) {
                            return Text(
                              weekLabels[value.toInt()],
                              style: const TextStyle(color: Colors.white),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getGrbsSpots(),
                      isCurved: true,
                      barWidth: 4,
                      belowBarData: BarAreaData(show: false),
                      dotData:  FlDotData(
                        show: true,
                        //dotColor: Colors.white, // Set the color of the dots to white
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'Week',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'GRBS (mg/dL)',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                rows: _getGrbsTableData(),
              ),
            ),
            const SizedBox(height: 20),
            if (feedbackMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 204, 128),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  feedbackMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _addGrbsData() {
    final int? week = int.tryParse(weekController.text);
    final double? reading = double.tryParse(readingController.text);

    if (week == null || reading == null || week < 1 || week > 8) {
      _showError('Please enter valid week (1-8) and GRBS value.');
      return;
    }

    setState(() {
      grbsData[week] = reading;
      if (grbsData.length == 8) {
        _calculateFeedback();
      }
    });

    weekController.clear();
    readingController.clear();
  }

  List<FlSpot> _getGrbsSpots() {
    return grbsData.entries
        .map((entry) => FlSpot(entry.key.toDouble() - 1, entry.value))
        .toList();
  }

  List<DataRow> _getGrbsTableData() {
    return grbsData.entries
        .map(
          (entry) => DataRow(
        cells: [
          DataCell(Text(
            'Week ${entry.key}',
            style: const TextStyle(color: Colors.white),
          )),
          DataCell(Text(
            '${entry.value} mg/dL',
            style: const TextStyle(color: Colors.white),
          )),
        ],
      ),
    )
        .toList();
  }

  void _calculateFeedback() {
    final double average = grbsData.values.reduce((a, b) => a + b) / grbsData.length;

    setState(() {
      if (average < 70) {
        feedbackMessage =
        'Your average GRBS is low (${average.toStringAsFixed(2)} mg/dL). Consider consulting a doctor.';
      } else if (average > 180) {
        feedbackMessage =
        'Your average GRBS is high (${average.toStringAsFixed(2)} mg/dL). Please monitor closely.';
      } else {
        feedbackMessage =
        'Your average GRBS (${average.toStringAsFixed(2)} mg/dL) is within a healthy range.';
      }
    });
  }

  void _showError(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
            ),
        );
    }
}
