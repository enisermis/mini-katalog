import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/cart.dart';
import '../theme/app_theme.dart';
import '../widgets/cart_icon_button.dart';

class ProductDetailPage extends StatelessWidget {
  static const routeName = '/detail';

  final Product product;

  const ProductDetailPage({super.key, required this.product});

  // JSON'daki ozellik anahtarlari ingilizce oldugu icin ekranda Turkce karsiliklarini gosteriyorum
  static const _specLabels = {
    'chip': 'İşlemci',
    'material': 'Malzeme',
    'camera': 'Kamera',
    'display': 'Ekran',
    'battery': 'Pil',
    'id': 'Kimlik doğrulama',
    'ports': 'Bağlantı noktaları',
    'weight': 'Ağırlık',
    'design': 'Tasarım',
    'colors': 'Renkler',
    'screen': 'Ekran',
    'pencil': 'Kalem desteği',
    'case': 'Kasa',
    'brightness': 'Parlaklık',
    'gps': 'GPS',
    'os': 'İşletim sistemi',
    'control': 'Kontrol',
    'audio': 'Ses',
    'driver': 'Hoparlör',
    'cancellation': 'Gürültü engelleme',
    'materials': 'Malzemeler',
    'home': 'Akıllı ev',
    'sensing': 'Sensörler',
    'size': 'Boyut',
  };

  static const _specIcons = {
    'chip': Icons.memory,
    'camera': Icons.photo_camera_outlined,
    'display': Icons.smartphone,
    'screen': Icons.smartphone,
    'battery': Icons.battery_charging_full,
    'audio': Icons.graphic_eq,
  };

  void _addToCart(BuildContext context) {
    CartScope.of(context).add(product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} sepete eklendi'),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Ustte buyuk urun resmi, asagi kaydirinca kuculup normal app bar'a donusuyor
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: Padding(
              padding: const EdgeInsets.all(6),
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                child: IconButton(
                  tooltip: 'Geri',
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.primaryDark,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: const [CartIconButton(), SizedBox(width: 12)],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${product.id}',
                child: Image.asset(product.image, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.tagline,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Ürün hakkında',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Teknik özellikler',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        for (final spec in product.specs.entries)
                          ListTile(
                            dense: true,
                            leading: Icon(
                              _specIcons[spec.key] ??
                                  Icons.check_circle_outline,
                              color: AppColors.primary,
                            ),
                            title: Text(
                              _specLabels[spec.key] ?? spec.key,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                              ),
                            ),
                            trailing: Text(
                              spec.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Altta fiyat ve sepete ekle butonu hep gorunsun diye bottomNavigationBar'a koydum
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fiyat',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  Text(
                    product.formattedPrice,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _addToCart(context),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Sepete Ekle'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
