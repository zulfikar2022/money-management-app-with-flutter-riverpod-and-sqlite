import 'package:flutter_money_management_app/helpers/db_helpers.dart';
import 'package:flutter_money_management_app/models/entry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BorrowingEntryNotifier extends AsyncNotifier<List<Entry>> {
  @override
  Future<List<Entry>> build() async {
    final borrowingEntries = await readBorrowingEntries();
    return borrowingEntries;
  }
}

final borrowingEntryProvider =
    AsyncNotifierProvider<BorrowingEntryNotifier, List<Entry>>(
      BorrowingEntryNotifier.new,
    );
