import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/cart_page.dart';
import 'pages/orders_page.dart';
import 'pages/products_page.dart';
import 'state/cart_store.dart';
import 'state/product_store.dart';
import 'widgets/neon_logo.dart';
import 'feature_flags.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  final TextEditingController _searchCtl = TextEditingController();

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flags = FeatureFlags.instance;
    final cartOrderEnabled = flags.isEnabled('cart/order');

    final pages = cartOrderEnabled
        ? const [ProductsPage(), CartPage(), OrdersPage()]
        : const [ProductsPage()];
    final titles =
        cartOrderEnabled ? ['Products', 'Cart', 'Orders'] : ['Products'];

    var currentIndex = _index;
    if (currentIndex >= pages.length) {
      currentIndex = 0;
    }

    final cartCount = context.watch<CartStore>().itemCount;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 720;
        final isWide = width >= 900;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const NeonLogo(size: 28),
                const SizedBox(width: 10),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF00E5FF),
                      Color.fromARGB(255, 200, 0, 255)
                    ],
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: const Text(
                    'NeonChip •',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                            color: Color(0x8000E5FF),
                            blurRadius: 12,
                            offset: Offset(0, 0)),
                        Shadow(
                            color: Color(0x80FF00D4),
                            blurRadius: 12,
                            offset: Offset(0, 0)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    titles[currentIndex],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            actions: [
              if (!isMobile && currentIndex == 0)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  child: SizedBox(
                    height: 40,
                    width: 420,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchCtl,
                            onSubmitted: (_) => _triggerSearch(context),
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              prefixIcon: Icon(Icons.search),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 40,
                          child: FilledButton.icon(
                            onPressed: () => _triggerSearch(context),
                            icon: const Icon(Icons.search),
                            label: const Text('Search'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (isMobile && currentIndex == 0)
                IconButton(
                  tooltip: 'Search',
                  onPressed: () => _openSearchSheet(context),
                  icon: const Icon(Icons.search),
                ),
              if (cartOrderEnabled)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Cart',
                      onPressed: () => setState(() => _index = 1),
                      icon: const Icon(Icons.shopping_cart_outlined),
                    ),
                    if (cartCount > 0)
                      Positioned(
                        right: 1,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                  ],
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0B0F1A), Color(0xFF0F1530)],
              ),
            ),
            child: Row(
              children: [
                if (isWide)
                  NavigationRail(
                    selectedIndex: currentIndex,
                    onDestinationSelected: (i) => setState(() => _index = i),
                    labelType: NavigationRailLabelType.all,
                    destinations: cartOrderEnabled
                        ? const [
                            NavigationRailDestination(
                              icon: Icon(Icons.storefront_outlined),
                              label: Text('Products'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.shopping_cart_outlined),
                              label: Text('Cart'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.receipt_long_outlined),
                              label: Text('Orders'),
                            ),
                          ]
                        : const [
                            NavigationRailDestination(
                              icon: Icon(Icons.storefront_outlined),
                              label: Text('Products'),
                            ),
                          ],
                  ),
                Expanded(child: pages[currentIndex]),
              ],
            ),
          ),
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: currentIndex,
                  onDestinationSelected: (i) => setState(() => _index = i),
                  destinations: cartOrderEnabled
                      ? const [
                          NavigationDestination(
                            icon: Icon(Icons.storefront_outlined),
                            label: 'Products',
                          ),
                          NavigationDestination(
                              icon: Icon(Icons.shopping_cart_outlined),
                              label: 'Cart'),
                          NavigationDestination(
                              icon: Icon(Icons.receipt_long_outlined),
                              label: 'Orders'),
                        ]
                      : const [
                          NavigationDestination(
                            icon: Icon(Icons.storefront_outlined),
                            label: 'Products',
                          ),
                        ],
                ),
        );
      },
    );
  }

  void _triggerSearch(BuildContext context) {
    if (_index != 0) return;
    final store = context.read<ProductStore>();
    final text = _searchCtl.text.trim();
    store.applyFilters(
      category: store.category,
      search: text.isEmpty ? null : text,
      minPrice: store.minPrice,
      maxPrice: store.maxPrice,
      sort: store.sort,
    );
  }

  void _openSearchSheet(BuildContext context) {
    if (_index != 0) return;
    final store = context.read<ProductStore>();
    _searchCtl.text = store.search ?? '';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchCtl,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) {
                  _triggerSearch(ctx);
                  Navigator.of(ctx).pop();
                },
                decoration: const InputDecoration(
                  hintText: 'Search products',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () {
                    _triggerSearch(ctx);
                    Navigator.of(ctx).pop();
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
