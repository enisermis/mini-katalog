import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/cart.dart';
import '../theme/app_theme.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  const CartPage({super.key});

  // Gercek odeme olmadigi icin siparisi tamamlayinca sadece mesaj gosterip sepeti bosaltiyorum
  Future<void> _checkout(BuildContext context, CartModel cart) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: AppColors.primary,
          size: 52,
        ),
        title: const Text('Siparişin alındı'),
        content: Text(
          'Toplam ${formatPrice(cart.totalPrice)} tutarındaki siparişin oluşturuldu.\n(Bu bir simülasyondur, ödeme alınmadı.)',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
    cart.clear();
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sepetim',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: cart.isEmpty ? _EmptyCart() : _CartList(cart: cart),
      bottomNavigationBar: cart.isEmpty
          ? null
          : _CartSummary(
              cart: cart,
              onCheckout: () => _checkout(context, cart),
            ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.remove_shopping_cart_outlined,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sepetin şu an boş',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Beğendiğin ürünleri + butonuyla buraya ekleyebilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Alışverişe başla'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  final CartModel cart;

  const _CartList({required this.cart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Sepetteki urunleri ListView.builder ile listeliyorum, sadece ekranda gorunenler olusturuluyor
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final item = cart.items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  item.product.image,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatPrice(item.total),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              // Adet arttirma / azaltma kismi
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Azalt',
                      visualDensity: VisualDensity.compact,
                      onPressed: () => cart.decrease(item.product),
                      icon: Icon(
                        item.quantity == 1
                            ? Icons.delete_outline
                            : Icons.remove,
                        size: 18,
                      ),
                    ),
                    Text(
                      '${item.quantity}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      tooltip: 'Artır',
                      visualDensity: VisualDensity.compact,
                      onPressed: () => cart.add(item.product),
                      icon: const Icon(Icons.add, size: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CartSummary extends StatelessWidget {
  final CartModel cart;
  final VoidCallback onCheckout;

  const _CartSummary({required this.cart, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _row(
              'Ürünler (${cart.itemCount} adet)',
              formatPrice(cart.totalPrice),
            ),
            const SizedBox(height: 6),
            _row('Kargo', 'Ücretsiz', valueColor: AppColors.primary),
            const Divider(height: 24),
            Row(
              children: [
                Text(
                  'Toplam',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  formatPrice(cart.totalPrice),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: onCheckout,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
              ),
              child: const Text('Siparişi Tamamla'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w600, color: valueColor),
        ),
      ],
    );
  }
}
