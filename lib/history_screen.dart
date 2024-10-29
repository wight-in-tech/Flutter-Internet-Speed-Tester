import 'package:flutter/material.dart';
import 'package:internetspeedtester/speed_test_results.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  final List<SpeedTestResult> pastResults;

  const HistoryScreen({Key? key, required this.pastResults}) : super(key: key);

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: pastResults.length,
        itemBuilder: (context, index) {
          final result = pastResults[index];
          return SpeedTestCard(result: result, formatDateTime: formatDateTime);
        },
      ),
    );
  }
}

class SpeedTestCard extends StatelessWidget {
  final SpeedTestResult result;
  final String Function(DateTime) formatDateTime;

  const SpeedTestCard({Key? key, required this.result, required this.formatDateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpeedInfoSection(
              title: "Download Speed",
              iconColor: Colors.blue,
              rate: result.downloadRate,
              unit: result.unit,
            ),
            const SizedBox(height: 8),
            SpeedInfoSection(
              title: "Upload Speed",
              iconColor: Colors.green,
              rate: result.uploadRate,
              unit: result.unit,
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  formatDateTime(result.dateTime),
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CompletionTimeSection(
              downloadTime: result.downloadCompletionTime.toDouble(),
              uploadTime: result.uploadCompletionTime.toDouble(),
            ),
          ],
        ),
      ),
    );
  }
}

class SpeedInfoSection extends StatelessWidget {
  final String title;
  final Color iconColor;
  final double rate;
  final String unit;

  const SpeedInfoSection({
    Key? key,
    required this.title,
    required this.iconColor,
    required this.rate,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.speed, color: iconColor),
            const SizedBox(width: 8),
            Text(
              '$rate $unit',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}

class CompletionTimeSection extends StatelessWidget {
  final double downloadTime;
  final double uploadTime;

  const CompletionTimeSection({
    Key? key,
    required this.downloadTime,
    required this.uploadTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.timer, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          'Download: ${(downloadTime / 1000).toStringAsFixed(2)}s',
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(width: 16),
        Text(
          'Upload: ${(uploadTime / 1000).toStringAsFixed(2)}s',
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }
}
