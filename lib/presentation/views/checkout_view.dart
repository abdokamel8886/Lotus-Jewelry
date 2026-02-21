import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/order.dart';
import '../providers/app_providers.dart';
import '../viewmodels/cart_viewmodel.dart';

/// Checkout - dummy payment form, saves order to Firebase on success
class CheckoutView extends ConsumerStatefulWidget {
  const CheckoutView({super.key});

  @override
  ConsumerState<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends ConsumerState<CheckoutView> {
  final _formKey = GlobalKey<FormState>();
  final _cardController = TextEditingController(text: '4111 1111 1111 1111');
  final _expiryController = TextEditingController(text: '12/28');
  final _cvvController = TextEditingController(text: '123');
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    if (!_formKey.currentState!.validate()) return;

    final authManager = ref.read(firebaseAuthManagerProvider);
    final user = authManager.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in to complete your order'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final cartRepo = ref.read(cartRepositoryProvider);
    final items = cartRepo.getCartItems();
    if (items.isEmpty) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final orderItems = items
        .map(
          (c) => OrderItem(
            productId: c.product.id,
            name: c.product.name,
            price: c.product.finalPrice,
            quantity: c.quantity,
            imageUrl: c.product.imageUrl,
          ),
        )
        .toList();
    final total = cartRepo.getTotalPrice();
    final orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';
    final order = Order(
      id: orderId,
      userId: user.uid,
      items: orderItems,
      total: total,
      createdAt: DateTime.now(),
      status: 'paid',
    );

    try {
      final db = ref.read(firebaseRealtimeDbManagerProvider);
      await db.saveOrder(order);

      ref.read(cartViewModelProvider).clearCart();

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppConstants.routeHome,
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order placed! ID: $orderId'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place order: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartRepo = ref.watch(cartRepositoryProvider);
    final items = cartRepo.getCartItems();
    final total = cartRepo.getTotalPrice();

    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.charcoal,
      ),
      body: items.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _OrderSummary(items: items, total: total),
                    const SizedBox(height: 32),
                    Text(
                      'Payment Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dummy payment - use any card number',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _cardController,
                      decoration: const InputDecoration(
                        labelText: 'Card Number',
                        prefixIcon: Icon(Icons.credit_card),
                      ),
                      validator: (v) =>
                          (v == null || v.length < 4) ? 'Enter card number' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _expiryController,
                            decoration: const InputDecoration(
                              labelText: 'Expiry (MM/YY)',
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _cvvController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'CVV',
                            ),
                            validator: (v) =>
                                (v == null || v.length < 3) ? 'Enter CVV' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _handlePayment,
                        child: _isProcessing
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Processing...'),
                                ],
                              )
                            : Text('Pay \$${total.toStringAsFixed(0)}'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Back to Cart'),
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final List<CartItem> items;
  final double total;

  const _OrderSummary({required this.items, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            'Order Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          ...items.take(5).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.product.imageUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 48,
                            height: 48,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${item.product.name} x${item.quantity}',
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${item.totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          if (items.length > 5)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                '+ ${items.length - 5} more items',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.w600)),
              Text(
                '\$${total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
