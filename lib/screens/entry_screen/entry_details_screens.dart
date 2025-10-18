import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/models/entry.dart';
import 'package:flutter_money_management_app/models/transaction.dart';
import 'package:flutter_money_management_app/providers/entry_provider.dart';
import 'package:flutter_money_management_app/providers/single_entry_provider.dart';
import 'package:flutter_money_management_app/providers/transaction_provider.dart';
import 'package:flutter_money_management_app/screens/entry_screen/update_entry_screen.dart';
import 'package:flutter_money_management_app/screens/transaction_screen/add_transaction_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntryDetailsScreens extends ConsumerStatefulWidget {
  const EntryDetailsScreens({super.key, required this.entry});
  final Entry entry;

  @override
  ConsumerState<EntryDetailsScreens> createState() =>
      _EntryDetailsScreensState();
}

class _EntryDetailsScreensState extends ConsumerState<EntryDetailsScreens> {
  void handleDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // cancel
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true), // confirm delete
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await ref.read(entryProvider.notifier).deleteEntry(widget.entry.id);
      if (mounted) {
        Navigator.of(context).pop(); // Go back after deletion
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    final height = MediaQuery.of(context).size.height;

    final entryData = ref.watch(singleEntryProvider(widget.entry.id));

    return entryData.when(
      data: (data) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: handleDelete,
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => UpdateEntryScreen(entry: data),
                    ),
                  );
                },
                icon: Icon(Icons.edit),
              ),
            ],
            title: Text(data.name),
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
          ),
          body: generateEntryDetailsScreen(data, orientation, height),
        );
      },
      error: (_, __) {
        return Text("Error");
      },
      loading: () {
        return Scaffold(
          appBar: AppBar(
            title: Text("Loading..."),
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
          ),
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget generateEntryDetailsScreen(
    Entry entry,
    Orientation orientation,
    double height,
  ) {
    Widget? content;

    if (orientation == Orientation.portrait) {
      content = ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              entry.image != ''
                  ? CircleAvatar(
                      backgroundImage: FileImage(File(entry.image)),
                      radius: height * 0.1,
                    )
                  : Image.asset(
                      'assets/images/default_avatar.jpg',
                      height: height * 0.2,
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
                child: Text(
                  entry.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "Initial Amount: ${entry.initialAmount}",
                style: TextStyle(
                  color: entry.type == "Providing" ? Colors.green : Colors.red,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Remaining Amount: ${entry.amount}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),

          TransactionWidget(entryId: widget.entry.id),
          SizedBox(height: 10),

          TextButton(
            onPressed: () async {
              final needToRefresh = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) =>
                      AddTransactionScreen(entryId: widget.entry.id),
                ),
              );
              if (needToRefresh) {
                setState(() {});
              }
            },
            child: Text("Add Transaction+"),
          ),
        ],
      );
    } else {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                entry.image != ''
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundImage: FileImage(File(entry.image)),
                          radius: height * 0.3,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/default_avatar.jpg',
                          height: height * 0.3,
                        ),
                      ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
                  child: Column(
                    children: [
                      Text(
                        entry.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Initial Amount: ${entry.initialAmount}",
                        style: TextStyle(
                          color: entry.type == "Providing"
                              ? Colors.green
                              : Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Remaining Amount: ${entry.amount}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 100),
          Expanded(
            child: ListView(
              children: [
                SizedBox(height: 10),
                TransactionWidget(entryId: widget.entry.id),
                TextButton(
                  onPressed: () async {
                    final needToRefresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) =>
                            AddTransactionScreen(entryId: widget.entry.id),
                      ),
                    );
                    if (needToRefresh) {
                      setState(() {});
                    }
                  },
                  child: Text("Add Transaction+"),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return content;
  }
}

class TransactionWidget extends ConsumerWidget {
  const TransactionWidget({super.key, required this.entryId});
  final int entryId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionProviderValue = ref.watch(
      transactionNotifierProvider(entryId),
    );
    return transactionProviderValue.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return Center(child: Text("No transaction for this entry"));
        }
        List<Widget> listTileList = transactions.map((t) {
          return ListTile(
            leading: Icon(Icons.currency_exchange),
            title: Text("Amount: ${t.amount}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Date: ${t.paymentDate.toLocal().toString().split(' ')[0]}",
                ),
                t.description != "" ? Text(t.description) : SizedBox(),
              ],
            ),
          );
        }).toList();
        return Column(children: listTileList);
      },
      error: (error, stack) {
        return Center(child: Text("Error Fetching data"));
      },
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
