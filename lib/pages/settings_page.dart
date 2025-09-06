import 'package:flutter/material.dart';
import 'package:flutter_day3/utilities/my_drawer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey),
      drawer: MyDrawer(),
      body: Center(child: Text("Settings Page"),),
    );
  }
}
