import 'package:flutter_money_management_app/helpers/db_helpers.dart';
import 'package:flutter_money_management_app/models/entry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntryNotifier extends AsyncNotifier<List<Entry>> {
  @override
  Future<List<Entry>> build() async {
    final allEntries = await readAllEntries();
    return allEntries;
  }

  Future<void> getProvidingEntries() async {
    state = AsyncValue.loading();
    final allEntries = await readProvidingEntries();
    final providingEntries = allEntries
        .where((entry) => entry.type == "providing")
        .toList();
    state = AsyncValue.data(providingEntries);
  }

  Future<void> getBorrowingEntries() async {
    state = AsyncValue.loading();
    final allEntries = await readBorrowingEntries();
    final borrowingEntries = allEntries
        .where((entry) => entry.type == "borrowing")
        .toList();
    state = AsyncValue.data(borrowingEntries);
  }

  Future<void> getCompletedEntries() async {
    state = AsyncValue.loading();
    final allEntries = await readCompletedEntries();
    final completedEntries = allEntries
        .where((entry) => entry.amount == 0)
        .toList();
    state = AsyncValue.data(completedEntries);
  }

  Future<void> addEntry(
    String name,
    int amount,
    String type,
    String image,
  ) async {
    state = AsyncValue.loading();
    await enterAnEntry(name, amount, type, image);
    final allEntries = await readAllEntries();
    state = AsyncValue.data(allEntries);
  }
}

final entryProvider = AsyncNotifierProvider<EntryNotifier, List<Entry>>(() {
  return EntryNotifier();
});
