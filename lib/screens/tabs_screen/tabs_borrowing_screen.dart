import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/models/entry.dart';
import 'package:flutter_money_management_app/providers/entry_provider.dart';
import 'package:flutter_money_management_app/widgets/all_entries.dart';
import 'package:flutter_money_management_app/widgets/app_bar_for_tab_items.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsBorrowingScreen extends ConsumerStatefulWidget {
  const TabsBorrowingScreen({super.key});

  @override
  ConsumerState<TabsBorrowingScreen> createState() =>
      _TabsBorrowingScreenState();
}

class _TabsBorrowingScreenState extends ConsumerState<TabsBorrowingScreen> {
  @override
  Widget build(BuildContext context) {
    final entryData = ref.watch(entryProvider);
    return entryData.when(
      data: (entries) {
        return Scaffold(
          appBar: getAppBar("Borrowing", context),
          body: getAllEntries(entries, context),
        );
      },
      error: (_, error) {
        return Text("Error");
      },
      loading: () {
        return Scaffold(
          appBar: getAppBar("All", context),
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
