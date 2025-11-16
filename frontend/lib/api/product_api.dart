import '../api/api_client.dart';
import '../models/product.dart';

class ProductApi {
  ProductApi(this._client);

  final ApiClient _client;

  Future<Paged<Product>> list({String? category, double? minPrice, double? maxPrice, String? search, int page = 0, int size = 20, String? sort}) async {
    final json = await _client.getJson('/products', query: {
      'category': category,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'search': search,
      'page': page,
      'size': size,
      'sort': sort,
    });
    return Paged.fromJson(json, (j) => Product.fromJson(j));
  }

  Future<Product> create(Product p) async {
    final json = await _client.postJson('/products', body: p.toJson());
    return Product.fromJson(json);
  }

  Future<Product> update(Product p) async {
    final json = await _client.putJson('/products/${p.id}', body: p.toJson());
    return Product.fromJson(json);
  }

  Future<void> delete(String id) => _client.delete('/products/$id');
}

