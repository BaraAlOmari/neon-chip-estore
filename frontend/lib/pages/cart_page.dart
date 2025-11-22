import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../state/cart_store.dart';
import '../state/order_store.dart';

enum PaymentMethod { card, paypal, cash }

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  PaymentMethod? _payment;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartStore>();
    final fmt = NumberFormat.currency(symbol: '\$');

    if (cart.loading && cart.cart == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final c = cart.cart;
    if (c == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.remove_shopping_cart_outlined, size: 64, color: Colors.black26),
            const SizedBox(height: 12),
            const Text('Cart not available'),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: cart.refreshByUser, child: const Text('Retry')),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: c.items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final item = c.items[i];
              return ListTile(
                leading: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? Image.network(item.imageUrl!, width: 56, height: 56, fit: BoxFit.cover)
                    : const Icon(Icons.photo_size_select_actual_outlined, size: 48),
                title: Text(item.name),
                subtitle: Text('${fmt.format(item.unitPrice)} × ${item.quantity} = ${fmt.format(item.unitPrice * item.quantity)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: item.quantity > 1 ? () => cart.setQuantity(item.productId, item.quantity - 1) : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('${item.quantity}'),
                    IconButton(
                      onPressed: () => cart.setQuantity(item.productId, item.quantity + 1),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                    IconButton(
                      onPressed: () => cart.remove(item.productId),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 520;
                  final totalText = Text(
                    'Total: ${fmt.format(cart.total)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 26,
                        ),
                  );
                  final chips = Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: [
                      ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.credit_card, size: 16),
                            SizedBox(width: 6),
                            Text('Credit/Debit Card'),
                          ],
                        ),
                        selected: _payment == PaymentMethod.card,
                        onSelected: (_) => setState(() => _payment = PaymentMethod.card),
                      ),
                      ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.account_balance_wallet, size: 16),
                            SizedBox(width: 6),
                            Text('PayPal'),
                          ],
                        ),
                        selected: _payment == PaymentMethod.paypal,
                        onSelected: (_) => setState(() => _payment = PaymentMethod.paypal),
                      ),
                      ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.monetization_on_outlined, size: 16),
                            SizedBox(width: 6),
                            Text('Cash on Delivery'),
                          ],
                        ),
                        selected: _payment == PaymentMethod.cash,
                        onSelected: (_) => setState(() => _payment = PaymentMethod.cash),
                      ),
                    ],
                  );

                  if (isNarrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        totalText,
                        const SizedBox(height: 8),
                        Align(alignment: Alignment.centerLeft, child: chips),
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      totalText,
                      chips,
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: cart.itemCount == 0 || _payment == null
                    ? null
                    : () async {
                        final order = await context.read<OrderStore>().placeOrderFromCart(cart);
                        if (context.mounted && order != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Order placed • #${order.id.substring(0, 6)}')),
                          );
                        }
                      },
                icon: const Icon(Icons.local_shipping_outlined),
                label: Text(_payment == null ? 'Select payment' : 'Place Order'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
