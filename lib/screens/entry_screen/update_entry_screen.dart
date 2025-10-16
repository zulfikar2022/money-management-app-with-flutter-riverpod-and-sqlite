import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/models/entry.dart';
import 'package:flutter_money_management_app/providers/entry_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UpdateEntryScreen extends ConsumerStatefulWidget {
  const UpdateEntryScreen({super.key, required this.entry});
  final Entry entry;

  @override
  ConsumerState<UpdateEntryScreen> createState() => _UpdateEntryScreenState();
}

class _UpdateEntryScreenState extends ConsumerState<UpdateEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late String _selectedType;
  late String _imagePath;
  bool _imageChanged = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.entry.name);
    _selectedType = widget.entry.type;
    _imagePath = widget.entry.image ?? ''; // existing image path
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        _imageChanged = true;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(entryProvider.notifier)
          .updateEntry(
            widget.entry.id,
            _nameController.text,
            _selectedType,
            _imagePath,
            _imageChanged,
          );

      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry.name),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: generateUpdateDetailsScreen(
        widget.entry,
        _formKey,
        _nameController,
        // _selectedType,
        _imagePath,
        _pickImage,
        _saveForm,
      ),
    );
  }

  Widget generateUpdateDetailsScreen(
    Entry entry,
    GlobalKey formKey,
    TextEditingController nameController,
    // String selectedType,
    String imagePath,
    void Function() pickImage,
    void Function() saveForm,
  ) {
    Widget content;

    content = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            // Name Field
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Name cannot be empty";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Type Dropdown
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: "Type",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'providing', child: Text('providing')),
                DropdownMenuItem(value: 'borrowing', child: Text('borrowing')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Amount (Read-Only)
            TextFormField(
              initialValue: entry.amount.toString(),
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Amount (Read-only)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Image Preview + Change Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Image:", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: imagePath.isNotEmpty
                        ? FileImage(File(imagePath))
                        : const AssetImage('assets/images/default_avatar.jpg')
                              as ImageProvider,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton.icon(
                    onPressed: pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text("Change Image"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: saveForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Save Changes",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
    return content;
  }
}
