class PredictionEntry {
  final String gender;
  final int age;
  final double bmi;
  final double hba1c;
  final double glucose;
  final String result;
  final DateTime timestamp;

  PredictionEntry({
    required this.gender,
    required this.age,
    required this.bmi,
    required this.hba1c,
    required this.glucose,
    required this.result,
    required this.timestamp,
  });
}
