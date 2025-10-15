import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabsBorrowingScreen extends StatefulWidget {
  const TabsBorrowingScreen({super.key});

  @override
  State<TabsBorrowingScreen> createState() => _TabsBorrowingScreenState();
}

class _TabsBorrowingScreenState extends State<TabsBorrowingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Tabs borrowing Screen")));
  }
}
