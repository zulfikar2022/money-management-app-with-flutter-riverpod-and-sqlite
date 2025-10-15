import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/widgets/app_bar_for_tab_items.dart';

class TabsAllScreen extends StatefulWidget {
  const TabsAllScreen({super.key});

  @override
  State<TabsAllScreen> createState() => _TabsAllScreenState();
}

class _TabsAllScreenState extends State<TabsAllScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: getAppBar("All", context));
  }
}
