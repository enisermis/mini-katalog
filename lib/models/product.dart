// Urun model sinifi. JSON'dan gelen her urunu bu sinifa ceviriyorum.
class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final double price;
  final String currency;
  final String image; // assets icindeki gorselin yolu
  final String category;
  final Map<String, String> specs;

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    required this.category,
    required this.specs,
  });

  // Hocam JSON'daki alanlari tek tek okuyup nesneye ceviriyorum,
  // bir alan eksik gelirse uygulama cokmesin diye varsayilan deger verdim
  factory Product.fromJson(Map<String, dynamic> json) {
    final rawSpecs = (json['specs'] as Map<String, dynamic>?) ?? {};
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: (json['tagline'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      price: (json['price'] as num).toDouble(),
      currency: (json['currency'] as String?) ?? 'USD',
      image: json['image'] as String,
      category: (json['category'] as String?) ?? 'Diğer',
      specs: rawSpecs.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tagline': tagline,
    'description': description,
    'price': price,
    'currency': currency,
    'image': image,
    'category': category,
    'specs': specs,
  };

  // Fiyati $1,299 gibi binlik ayracli gostermek icin kucuk bir yardimci
  String get formattedPrice => formatPrice(price);
}

String formatPrice(double value) {
  final whole = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '\$$buffer';
}
