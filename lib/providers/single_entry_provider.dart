import 'package:flutter_money_management_app/helpers/db_helpers.dart';
import 'package:flutter_money_management_app/models/entry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingleEntryNotifier extends AsyncNotifier<Entry> {
  SingleEntryNotifier(this.entryId);
  final int entryId;
  @override
  Future<Entry> build() async {
    final entry = await readEntryById(entryId);
    if (entry == null) {
      throw Exception("Entry not found");
    }
    return entry;
  }

  Future<void> refreshEntry() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final entry = await readEntryById(entryId);
      if (entry == null) {
        throw Exception("Entry not found");
      }
      return entry;
    });
  }
}

final singleEntryProvider = AsyncNotifierProvider.autoDispose
    .family<SingleEntryNotifier, Entry, int>(SingleEntryNotifier.new);
