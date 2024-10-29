// main.dart
import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'test_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'speed_test_results.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  final NotchBottomBarController _controller = NotchBottomBarController();

  final List<SpeedTestResult> _pastResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          TestScreen(
            onResultSaved: (result) {
              setState(() {
                _pastResults.add(result as SpeedTestResult);
              });
            },
          ),
          HistoryScreen(pastResults: _pastResults),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        showLabel: true,
        color: Colors.white,
        durationInMilliSeconds: 0,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(Icons.speed, color: Colors.grey),
            activeItem: Icon(Icons.speed, color: Colors.blue),
            itemLabel: 'Test',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.history, color: Colors.grey),
            activeItem: Icon(Icons.history, color: Colors.blue),
            itemLabel: 'History',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.settings, color: Colors.grey),
            activeItem: Icon(Icons.settings, color: Colors.blue),
            itemLabel: 'Settings',
          ),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        kBottomRadius: 0.0,
        showShadow: false,
        bottomBarWidth: double.infinity,
        kIconSize: 24.0,
      ),
    );
  }
}
