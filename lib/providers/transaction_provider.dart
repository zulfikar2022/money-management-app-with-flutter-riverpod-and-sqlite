import 'dart:async';
import 'package:flutter_money_management_app/helpers/db_helpers.dart';
import 'package:flutter_money_management_app/models/transaction.dart';
import 'package:flutter_money_management_app/providers/single_entry_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionNotifier extends AsyncNotifier<List<TransactionPayment>> {
  TransactionNotifier(this.entryId);
  final int entryId;
  @override
  Future<List<TransactionPayment>> build() async {
    state = const AsyncValue.loading();
    final transactions = await getAllTransactions(entryId);
    if (transactions.isEmpty) {
      throw Exception("transactions not found");
    }
    state = AsyncValue.data(transactions);
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
      return getAllTransactions(entryId);
    });
  }
}

final transactionNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<TransactionNotifier, List<TransactionPayment>, int>(
      TransactionNotifier.new,
    );
