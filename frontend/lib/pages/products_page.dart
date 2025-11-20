import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../state/cart_store.dart';
import '../state/product_store.dart';
import '../widgets/product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _minCtl = TextEditingController();
  final _maxCtl = TextEditingController();
  String? _sort;
  String? _category;

  @override
  void dispose() {
    _minCtl.dispose();
    _maxCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ProductStore>();
    final cart = context.read<CartStore>();
    final fmt = NumberFormat.currency(symbol: '\$');

    return Column(
      children: [
        _Filters(
          minCtl: _minCtl,
          maxCtl: _maxCtl,
          sort: _sort,
          selectedCategory: _category,
          onApply: () {
            store.applyFilters(
              category: _category,
              search: store.search,
              minPrice: double.tryParse(_minCtl.text),
              maxPrice: double.tryParse(_maxCtl.text),
              sort: _sort,
            );
          },
          onSortChanged: (v) => setState(() => _sort = v),
          onCategoryChanged: (value) => setState(() => _category = value),
        ),
        Expanded(
          child: store.loading
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  builder: (context, c) {
                    final crossAxis = c.maxWidth ~/ 260; // approx card width
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxis.clamp(1, 6),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: store.products.length,
                      itemBuilder: (context, i) {
                        final p = store.products[i];
                        return ProductCard(
                          product: p,
                          onAdd: () async {
                            await cart.add(p.id!, quantity: 1);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Added ${p.name} to cart (${fmt.format(p.price)})')),
                              );
                            }
                          },
                          onOpen: () => _showProductDetails(p),
                        );
                      },
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Page ${store.page + 1} of ${store.totalPages}'),
              Row(children: [
                OutlinedButton.icon(onPressed: store.page > 0 ? store.prevPage : null, icon: const Icon(Icons.chevron_left), label: const Text('Prev')),
                const SizedBox(width: 8),
                FilledButton.icon(onPressed: store.page + 1 < store.totalPages ? store.nextPage : null, icon: const Icon(Icons.chevron_right), label: const Text('Next')),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.minCtl,
    required this.maxCtl,
    required this.onApply,
    required this.onSortChanged,
    required this.onCategoryChanged,
    this.sort,
    this.selectedCategory,
  });

  final TextEditingController minCtl;
  final TextEditingController maxCtl;
  final VoidCallback onApply;
  final void Function(String?) onSortChanged;
  final void Function(String?) onCategoryChanged;
  final String? sort;
  final String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 220,
            child: DropdownButtonFormField<String>(
              value: selectedCategory ?? '',
              decoration: const InputDecoration(labelText: 'Category'),
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: '',
                  child: Text('All categories', overflow: TextOverflow.ellipsis, maxLines: 1),
                ),
                DropdownMenuItem(
                  value: 'Mice',
                  child: Text('Mice', overflow: TextOverflow.ellipsis, maxLines: 1),
                ),
                DropdownMenuItem(
                  value: 'Keyboards',
                  child: Text('Keyboards', overflow: TextOverflow.ellipsis, maxLines: 1),
                ),
                DropdownMenuItem(
                  value: 'Mouse Pads',
                  child: Text('Mouse Pads', overflow: TextOverflow.ellipsis, maxLines: 1),
                ),
                DropdownMenuItem(
                  value: 'Headsets & Microphones',
                  child: Text('Headsets & Microphones', overflow: TextOverflow.ellipsis, maxLines: 1),
                ),
                DropdownMenuItem(
                  value: 'Storage',
                  child: Text('Storage', overflow: TextOverflow.ellipsis, maxLines: 1),
                ),
              ],
              onChanged: (value) {
                // Empty string represents \"all categories\" (no filter)
                onCategoryChanged((value == null || value.isEmpty) ? null : value);
                onApply();
              },
            ),
          ),
          SizedBox(
            width: 120,
            child: TextField(controller: minCtl, keyboardType: TextInputType.number, decoration: const InputDecoration(prefixText: '\$', labelText: 'Min')),
          ),
          SizedBox(
            width: 120,
            child: TextField(controller: maxCtl, keyboardType: TextInputType.number, decoration: const InputDecoration(prefixText: '\$', labelText: 'Max')),
          ),
          DropdownButton<String>(
            value: sort,
            hint: const Text('Sort'),
            items: const [
              DropdownMenuItem(value: 'price,asc', child: Text('Price ↑')),
              DropdownMenuItem(value: 'price,desc', child: Text('Price ↓')),
              DropdownMenuItem(value: 'name,asc', child: Text('Name A-Z')),
              DropdownMenuItem(value: 'name,desc', child: Text('Name Z-A')),
            ],
            onChanged: (value) {
              onSortChanged(value);
              onApply();
            },
          ),
          FilledButton.icon(onPressed: onApply, icon: const Icon(Icons.filter_alt), label: const Text('Apply')),
        ],
      ),
    );
  }
}

extension _ProductDetails on _ProductsPageState {
  Future<void> _showProductDetails(Product product) async {
    final cart = context.read<CartStore>();
    final fmt = NumberFormat.currency(symbol: '\$');

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final primary = theme.colorScheme.primary;
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F1530), Color(0xFF121833)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: primary.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(color: primary.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 0)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.black26,
                          child: const Center(child: Icon(Icons.inventory_2_outlined, size: 56)),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: theme.textTheme.headlineSmall,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (product.priceAfterDiscount != null &&
                                    product.priceAfterDiscount! < product.price)
                                  Text(
                                    fmt.format(product.price),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.white60,
                                        ),
                                  ),
                                Text(
                                  fmt.format(product.priceAfterDiscount ?? product.price),
                                  style: theme.textTheme.titleLarge?.copyWith(color: primary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (product.category != null && product.category!.isNotEmpty)
                          Text(
                            product.category!,
                            style: theme.textTheme.labelLarge?.copyWith(color: Colors.white70),
                          ),
                        const SizedBox(height: 12),
                        Text(
                          (product.description?.isNotEmpty ?? false)
                              ? product.description!
                              : 'No description available yet.',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'In stock: ${product.stock}',
                              style: theme.textTheme.labelMedium,
                            ),
                            FilledButton.icon(
                              onPressed: product.id == null
                                  ? null
                                  : () async {
                                      await cart.add(product.id!, quantity: 1);
                                      if (mounted) Navigator.of(ctx).pop();
                                    },
                              icon: const Icon(Icons.add_shopping_cart),
                              label: const Text('Add to cart'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
