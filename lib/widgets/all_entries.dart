import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/models/entry.dart';
import 'package:flutter_money_management_app/providers/entry_provider.dart';
import 'package:flutter_money_management_app/screens/entry_screen/entry_details_screens.dart';
import 'package:flutter_money_management_app/screens/entry_screen/update_entry_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:animations/animations.dart';

void handleDelete(BuildContext context, WidgetRef ref, int entryId) async {
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
    await ref.read(entryProvider.notifier).deleteEntry(entryId);
    if (context.mounted) {
      Navigator.of(context).pop(); // Go back after deletion
    }
  }
}

class AllEntriesWidget extends ConsumerWidget {
  const AllEntriesWidget({super.key, required this.entries});

  final List<Entry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (entries.isEmpty) {
      return Center(child: Text("No entries found."));
    } else {
      return ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return Slidable(
            key: ValueKey(entry.id),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (ctx) {
                    handleDelete(context, ref, entry.id);
                  },
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: (ctx) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => UpdateEntryScreen(entry: entry),
                      ),
                    );
                  },
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
              ],
            ),

            // The end action pane is the one at the right or the bottom side.
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (ctx) {
                    handleDelete(context, ref, entry.id);
                  },
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: (ctx) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => UpdateEntryScreen(entry: entry),
                      ),
                    );
                  },
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
              ],
            ),

            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => EntryDetailsScreens(entry: entry),
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundImage: entry.image.isNotEmpty
                    ? FileImage(File(entry.image)) as ImageProvider
                    : AssetImage('assets/images/default_avatar.jpg'),
              ),
              title: Text(
                entry.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.type,
                    style: TextStyle(
                      color: entry.type == "providing"
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Initial Amount: ${entry.initialAmount}"),

                        Text("Remaining Amount: ${entry.amount}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
