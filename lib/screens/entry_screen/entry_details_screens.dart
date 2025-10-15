import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EntryDetailsScreens extends StatefulWidget {
  const EntryDetailsScreens({super.key});

  @override
  State<EntryDetailsScreens> createState() => _EntryDetailsScreensState();
}

class _EntryDetailsScreensState extends State<EntryDetailsScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entry Details"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
    );
  }
}
