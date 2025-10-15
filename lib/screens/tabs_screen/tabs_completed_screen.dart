import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabsCompletedScreen extends StatefulWidget {
  const TabsCompletedScreen({super.key});

  @override
  State<TabsCompletedScreen> createState() => _TabsCompletedScreenState();
}

class _TabsCompletedScreenState extends State<TabsCompletedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Tabs completed Screen")));
  }
}
