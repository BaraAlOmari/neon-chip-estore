class Product {
  String? id;
  String name;
  String? description;
  String? imageUrl;
  String? category;
  double price;
  int stock;
  DateTime? createdAt;
  DateTime? updatedAt;

  Product({this.id, required this.name, this.description, this.imageUrl, this.category, required this.price, required this.stock, this.createdAt, this.updatedAt});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'category': category,
        'price': price,
        'stock': stock,
      };
}

