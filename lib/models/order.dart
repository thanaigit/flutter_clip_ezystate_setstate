class Order {
  String? productName;
  int? quantity;
  Order({
    this.productName,
    this.quantity,
  });

  Order copyWith({
    String? productName,
    int? quantity,
  }) {
    return Order(
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order && other.productName == productName && other.quantity == quantity;
  }

  @override
  int get hashCode => productName.hashCode ^ quantity.hashCode;

  static int sumOrder(List<Order?> orderList) {
    return orderList.fold(0, (value, element) => value + (element?.quantity ?? 0));
  }
}
