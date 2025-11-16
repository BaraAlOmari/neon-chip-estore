import 'package:flutter/foundation.dart';

import '../api/api_client.dart';
import '../api/cart_api.dart';
import '../models/cart.dart';

class CartStore extends ChangeNotifier {
  final _api = CartApi(ApiClient());
  static const String userId = 'desktop-user-1';

  Cart? cart;
  bool loading = false;

  int get itemCount => cart?.items.fold<int>(0, (a, b) => a + b.quantity) ?? 0;
  double get total => cart?.total ?? 0.0;

  Future<void> initialize() async {
    await refreshByUser();
  }

  Future<void> refreshByUser() async {
    loading = true;
    notifyListeners();
    try {
      cart = await _api.getByUser(userId);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> add(String productId, {int quantity = 1}) async {
    if (cart == null) await refreshByUser();
    if (cart == null) return;
    loading = true;
    notifyListeners();
    try {
      cart = await _api.addItem(cart!.id, productId, quantity);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> setQuantity(String productId, int quantity) async {
    if (cart == null) await refreshByUser();
    if (cart == null) return;
    loading = true;
    notifyListeners();
    try {
      cart = await _api.updateQuantity(cart!.id, productId, quantity);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> remove(String productId) async {
    if (cart == null) await refreshByUser();
    if (cart == null) return;
    loading = true;
    notifyListeners();
    try {
      cart = await _api.removeItem(cart!.id, productId);
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
