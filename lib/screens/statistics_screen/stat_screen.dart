import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/providers/stat_provider.dart';
import 'package:flutter_money_management_app/screens/developer_screen/developer_screen.dart';
import 'package:flutter_money_management_app/screens/entry_screen/add_entry_screen.dart';
import 'package:flutter_money_management_app/widgets/stat_totalborrowing_totallanding.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatScreen extends ConsumerStatefulWidget {
  const StatScreen({super.key});

  @override
  ConsumerState<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends ConsumerState<StatScreen> {
  @override
  Widget build(BuildContext context) {
    final statisticsData = ref.watch(statsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        actions: [
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
      ),
      body: statisticsData.when(
        data: (data) {
          return ListView(
            children: [
              SizedBox(height: 20),
              Text(
                "Total Borrowing vs Total Providing",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),

              SizedBox(
                height: 200,
                width: 200,
                child: StatTotalBorrowingTotalLanding(
                  remainingBorrowings: data['remainingBorrowings']!,
                  remainingProvidings: data['remainingProvidings']!,
                ),
              ),
            ],
          );
        },
        error: (error, stack) {
          print(error);
          return Center(child: Text("Error"));
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
