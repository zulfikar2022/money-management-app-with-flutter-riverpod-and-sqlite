import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/helpers/db_helpers.dart';
import 'package:flutter_money_management_app/providers/transaction_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key, required this.entryId});
  final int entryId;

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _submitForm(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      final paymentAmount = int.parse(_amountController.text.trim());
      final description = _descriptionController.text.trim();

      // You can pass the data back or handle it as needed
      ref
          .read(transactionNotifierProvider(widget.entryId).notifier)
          .addTransactionFromProvider(
            widget.entryId,
            description,
            paymentAmount,
          );
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text("Add Transaction"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: readEntryById(widget.entryId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final entry = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Payment Amount Field
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Payment Amount",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.currency_exchange),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a payment amount.";
                        }
                        final number = int.tryParse(value);
                        if (number == null) {
                          return "Please enter a valid amount";
                        }
                        if ((entry?.amount)! - number < 0) {
                          return "Payment exceeds remaining amount.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Description Field (optional)
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description (optional)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.notes),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 30),

                    // Submit Button
                    ElevatedButton(
                      onPressed: () {
                        _submitForm(ref);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Add Payment",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
