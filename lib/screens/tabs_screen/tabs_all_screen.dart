import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabsAllScreen extends StatefulWidget {
  const TabsAllScreen({super.key});

  @override
  State<TabsAllScreen> createState() => _TabsAllScreenState();
}

class _TabsAllScreenState extends State<TabsAllScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Tabs all Screen")));
  }
}
