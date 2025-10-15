import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/widgets/app_bar_for_tab_items.dart';

class TabsProvidingScreen extends StatefulWidget {
  const TabsProvidingScreen({super.key});

  @override
  State<TabsProvidingScreen> createState() => _TabsProvidingScreenState();
}

class _TabsProvidingScreenState extends State<TabsProvidingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: getAppBar("Providing", context));
  }
}
