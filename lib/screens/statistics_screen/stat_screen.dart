import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/screens/developer_screen/developer_screen.dart';
import 'package:flutter_money_management_app/screens/entry_screen/add_entry_screen.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => DeveloperScreen()),
              );
            },
            icon: Icon(Icons.person_2),
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
      body: const Center(child: Text("Statistics")),
    );
  }
}
