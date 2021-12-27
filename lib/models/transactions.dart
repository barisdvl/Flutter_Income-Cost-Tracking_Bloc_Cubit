class Transactions {
  String transaction_id;
  String transaction_type;
  DateTime transaction_date;
  String transaction_account;
  String transaction_category;
  double transaction_amount;
  String transaction_detail;
  Transactions({
    required this.transaction_id,
    required this.transaction_type,
    required this.transaction_date,
    required this.transaction_account,
    required this.transaction_category,
    required this.transaction_amount,
    required this.transaction_detail,
  });
  Transactions.fromMap(Map snapshot, String transaction_id)
      : transaction_id = transaction_id,
        transaction_type = snapshot["transaction_type"] ?? "",
        transaction_date = snapshot["transaction_date"] ?? "",
        transaction_account = snapshot["transaction_account"] ?? "",
        transaction_category = snapshot["transaction_category"] ?? "",
        transaction_amount = snapshot["transaction_amount"] ?? "",
        transaction_detail = snapshot["transaction_detail"] ?? "";

  toJson() {
    return {
      "transaction_type": transaction_type,
      "transaction_date": transaction_date,
      "transaction_account": transaction_account,
      "transaction_category": transaction_category,
      "transaction_amount": transaction_amount,
      "transaction_detail": transaction_detail,
    };
  }
}
