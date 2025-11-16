import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
    this.onOpen,
  });

  final Product product;
  final VoidCallback onAdd;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '\$');
    final primary = Theme.of(context).colorScheme.primary;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: primary.withOpacity(0.25)),
        borderRadius: BorderRadius.zero,
      ),
      child: InkWell(
        onTap: onOpen ?? onAdd,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F1530), Color(0xFF121833)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: primary.withOpacity(0.25),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                    ? Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          child: Image.network(
                            product.imageUrl!,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            errorBuilder: (_, __, ___) => _placeholder(),
                          ),
                        ),
                      )
                    : _placeholder(),
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                // Give the name + price/button enough vertical room to avoid overflow
                height: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          fmt.format(product.price),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        FilledButton.icon(
                          onPressed: onAdd,
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Add'),
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
  }

  Widget _placeholder() => Container(
        color: Colors.white,
        child: const Center(child: Icon(Icons.inventory_2_outlined, size: 48, color: Colors.black38)),
      );
}
