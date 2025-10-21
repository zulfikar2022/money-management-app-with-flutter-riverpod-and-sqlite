import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatTotalBorrowingTotalLanding extends StatelessWidget {
  const StatTotalBorrowingTotalLanding({
    super.key,
    required this.remainingBorrowings,
    required this.remainingProvidings,
  });
  final double remainingBorrowings;
  final double remainingProvidings;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(color: Colors.green, value: remainingProvidings),
          PieChartSectionData(color: Colors.red, value: remainingBorrowings),
        ],
      ),
    );
  }
}
