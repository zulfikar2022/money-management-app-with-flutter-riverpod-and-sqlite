import 'package:flutter_money_management_app/helpers/db_helpers.dart';
import 'package:flutter_money_management_app/models/entry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final completedEntryProvider = FutureProvider<List<Entry>>((ref) async {
  final completedEntries = await readCompletedEntries();
  return completedEntries;
});
