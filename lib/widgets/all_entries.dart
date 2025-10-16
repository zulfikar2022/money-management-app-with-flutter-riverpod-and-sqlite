import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/models/entry.dart';
import 'package:flutter_money_management_app/screens/entry_screen/entry_details_screens.dart';

Widget getAllEntries(List<Entry> entries, BuildContext context) {
  if (entries.isEmpty) {
    return Center(child: Text("No entries found."));
  } else {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return ListTile(
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
                  color: entry.type == "providing" ? Colors.green : Colors.red,
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
        );
      },
    );
  }
}
