import 'package:flutter/foundation.dart';

import '../api/api_client.dart';
import '../api/order_api.dart';
import '../models/order.dart';
import 'cart_store.dart';

class OrderStore extends ChangeNotifier {
  final _api = OrderApi(ApiClient());

  List<Order> orders = [];
  bool loading = false;

  Future<void> refresh(String userId) async {
    loading = true;
    notifyListeners();
    try {
      orders = await _api.listByUser(userId);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<Order?> placeOrderFromCart(CartStore cartStore) async {
    if (cartStore.cart == null) return null;
    loading = true;
    notifyListeners();
    try {
      final order = await _api.placeFromCart(cartStore.cart!.id);
      await cartStore.refreshByUser();
      await refresh(CartStore.userId);
      return order;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}

