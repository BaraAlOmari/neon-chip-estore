enum OrderStatus { pending, shipped, delivered, cancelled }

OrderStatus orderStatusFromString(String? v) {
  switch ((v ?? '').toLowerCase()) {
    case 'pending':
      return OrderStatus.pending;
    case 'shipped':
      return OrderStatus.shipped;
    case 'delivered':
      return OrderStatus.delivered;
    case 'cancelled':
      return OrderStatus.cancelled;
    default:
      return OrderStatus.pending;
  }
}

String orderStatusToString(OrderStatus s) => s.name.toUpperCase();

class OrderItem {
  String productId;
  String name;
  String? imageUrl;
  double unitPrice;
  int quantity;

  OrderItem({required this.productId, required this.name, this.imageUrl, required this.unitPrice, required this.quantity});

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: json['productId'] as String? ?? '',
        name: json['name'] as String? ?? '',
        imageUrl: json['imageUrl'] as String?,
        unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      );
}

class Order {
  String id;
  String userId;
  List<OrderItem> items;
  double total;
  OrderStatus status;
  DateTime? createdAt;

  Order({required this.id, required this.userId, required this.items, required this.total, required this.status, this.createdAt});

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as String? ?? '',
        userId: json['userId'] as String? ?? '',
        items: (json['items'] as List? ?? const [])
            .cast<dynamic>()
            .map((e) => OrderItem.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
        total: (json['total'] as num?)?.toDouble() ?? 0.0,
        status: orderStatusFromString(json['status'] as String?),
        createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      );
}

