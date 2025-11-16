import '../api/api_client.dart';
import '../models/cart.dart';

class CartApi {
  CartApi(this._client);

  final ApiClient _client;

  Future<Cart> getByUser(String userId) async {
    final json = await _client.getJson('/carts/by-user/$userId');
    return Cart.fromJson(json);
  }

  Future<Cart> get(String cartId) async {
    final json = await _client.getJson('/carts/$cartId');
    return Cart.fromJson(json);
  }

  Future<Cart> addItem(String cartId, String productId, int quantity) async {
    final json = await _client.postJson('/carts/$cartId/items', query: {
      'productId': productId,
      'quantity': quantity,
    });
    return Cart.fromJson(json);
  }

  Future<Cart> updateQuantity(String cartId, String productId, int quantity) async {
    final json = await _client.patchJson('/carts/$cartId/items/$productId', query: {
      'quantity': quantity,
    });
    return Cart.fromJson(json);
  }

  Future<Cart> removeItem(String cartId, String productId) async {
    final json = await _client.delete('/carts/$cartId/items/$productId');
    // Backend returns Cart; since our delete returns body omitted, adjust controller if needed.
    // Our backend returns Cart in delete; but ApiClient.delete doesn't parse. Use get after delete.
    return get(cartId);
  }
}

