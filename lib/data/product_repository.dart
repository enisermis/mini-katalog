import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/product.dart';

// Yonergede ekstra paket kullanmamamiz istendigi icin internetten http ile cekmek yerine
// wantapi.com/products.php'deki veriyi assets/data/products.json olarak projeye koydum.
// Burada o dosyayi okuyup sanki bir API'den geliyormus gibi listeye ceviriyorum.
class ProductRepository {
  static const _path = 'assets/data/products.json';

  Future<List<Product>> loadProducts() async {
    final text = await rootBundle.loadString(_path);
    final json = jsonDecode(text) as Map<String, dynamic>;
    final list = json['products'] as List<dynamic>;
    return list
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
