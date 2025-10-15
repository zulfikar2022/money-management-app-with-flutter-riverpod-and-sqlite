import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabsProvidingScreen extends StatefulWidget {
  const TabsProvidingScreen({super.key});

  @override
  State<TabsProvidingScreen> createState() => _TabsProvidingScreenState();
}

class _TabsProvidingScreenState extends State<TabsProvidingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Tabs providing Screen")));
  }
}
