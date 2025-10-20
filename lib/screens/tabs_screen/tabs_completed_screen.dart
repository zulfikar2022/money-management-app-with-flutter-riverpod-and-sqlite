import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/providers/completed_entry_provider.dart';
import 'package:flutter_money_management_app/widgets/all_entries.dart';
import 'package:flutter_money_management_app/widgets/app_bar_for_tab_items.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsCompletedScreen extends ConsumerStatefulWidget {
  const TabsCompletedScreen({super.key});

  @override
  ConsumerState<TabsCompletedScreen> createState() =>
      _TabsCompletedScreenState();
}

class _TabsCompletedScreenState extends ConsumerState<TabsCompletedScreen> {
  @override
  Widget build(BuildContext context) {
    final completedEntries = ref.watch(completedEntryProvider);
    return completedEntries.when(
      data: (entries) {
        return Scaffold(
          appBar: getAppBar("Completed", context),
          body: AllEntriesWidget(entries: entries),
        );
      },
      error: (error, stack) {
        return Text("Error");
      },
      loading: () => CircularProgressIndicator(),
    );
  }
}
