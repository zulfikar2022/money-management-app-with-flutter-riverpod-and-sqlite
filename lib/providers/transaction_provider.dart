import 'dart:async';
import 'package:flutter_money_management_app/helpers/db_helpers.dart';
import 'package:flutter_money_management_app/models/transaction.dart';
import 'package:flutter_money_management_app/providers/borrowing_entry_provider.dart';
import 'package:flutter_money_management_app/providers/completed_entry_provider.dart';
import 'package:flutter_money_management_app/providers/entry_provider.dart';
import 'package:flutter_money_management_app/providers/providing_entry_provider.dart';
import 'package:flutter_money_management_app/providers/single_entry_provider.dart';
import 'package:flutter_money_management_app/providers/stat_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionNotifier extends AsyncNotifier<List<TransactionPayment>> {
  TransactionNotifier(this.entryId);
  final int entryId;
  @override
  Future<List<TransactionPayment>> build() async {
    final transactions = await getAllTransactions(entryId);
    return transactions;
  }

  Future<void> addTransactionFromProvider(
    int entryId,
    String? description,
    int amount,
  ) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await addTransaction(entryId, description, amount);
      ref.invalidate(transactionNotifierProvider);
      ref.invalidate(singleEntryProvider(entryId));
      ref.invalidate(completedEntryProvider);
      ref.invalidate(entryProvider);
      ref.invalidate(providingEntryProvider);
      ref.invalidate(borrowingEntryProvider);
      ref.invalidate(statsProvider);
      return getAllTransactions(entryId);
    });
  }
}

final transactionNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<TransactionNotifier, List<TransactionPayment>, int>(
      TransactionNotifier.new,
    );
