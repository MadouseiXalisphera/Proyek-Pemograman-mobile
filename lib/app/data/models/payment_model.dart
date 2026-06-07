class PaymentModel {
  final int id;
  final int orderId;
  final int amount;
  final String status;
  final String paymentMethod;
  final String tableName;

  PaymentModel({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.tableName,
  });

  factory PaymentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaymentModel(
      id: json["id"],
      orderId: json["order_id"],
      amount: json["amount"],
      status: json["status"],
      paymentMethod: json["payment_method"],
      tableName: json["table_name"],
    );
  }
}
