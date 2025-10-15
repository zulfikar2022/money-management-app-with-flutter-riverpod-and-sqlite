import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/screens/entry_screen/add_entry_screen.dart';
import 'package:flutter_money_management_app/screens/statistics_screen/stat_screen.dart';

class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Developer"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => StatScreen()),
              );
            },
            icon: Icon(Icons.bar_chart),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => AddEntryScreen()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Center(child: Text("About Developer")),
    );
  }
}
