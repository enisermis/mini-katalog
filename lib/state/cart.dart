import 'package:flutter/widgets.dart';

import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem(this.product, {this.quantity = 1});

  double get total => product.price * quantity;
}

// Sepet simulasyonu. Gercek bir odeme yok, sadece uygulama acikken urunleri tutuyor.
// Sepet degisince dinleyen ekranlar (sepet ikonu, sepet sayfasi) kendini yeniliyor.
class CartModel extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get itemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.values.fold(0, (sum, item) => sum + item.total);

  bool get isEmpty => _items.isEmpty;

  void add(Product product) {
    final existing = _items[product.id];
    if (existing != null) {
      existing.quantity++;
    } else {
      _items[product.id] = CartItem(product);
    }
    notifyListeners();
  }

  void decrease(Product product) {
    final existing = _items[product.id];
    if (existing == null) return;
    if (existing.quantity > 1) {
      existing.quantity--;
    } else {
      _items.remove(product.id);
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.remove(product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// Sepeti her sayfaya parametre olarak tasimamak icin InheritedNotifier kullandim.
// Herhangi bir widget CartScope.of(context) diyerek sepete ulasabiliyor.
class CartScope extends InheritedNotifier<CartModel> {
  const CartScope({super.key, required CartModel cart, required super.child})
    : super(notifier: cart);

  static CartModel of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope bulunamadi');
    return scope!.notifier!;
  }
}
