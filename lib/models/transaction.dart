class Transactions {
  final DateTime date;
  final int total;
  final List<TransactionDetails> details;

  Transactions({
    required this.date,
    required this.total,
    required this.details
  });
}

class TransactionDetails {
  final String name;
  final int total;
  final int tag;

  TransactionDetails({required this.name, required this.total, required this.tag});
}