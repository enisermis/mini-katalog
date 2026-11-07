import 'package:flutter/material.dart';

import '../pages/cart_page.dart';
import '../state/cart.dart';
import '../theme/app_theme.dart';

// Sepet ikonu. Sepette urun varsa kac adet oldugunu turuncu rozetle gosteriyor.
// Ana sayfada koyu zemin uzerinde, diger sayfalarda acik zemin uzerinde durdugu icin rengini disaridan aliyorum.
class CartIconButton extends StatelessWidget {
  final bool onDark;

  const CartIconButton({super.key, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    final count = CartScope.of(context).itemCount;
    return Material(
      color: onDark ? Colors.white.withValues(alpha: 0.15) : Colors.white,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: 'Sepet',
        onPressed: () => Navigator.pushNamed(context, CartPage.routeName),
        icon: Badge(
          isLabelVisible: count > 0,
          backgroundColor: AppColors.accent,
          label: Text(
            '$count',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          child: Icon(
            Icons.shopping_cart_outlined,
            color: onDark ? Colors.white : AppColors.primaryDark,
          ),
        ),
      ),
    );
  }
}
