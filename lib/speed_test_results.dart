class SpeedTestResult {
  final double downloadRate;
  final double uploadRate;
  final String unit;
  final  downloadCompletionTime;
  final int uploadCompletionTime;
  final DateTime dateTime;
  final String? errorMessage;

  SpeedTestResult({
    this.downloadRate = 0.0,
    this.uploadRate = 0.0,
    this.unit = 'Mbps',
    this.downloadCompletionTime = 0,
    this.uploadCompletionTime = 0,
    required this.dateTime,
    this.errorMessage,

  });
}
