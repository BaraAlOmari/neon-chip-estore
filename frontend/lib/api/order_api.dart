import '../api/api_client.dart';
import '../models/order.dart';

class OrderApi {
  OrderApi(this._client);
  final ApiClient _client;

  Future<Order> placeFromCart(String cartId) async {
    final json = await _client.postJson('/orders/from-cart/$cartId');
    return Order.fromJson(json);
  }

  Future<List<Order>> listByUser(String userId) async {
    final list = await _client.getJsonList('/orders/by-user/$userId');
    return list.map((e) => Order.fromJson((e as Map).cast<String, dynamic>())).toList();
  }

  Future<Order> get(String orderId) async {
    final json = await _client.getJson('/orders/$orderId');
    return Order.fromJson(json);
  }
}

