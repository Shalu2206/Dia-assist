class PredictionEntry {
  final String gender;
  final String hypertension;
  final String heartDisease;
  final String smokingHistory;
  final double age;
  final double bmi;
  final double hba1c;
  final double glucose;
  final String result;
  DateTime timestamp;

  PredictionEntry({
    required this.gender,
    required this.hypertension,
    required this.heartDisease,
    required this.smokingHistory,
    required this.age,
    required this.bmi,
    required this.hba1c,
    required this.glucose,
    required this.result,
    required this.timestamp,
  });
}