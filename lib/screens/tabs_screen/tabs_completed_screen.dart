import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/widgets/app_bar_for_tab_items.dart';

class TabsCompletedScreen extends StatefulWidget {
  const TabsCompletedScreen({super.key});

  @override
  State<TabsCompletedScreen> createState() => _TabsCompletedScreenState();
}

class _TabsCompletedScreenState extends State<TabsCompletedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: getAppBar("Completed", context));
  }
}
