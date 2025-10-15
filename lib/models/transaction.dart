class TransactionPayment {
  int id;
  int entryId;
  int amount;
  String description;
  DateTime paymentDate = DateTime.now();

  TransactionPayment({
    required this.entryId,
    required this.amount,
    required this.description,
    required this.id,
  });
}
