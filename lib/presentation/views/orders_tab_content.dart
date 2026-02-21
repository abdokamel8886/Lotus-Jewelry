import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/order.dart';
import '../providers/app_providers.dart';
import '../widgets/app_footer.dart';

/// Orders tab: list user orders from Firebase + footer
class OrdersTabContent extends ConsumerWidget {
  const OrdersTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authManager = ref.watch(firebaseAuthManagerProvider);
    final user = authManager.currentUser;

    if (user == null) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Icon(Icons.person_outline, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 24),
                  Text(
                    'Sign in to view your orders',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                        AppNavigator.goAuth(context),
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
          const AppFooter(),
        ],
      );
    }

    return FutureBuilder<List<Order>>(
      future: ref.read(firebaseRealtimeDbManagerProvider).getOrders(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data ?? [];

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    if (orders.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(Icons.receipt_long_outlined,
                                size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'No orders yet',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...orders.map((order) => _OrderCard(order: order)),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
            const AppFooter(),
          ],
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id.length > 12 ? order.id.substring(order.id.length - 8) : order.id}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: order.status == 'paid'
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: order.status == 'paid'
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            dateStr,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          ...order.items.take(3).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${item.name} x${item.quantity}${item.size != null ? ' (Size: ${item.size})' : ''}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        '\$${item.totalPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.gold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          if (order.items.length > 3)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '+ ${order.items.length - 3} more',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.w600)),
              Text(
                '\$${order.total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.gold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
