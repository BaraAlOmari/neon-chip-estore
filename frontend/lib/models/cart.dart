class CartItem {
  String productId;
  String name;
  String? imageUrl;
  double unitPrice;
  int quantity;

  CartItem({required this.productId, required this.name, this.imageUrl, required this.unitPrice, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'] as String? ?? '',
        name: json['name'] as String? ?? '',
        imageUrl: json['imageUrl'] as String?,
        unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'imageUrl': imageUrl,
        'unitPrice': unitPrice,
        'quantity': quantity,
      };
}

class Cart {
  String id;
  String userId;
  List<CartItem> items;
  double? total; // transient from backend

  Cart({required this.id, required this.userId, required this.items, this.total});

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json['id'] as String? ?? '',
        userId: json['userId'] as String? ?? '',
        items: (json['items'] as List? ?? const [])
            .cast<dynamic>()
            .map((e) => CartItem.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
        total: (json['total'] as num?)?.toDouble(),
      );
}

