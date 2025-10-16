import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/providers/entry_provider.dart';
import 'package:flutter_money_management_app/widgets/all_entries.dart';
import 'package:flutter_money_management_app/widgets/app_bar_for_tab_items.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsAllScreen extends ConsumerStatefulWidget {
  const TabsAllScreen({super.key});

  @override
  ConsumerState<TabsAllScreen> createState() => _TabsAllScreenState();
}

class _TabsAllScreenState extends ConsumerState<TabsAllScreen> {
  @override
  Widget build(BuildContext context) {
    final entryData = ref.watch(entryProvider);
    return entryData.when(
      data: (entries) {
        return Scaffold(
          appBar: getAppBar("All", context),
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
