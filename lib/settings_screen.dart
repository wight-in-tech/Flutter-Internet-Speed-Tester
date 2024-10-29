import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings',style: TextStyle(fontWeight: FontWeight.bold),),centerTitle: true,),
      body: Center(child: Text('Settings page')),
    );
  }
}
