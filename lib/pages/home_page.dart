import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/product_repository.dart';
import '../models/product.dart';
import '../state/cart.dart';
import '../theme/app_theme.dart';
import '../widgets/cart_icon_button.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repository = ProductRepository();
  late final Future<List<Product>> _productsFuture;

  String _search = '';
  String _category = 'Tümü';

  // Kategori butonlarinda yazinin yaninda ikon da olsun istedim
  static const _categoryIcons = {
    'Tümü': Icons.grid_view_rounded,
    'iPhone': Icons.phone_iphone,
    'Mac': Icons.laptop_mac,
    'iPad': Icons.tablet_mac,
    'Watch': Icons.watch,
    'Ses & Diğer': Icons.headphones,
  };

  @override
  void initState() {
    super.initState();
    // Urunleri sadece bir kere yukluyorum, her build'de tekrar okumasin
    _productsFuture = _repository.loadProducts();
  }

  // Arama ve kategori filtresini burada uyguluyorum
  List<Product> _filter(List<Product> products) {
    final query = _search.trim().toLowerCase();
    return products.where((p) {
      final matchesCategory = _category == 'Tümü' || p.category == _category;
      final matchesSearch =
          query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.tagline.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _quickAdd(Product product) {
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
    // Ust kisim koyu turkuaz oldugu icin saat ve pil simgeleri beyaz gorunsun
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Ürünler yüklenemedi: ${snapshot.error}'),
              );
            }

            final products = snapshot.data!;
            final categories = [
              'Tümü',
              ...{for (final p in products) p.category},
            ];
            final visible = _filter(products);

            // Baslik, banner ve kategoriler de urunlerle birlikte kaysin diye CustomScrollView kullandim
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context)),
                SliverToBoxAdapter(child: _buildBanner()),
                SliverToBoxAdapter(child: _buildCategories(categories)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                    child: Row(
                      children: [
                        Text(
                          _category == 'Tümü' ? 'Tüm ürünler' : _category,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const Spacer(),
                        Text(
                          '${visible.length} ürün',
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
                if (visible.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text('Aramana uygun ürün bulunamadı.'),
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    // Urun kartlarini GridView ile iki sutun halinde diziyorum.
                    // Sayfanin tamami zaten kaydigi icin grid'in kendi kaydirmasini kapattim.
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                      itemCount: visible.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.74,
                          ),
                      itemBuilder: (context, index) {
                        final product = visible[index];
                        return ProductCard(
                          product: product,
                          onAdd: () => _quickAdd(product),
                          // Tiklanan urunu detay sayfasina argument olarak gonderiyorum
                          onTap: () => Navigator.pushNamed(
                            context,
                            ProductDetailPage.routeName,
                            arguments: product,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Ustteki turkuaz alan: uygulama adi, sepet ikonu ve arama kutusu
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 16,
        20,
        24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hoş geldin 👋',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Mini Katalog',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const CartIconButton(onDark: true),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            onChanged: (value) => setState(() => _search = value),
            decoration: InputDecoration(
              hintText: 'Ne arıyorsun?',
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Yonergede verilen banner gorselini assets'ten gosteriyorum
  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 2118 / 474,
          child: Image.asset('assets/images/banner.jpg', fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildCategories(List<String> categories) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = _category == category;
          return GestureDetector(
            onTap: () => setState(() => _category = category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    _categoryIcons[category] ?? Icons.category,
                    size: 18,
                    color: selected ? Colors.white : AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
