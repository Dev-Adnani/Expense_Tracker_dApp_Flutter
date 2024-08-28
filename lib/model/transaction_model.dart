class TransactionModel {
  final String address;
  final String reason;
  final int amount;
  final DateTime date;

  TransactionModel({
    required this.address,
    required this.reason,
    required this.amount,
    required this.date,
  });
}
