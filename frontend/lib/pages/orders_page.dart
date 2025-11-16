import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../state/cart_store.dart';
import '../state/order_store.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<OrderStore>().refresh(CartStore.userId));
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderStore>();
    final fmt = NumberFormat.currency(symbol: '\$');

    if (orders.loading && orders.orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orders.orders.isEmpty) {
      return const Center(child: Text('No orders yet'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.orders.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final o = orders.orders[i];
        return ExpansionTile(
          leading: Icon(_statusIcon(o.status), color: _statusColor(context, o.status)),
          title: Text('Order #${o.id.substring(0, 8)}'),
          subtitle: Text('${o.createdAt ?? '-'} • Total ${fmt.format(o.total)} • ${o.status.name.toUpperCase()}'),
          children: [
            ...o.items.map((it) => ListTile(
                  dense: true,
                  title: Text(it.name),
                  trailing: Text('${fmt.format(it.unitPrice)} × ${it.quantity} = ${fmt.format(it.unitPrice * it.quantity)}'),
                )),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  IconData _statusIcon(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return Icons.hourglass_bottom;
      case OrderStatus.shipped:
        return Icons.local_shipping_outlined;
      case OrderStatus.delivered:
        return Icons.check_circle_outline;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  Color _statusColor(BuildContext context, OrderStatus s) {
    final c = Theme.of(context).colorScheme;
    switch (s) {
      case OrderStatus.pending:
        return c.secondary;
      case OrderStatus.shipped:
        return c.primary;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.redAccent;
    }
  }
}

