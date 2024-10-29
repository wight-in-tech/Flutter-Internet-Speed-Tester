import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:internetspeedtester/speed_test_results.dart';
import 'package:internetspeedtester/history_screen.dart';
import 'speedgauge_widget.dart'; // Assume you have this gauge widget

class TestScreen extends StatefulWidget {
  final Function(SpeedTestResult) onResultSaved;
  const TestScreen({Key? key, required this.onResultSaved}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final FlutterInternetSpeedTest _internetSpeedTest = FlutterInternetSpeedTest()..enableLog();
  final List<SpeedTestResult> _pastResults = [];

  bool _testInProgress = false;
  double _downloadRate = 0;
  double _uploadRate = 0;
  String _downloadProgress = '0';
  String _uploadProgress = '0';
  int _downloadCompletionTime = 0;
  int _uploadCompletionTime = 0;
  String _unitText = 'Mbps';
  String? _ip;
  String? _asn;
  String? _isp;
  bool _isServerSelectionInProgress = false;

  @override
  void initState() {
    super.initState();
  }

  void _saveResult() {
    final result = SpeedTestResult(
      downloadRate: _downloadRate,
      uploadRate: _uploadRate,
      unit: _unitText,
      downloadCompletionTime: _downloadCompletionTime,
      uploadCompletionTime: _uploadCompletionTime,
      dateTime: DateTime.now(),
    );
    widget.onResultSaved(result);
  }

  void startSpeedTest() async {
    // Reset values at the start of the test
    setState(() {
      _testInProgress = true;
      _downloadRate = 0;
      _uploadRate = 0;
      _downloadProgress = '0';
      _uploadProgress = '0';
      _unitText = 'Mbps';
      _downloadCompletionTime = 0;
      _uploadCompletionTime = 0;
      _ip = null;
      _asn = null;
      _isp = null;
    });

    await _internetSpeedTest.startTesting(
      onStarted: () => setState(() => _testInProgress = true),
      onCompleted: (download, upload) {
        setState(() {
          _downloadRate = download.transferRate;
          _uploadRate = upload.transferRate;
          _unitText = download.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
          _downloadProgress = '100';
          _uploadProgress = '100';
          _downloadCompletionTime = download.durationInMillis;
          _uploadCompletionTime = upload.durationInMillis;
          _testInProgress = false;
          _saveResult(); // Save result when test completes
        });
      },
      onProgress: (percent, data) {
        setState(() {
          _unitText = data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
          if (data.type == TestType.download) {
            _downloadRate = data.transferRate;
            _downloadProgress = percent.toStringAsFixed(2);
          } else {
            _uploadRate = data.transferRate;
            _uploadProgress = percent.toStringAsFixed(2);
          }
        });
      },
      onError: (errorMessage, speedTestError) {
        setState(() {
          _testInProgress = false;
        });

        if (errorMessage.contains("SOCKET_TIMEOUT")) {
          // Create a timeout result
          final timeoutResult = SpeedTestResult(
            downloadRate: 0.0,  // Set to 0 as no result was obtained
            uploadRate: 0.0,    // Set to 0 as no result was obtained
            unit: 'N/A',
            downloadCompletionTime: 0,
            uploadCompletionTime: 0,
            dateTime: DateTime.now(),
            errorMessage: 'Socket timeout',
          );

          // Save the timeout result
          widget.onResultSaved(timeoutResult);
        }

        // Show a snackbar with the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $errorMessage')),
        );
      },

      onDefaultServerSelectionInProgress: () {
        setState(() => _isServerSelectionInProgress = true);
      },
      onDefaultServerSelectionDone: (client) {
        setState(() {
          _isServerSelectionInProgress = false;
          _ip = client?.ip;
          _asn = client?.asn;
          _isp = client?.isp;
        });
      },
      onCancel: () => setState(() => _testInProgress = false),
    );
  }

  void navigateToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(pastResults: _pastResults),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speed Tester", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,

      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpeedGauge(value: _downloadRate),
                const SizedBox(height: 32.0),
                const Text(
                  'Download Speed',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text('Progress: $_downloadProgress%'),
                Text('Download Rate: $_downloadRate $_unitText'),
                if (_downloadCompletionTime > 0)
                  Text('Time taken: ${(_downloadCompletionTime / 1000).toStringAsFixed(2)} sec(s)'),
              ],
            ),
            const SizedBox(height: 32.0),


            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpeedGauge(value: _uploadRate),
                const SizedBox(height: 32.0),
                const Text(
                  'Upload Speed',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text('Progress: $_uploadProgress%'),
                Text('Upload Rate: $_uploadRate $_unitText'),
                if (_uploadCompletionTime > 0)
                  Text('Time taken: ${(_uploadCompletionTime / 1000).toStringAsFixed(2)} sec(s)'),
              ],
            ),
            const SizedBox(height: 32.0),

            // Server Selection Info
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(_isServerSelectionInProgress
                  ? 'Selecting Server...'
                  : 'IP: ${_ip ?? '--'} | ASN: ${_asn ?? '--'} | ISP: ${_isp ?? '--'}'),
            ),

            // Start/Cancel Test Button
            if (!_testInProgress)
              ElevatedButton(
                onPressed: startSpeedTest,
                child: const Text('Start Testing'),
              )
            else
              Column(
                children: [
                  const CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton.icon(
                      onPressed: _internetSpeedTest.cancelTest,
                      icon: const Icon(Icons.cancel_rounded),
                      label: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}