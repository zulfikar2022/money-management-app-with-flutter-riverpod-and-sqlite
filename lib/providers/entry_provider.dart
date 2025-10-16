import 'package:flutter_money_management_app/helpers/db_helpers.dart';
import 'package:flutter_money_management_app/models/entry.dart';
import 'package:flutter_money_management_app/providers/single_entry_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntryNotifier extends AsyncNotifier<List<Entry>> {
  @override
  Future<List<Entry>> build() async {
    final allEntries = await readAllEntries();
    return allEntries;
  }

  Future<void> addEntry(
    String name,
    int amount,
    String type,
    String image,
  ) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await enterAnEntry(name, amount, type, image);
      return await readAllEntries();
    });
  }

  Future<void> updateEntry(
    int id,
    String name,
    String entryType,
    String imagePath,
    bool isImageChanged,
  ) async {
    state = AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await updateAnEntry(
        id,
        name: name,
        entryType: entryType,
        imagePath: imagePath,
        isImageChanged: isImageChanged,
      );
      ref.invalidate(singleEntryProvider(id));
      return await readAllEntries();
    });
  }

  Future<void> deleteEntry(int id) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await deleteAnEntry(id);
      return await readAllEntries();
    });
  }
}

final entryProvider = AsyncNotifierProvider<EntryNotifier, List<Entry>>(() {
  return EntryNotifier();
});
