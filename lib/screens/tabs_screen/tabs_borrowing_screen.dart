import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/widgets/app_bar_for_tab_items.dart';

class TabsBorrowingScreen extends StatefulWidget {
  const TabsBorrowingScreen({super.key});

  @override
  State<TabsBorrowingScreen> createState() => _TabsBorrowingScreenState();
}

class _TabsBorrowingScreenState extends State<TabsBorrowingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: getAppBar("Borrowing", context));
  }
}
