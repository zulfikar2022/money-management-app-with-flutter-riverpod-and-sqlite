import 'package:flutter_money_management_app/helpers/db_helpers.dart';
import 'package:flutter_money_management_app/models/entry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProvidingEntryNotifier extends AsyncNotifier<List<Entry>> {
  @override
  Future<List<Entry>> build() async {
    final providingEntries = await readProvidingEntries();
    return providingEntries;
  }
}

final providingEntryProvider =
    AsyncNotifierProvider<ProvidingEntryNotifier, List<Entry>>(
      ProvidingEntryNotifier.new,
    );
