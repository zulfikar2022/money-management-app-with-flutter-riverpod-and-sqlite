import 'dart:io';

import 'package:flutter_money_management_app/models/entry.dart';
import 'package:flutter_money_management_app/models/transaction.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final dbPath = await getDatabasesPath();
  final dbFinalPathWithName = path.join(dbPath, "lendings_borrowings.db");
  Database db = await openDatabase(
    dbFinalPathWithName,
    version: 1,
    onCreate: (database, version) async {
      // it will be the value of amount at the time of entry creation
      await database.execute('''
      CREATE TABLE entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        amount INTEGER NOT NULL CHECK(amount >= 0),
        initial_amount INTEGER NOT NULL CHECK(initial_amount > 0),
        creating_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        type TEXT NOT NULL,
        image TEXT DEFAULT ''
        )
      ''');
      await database.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entry_id INTEGER NOT NULL,
        description TEXT,
        payment_amount INTEGER NOT NULL CHECK(payment_amount != 0),
        payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (entry_id) REFERENCES entries(id)
      )
      ''');
      await database.execute('PRAGMA foreign_keys = ON');
    },
  );
  return db;
}

// enter an entry
Future<void> enterAnEntry(
  String name,
  int amount,
  String entryType,
  String imagePath,
) async {
  Database db = await getDatabase();
  await db.insert('entries', {
    'name': name,
    'amount': amount,
    'type': entryType,
    'image': imagePath,
    'initial_amount': amount,
  });
}

// read all the entries
Future<List<Entry>> readAllEntries() async {
  Database db = await getDatabase();

  final entries = await db.query('entries', orderBy: 'creating_date DESC');

  return entries.map((item) {
    return Entry(
      name: item['name'] as String,
      amount: item['amount'] as int,
      creatingDate: DateTime.parse(item['creating_date'] as String),
      type: item['type'] as String,
      image: item['image'] as String,
      id: item['id'] as int,
      initialAmount: item['initial_amount'] as int,
    );
  }).toList();
}

// read all the entries of type Providing
Future<List<Entry>> readProvidingEntries() async {
  final db = await getDatabase();
  final entries = await db.query(
    'entries',
    where: 'type = ?',
    whereArgs: ['providing'],
    orderBy: 'creating_date DESC',
  );
  return entries.map((item) {
    return Entry(
      name: item['name'] as String,
      amount: item['amount'] as int,
      creatingDate: DateTime.parse(item['creating_date'] as String),
      type: item['type'] as String,
      image: item['image'] as String,
      id: item['id'] as int,
      initialAmount: item['initial_amount'] as int,
    );
  }).toList();
}

// read all the entries of type Borrowing
Future<List<Entry>> readBorrowingEntries() async {
  final db = await getDatabase();
  final entries = await db.query(
    'entries',
    where: 'type = ?',
    whereArgs: ['borrowing'],
    orderBy: 'creating_date DESC',
  );
  return entries.map((item) {
    return Entry(
      name: item['name'] as String,
      amount: item['amount'] as int,
      creatingDate: DateTime.parse(item['creating_date'] as String),
      type: item['type'] as String,
      image: item['image'] as String,
      id: item['id'] as int,
      initialAmount: item['initial_amount'] as int,
    );
  }).toList();
}

Future<List<Entry>> readCompletedEntries() async {
  final db = await getDatabase();
  final entries = await db.query(
    'entries',
    where: 'amount = 0',
    orderBy: 'creating_date DESC',
  );
  return entries.map((item) {
    return Entry(
      name: item['name'] as String,
      amount: item['amount'] as int,
      creatingDate: DateTime.parse(item['creating_date'] as String),
      type: item['type'] as String,
      image: item['image'] as String,
      id: item['id'] as int,
      initialAmount: item['initial_amount'] as int,
    );
  }).toList();
}

// read specific entry by id
Future<Entry?> readEntryById(int id) async {
  Database db = await getDatabase();
  final entries = await db.query('entries', where: 'id = ?', whereArgs: [id]);
  if (entries.isNotEmpty) {
    final item = entries.first;
    return Entry(
      name: item['name'] as String,
      amount: item['amount'] as int,
      creatingDate: DateTime.parse(item['creating_date'] as String),
      type: item['type'] as String,
      image: item['image'] as String,
      id: item['id'] as int,
      initialAmount: item['initial_amount'] as int,
    );
  } else {
    return null;
  }
}

// update an entry (Only name, type and image  be updatable. Amount will not be updatable)
Future<void> updateAnEntry(
  int id, {
  required String name,
  required String entryType,
  required String imagePath,
  required bool isImageChanged,
}) async {
  Database db = await getDatabase();
  final entry = await readEntryById(id);
  if (entry == null) {
    throw Exception("Entry not found");
  }

  // if image is changed, delete the old image from the storage
  if (isImageChanged && entry.image.isNotEmpty) {
    final oldImageFile = File(entry.image);
    if (await oldImageFile.exists()) {
      await oldImageFile.delete();
    }
  }
  await db.update(
    'entries',
    {'name': name, 'type': entryType, 'image': imagePath},
    where: 'id = ?',
    whereArgs: [id],
  );
}

// delete an entry (while deleting an entry delete all the corresponding transactions)

Future<void> deleteAnEntry(int id) async {
  Database db = await getDatabase();
  // fetch the entry to check if it exists
  final entry = await readEntryById(id);
  if (entry == null) {
    throw Exception("Entry not found");
  }
  // check if the image exists or not, if image exists, delete it from the storage
  if (entry.image.isNotEmpty) {
    final imageFile = File(entry.image);
    if (await imageFile.exists()) {
      await imageFile.delete();
    }
  }
  await db.delete('transactions', where: 'entry_id = ?', whereArgs: [id]);
  await db.delete('entries', where: 'id = ?', whereArgs: [id]);
}

// enter a transaction corresponding to an entry (while entering a transaction, update the entry based on the amount of entered into the entries table )

Future<void> enterATransaction(int entryId, int paymentAmount) async {
  Database db = await getDatabase();
  final entry = await readEntryById(entryId);
  if (entry == null) {
    throw Exception("Entry not found");
  }
  int newAmount = entry.amount - paymentAmount;
  if (newAmount < 0) {
    throw Exception("Payment amount exceeds the remaining amount");
  }
  await db.insert('transactions', {
    'entry_id': entryId,
    'payment_amount': paymentAmount,
  });
  await db.update(
    'entries',
    {'amount': newAmount},
    where: 'id = ?',
    whereArgs: [entryId],
  );
}

// Provide update permission to the last transactions only.
Future<void> updateLastTransaction(int entryId, int newPaymentAmount) async {
  Database db = await getDatabase();
  final transactions = await db.query(
    'transactions',
    where: 'entry_id = ?',
    whereArgs: [entryId],
    orderBy: 'payment_date DESC',
    limit: 1,
  );
  if (transactions.isEmpty) {
    throw Exception("No transactions found for this entry");
  }
  final lastTransaction = transactions.first;
  final oldPaymentAmount = lastTransaction['payment_amount'] as int;
  final entry = await readEntryById(entryId);
  if (entry == null) {
    throw Exception("Entry not found");
  }
  int adjustedAmount = entry.amount - newPaymentAmount;
  if (adjustedAmount < 0) {
    throw Exception("New payment amount exceeds the remaining amount");
  }
  await db.update(
    'transactions',
    {'payment_amount': newPaymentAmount},
    where: 'id = ?',
    whereArgs: [lastTransaction['id']],
  );
  await db.update(
    'entries',
    {'amount': adjustedAmount},
    where: 'id = ?',
    whereArgs: [entryId],
  );
}

Future<List<TransactionPayment>> getAllTransactions(int entryId) async {
  Database db = await getDatabase();
  final transactions = await db.query(
    'transactions',
    where: 'entry_id = ?',
    whereArgs: [entryId],
  );
  return transactions.map((item) {
    return TransactionPayment(
      entryId: item['entry_id'] as int,
      amount: item['payment_amount'] as int,
      description: item['description'] as String? ?? '',
      id: item['id'] as int,
    );
  }).toList();
}

Future<void> addTransaction(
  int entryId,
  String? description,
  int paymentAmount,
) async {
  Database db = await getDatabase();
  final entry = await readEntryById(entryId);
  if (entry == null) {
    throw Exception("Entry not found");
  }
  int newAmount = entry.amount - paymentAmount;
  if (newAmount < 0) {
    throw Exception("Payment amount exceeds the remaining amount");
  }
  await db.insert('transactions', {
    'entry_id': entryId,
    'payment_amount': paymentAmount,
    'description': description,
  });
  await db.update(
    'entries',
    {'amount': newAmount},
    where: 'id = ?',
    whereArgs: [entryId],
  );
}

Future<Map<String, double>> getStatistics() async {
  Database db = await getDatabase();
  final totalEntriesResult = await db.rawQuery(
    'SELECT COUNT(*) as count FROM entries',
  );
  final totalEntries = Sqflite.firstIntValue(totalEntriesResult) ?? 0;

  final totalLentResult = await db.rawQuery(
    'SELECT SUM(amount) as total_lent FROM entries WHERE type = ? ',
    ['providing'],
  );
  final totalLent =
      (totalLentResult.first['total_lent'] as int?)?.toDouble() ?? 0.0;

  final totalBorrowedResult = await db.rawQuery(
    'SELECT SUM(amount) as total_borrowed FROM entries WHERE type = ?',
    ['Borrowing'],
  );
  final totalBorrowed =
      (totalBorrowedResult.first['total_borrowed'] as int?)?.toDouble() ?? 0.0;

  final totalRecoveredResult = await db.rawQuery(
    'SELECT SUM(payment_amount) as total_recovered FROM transactions WHERE entry_id IN (SELECT id FROM entries WHERE type = ?)',
    ['providing'],
  );
  final totalRecovered =
      (totalRecoveredResult.first['total_recovered'] as int?)?.toDouble() ??
      0.0;

  final totalPaidResult = await db.rawQuery(
    'SELECT SUM(payment_amount) as total_paid FROM transactions WHERE entry_id IN (SELECT id FROM entries WHERE type = ?)',
    ['borrowing'],
  );
  final totalPaid =
      (totalPaidResult.first['total_paid'] as int?)?.toDouble() ?? 0.0;

  final activeEntries = await db.rawQuery(
    'SELECT COUNT(*) as count FROM entries WHERE amount > 0',
  );
  final activeEntriesCount = Sqflite.firstIntValue(activeEntries) ?? 0;
  final closedEntriesCount = totalEntries - activeEntriesCount;

  return {
    'total_entries': totalEntries.toDouble(),
    'total_provided': totalLent,
    'total_borrowed': totalBorrowed,
    'total_recovered': totalRecovered,
    'total_paid': totalPaid,
    'active_entries': activeEntriesCount.toDouble(),
    'closed_entries': closedEntriesCount.toDouble(),
  };
}
