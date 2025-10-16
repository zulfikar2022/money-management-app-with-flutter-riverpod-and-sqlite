import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/models/entry.dart';
import 'package:flutter_money_management_app/providers/entry_provider.dart';
import 'package:flutter_money_management_app/providers/single_entry_provider.dart';
import 'package:flutter_money_management_app/screens/entry_screen/update_entry_screen.dart';
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
          body: Center(child: Text("Details for ${data.name}")),
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
}
