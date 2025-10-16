import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/providers/providing_entry_provider.dart';
import 'package:flutter_money_management_app/widgets/all_entries.dart';
import 'package:flutter_money_management_app/widgets/app_bar_for_tab_items.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsProvidingScreen extends ConsumerStatefulWidget {
  const TabsProvidingScreen({super.key});

  @override
  ConsumerState<TabsProvidingScreen> createState() =>
      _TabsProvidingScreenState();
}

class _TabsProvidingScreenState extends ConsumerState<TabsProvidingScreen> {
  @override
  Widget build(BuildContext context) {
    final entryData = ref.watch(providingEntryProvider);
    return entryData.when(
      data: (entries) {
        print('Entries in Providing tab: $entries');
        return Scaffold(
          appBar: getAppBar("Providing", context),
          body: getAllEntries(entries, context),
        );
      },
      error: (s, error) {
        return Center(child: Text("Error"));
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
