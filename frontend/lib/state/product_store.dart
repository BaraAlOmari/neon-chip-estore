import 'package:flutter/foundation.dart';

import '../api/api_client.dart';
import '../api/product_api.dart';
import '../models/product.dart';

class ProductStore extends ChangeNotifier {
  final _api = ProductApi(ApiClient());

  List<Product> products = [];
  bool loading = false;
  String? category;
  String? search;
  double? minPrice;
  double? maxPrice;
  String? sort;
  int page = 0;
  int size = 20;
  int totalPages = 1;

  Future<void> load({int? toPage}) async {
    loading = true;
    notifyListeners();
    page = toPage ?? page;
    try {
      final res = await _api.list(
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        search: search,
        page: page,
        size: size,
        sort: sort,
      );
      products = res.content;
      _applyClientSideSort();
      totalPages = res.totalPages;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void applyFilters({String? category, String? search, double? minPrice, double? maxPrice, String? sort}) {
    this.category = category;
    this.search = search;
    this.minPrice = minPrice;
    this.maxPrice = maxPrice;
    this.sort = sort;
    page = 0;
    load();
  }

  void nextPage() {
    if (page + 1 < totalPages) load(toPage: page + 1);
  }

  void prevPage() {
    if (page > 0) load(toPage: page - 1);
  }

  void _applyClientSideSort() {
    if (products.isEmpty || sort == null) return;
    switch (sort) {
      case 'price,asc':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price,desc':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'name,asc':
        products.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case 'name,desc':
        products.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      default:
        break;
    }
  }
}
