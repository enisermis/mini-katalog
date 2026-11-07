import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/state/cart.dart';

// Model ve sepet mantigini emulator acmadan hizlica kontrol etmek icin yazdigim testler
void main() {
  final json = {
    'id': 1,
    'name': 'iPhone 15 Pro',
    'tagline': 'Titanium.',
    'description': 'Aciklama',
    'price': 999,
    'currency': 'USD',
    'image': 'assets/images/iphone.jpg',
    'category': 'iPhone',
    'specs': {'chip': 'A17 Pro'},
  };

  test('fromJson ve toJson ayni veriyi veriyor', () {
    final product = Product.fromJson(json);
    expect(product.name, 'iPhone 15 Pro');
    expect(product.price, 999.0);
    expect(product.specs['chip'], 'A17 Pro');
    expect(Product.fromJson(product.toJson()).toJson(), product.toJson());
  });

  test('fiyat binlik ayracla yaziliyor', () {
    expect(formatPrice(999), '\$999');
    expect(formatPrice(2499), '\$2,499');
    expect(formatPrice(12345), '\$12,345');
  });

  test('sepete ekleme, azaltma ve toplam', () {
    final cart = CartModel();
    final product = Product.fromJson(json);
    cart.add(product);
    cart.add(product);
    expect(cart.itemCount, 2);
    expect(cart.totalPrice, 1998);
    cart.decrease(product);
    expect(cart.itemCount, 1);
    cart.decrease(product);
    expect(cart.isEmpty, true);
  });
}
