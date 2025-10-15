import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/providers/entry_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sys_path;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddEntryScreen extends ConsumerStatefulWidget {
  const AddEntryScreen({super.key});

  @override
  ConsumerState<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends ConsumerState<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedType;
  XFile? _selectedImage;
  final List<String> _types = ['providing', 'borrowing'];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? imagePathToStore = "";
      if (_selectedImage != null) {
        File imageFile = File(_selectedImage?.path ?? '');
        Directory appDocDir = await sys_path.getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        imagePathToStore = path.join(appDocPath, path.basename(imageFile.path));
        await imageFile.copy(imagePathToStore);
      }
      ref
          .read(entryProvider.notifier)
          .addEntry(
            _nameController.text,
            int.parse(_amountController.text),
            _selectedType!,
            imagePathToStore,
          );
      if (mounted) {
        Navigator.pop(context);
      }

      // Save the data to the database
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Entry"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Center(child: Text("Add Entry")),
    );
  }
}
