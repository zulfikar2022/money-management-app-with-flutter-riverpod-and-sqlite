import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/screens/developer_screen/developer_screen.dart';
import 'package:flutter_money_management_app/screens/entry_screen/add_entry_screen.dart';
import 'package:flutter_money_management_app/screens/statistics_screen/stat_screen.dart';

PreferredSizeWidget getAppBar(String text, BuildContext context) {
  return AppBar(
    title: Text(text),
    foregroundColor: Colors.white,
    backgroundColor: Colors.blueGrey,
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
  );
}
