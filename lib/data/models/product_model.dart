class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? salePrice;
  final String? image;
  final List<String>? images;
  final int stock;
  final String categoryId;
  final String categoryName;
  final String? gender;
  final String? brandId;
  final String? brandName;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final bool hasVariations;
  final List<String> availableColors;
  final List<String> availableSizes;
  final List<ProductVariation>? variations;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.salePrice,
    this.image,
    this.images,
    required this.stock,
    required this.categoryId,
    required this.categoryName,
    this.gender,
    this.brandId,
    this.brandName,
    this.rating = 0,
    this.reviewCount = 0,
    this.isFavorite = false,
    this.hasVariations = false,
    this.availableColors = const [],
    this.availableSizes = const [],
    this.variations,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final category = _asMap(json['category']);
    final brand = _asMap(json['brand']);
    final parsedImages = _toStringList(json['images']);

    return ProductModel(
      id: _asString(json['id'] ?? json['productId']),
      name: _asString(json['name'] ?? json['productName']),
      description: _asString(json['description']),
      price: _asDouble(json['price']),
      salePrice: _asNullableDouble(json['sale_price'] ?? json['salePrice']),
      image:
          _asNullableString(json['image']) ??
          (parsedImages.isNotEmpty ? parsedImages.first : null),
      images: parsedImages,
      stock: _asInt(json['stock'] ?? json['stockQuantity']),
      categoryId: _asString(
        json['category_id'] ?? json['categoryId'] ?? category['categoryId'],
      ),
      categoryName: _asString(
        json['category_name'] ??
            json['categoryName'] ??
            category['categoryName'],
      ),
      gender: _asNullableString(json['gender']),
      brandId: _asNullableString(
        json['brand_id'] ?? json['brandId'] ?? brand['brandId'],
      ),
      brandName: _asNullableString(
        json['brand_name'] ?? json['brandName'] ?? brand['brandName'],
      ),
      rating: _asDouble(json['rating']),
      reviewCount: _asInt(json['review_count'] ?? json['reviewCount']),
      isFavorite: _asBool(json['is_favorite'] ?? json['isFavorite']),
      hasVariations: _asBool(
        json['has_variations'] ??
            json['hasVariations'] ??
            (json['variations'] != null),
      ),
      availableColors: _extractOptionNames(
        json['colors'],
        primaryKey: 'colorName',
      ),
      availableSizes: _extractOptionNames(
        json['sizes'],
        primaryKey: 'sizeName',
      ),
      variations: json['variations'] != null
          ? (json['variations'] as List)
                .map((v) => ProductVariation.fromJson(v))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'sale_price': salePrice,
      'image': image,
      'images': images,
      'stock': stock,
      'category_id': categoryId,
      'category_name': categoryName,
      'gender': gender,
      'brand_id': brandId,
      'brand_name': brandName,
      'rating': rating,
      'review_count': reviewCount,
      'is_favorite': isFavorite,
      'has_variations': hasVariations,
      'colors': availableColors,
      'sizes': availableSizes,
      'variations': variations?.map((v) => v.toJson()).toList(),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? salePrice,
    String? image,
    List<String>? images,
    int? stock,
    String? categoryId,
    String? categoryName,
    String? gender,
    String? brandId,
    String? brandName,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
    bool? hasVariations,
    List<String>? availableColors,
    List<String>? availableSizes,
    List<ProductVariation>? variations,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      image: image ?? this.image,
      images: images ?? this.images,
      stock: stock ?? this.stock,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      gender: gender ?? this.gender,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      hasVariations: hasVariations ?? this.hasVariations,
      availableColors: availableColors ?? this.availableColors,
      availableSizes: availableSizes ?? this.availableSizes,
      variations: variations ?? this.variations,
    );
  }

  double get finalPrice => salePrice ?? price;
  bool get onSale => salePrice != null && salePrice! < price;
  double get discountPercentage {
    if (salePrice == null || salePrice! >= price || price == 0) return 0;
    return ((price - salePrice!) / price * 100);
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  static List<String> _toStringList(dynamic value) {
    if (value is! List) return const <String>[];
    return value
        .map((item) => _asNullableString(item))
        .whereType<String>()
        .where((item) => item.isNotEmpty)
        .toList();
  }

  static List<String> _extractOptionNames(
    dynamic value, {
    required String primaryKey,
  }) {
    if (value is! List) return const <String>[];
    return value
        .map((item) {
          if (item is String) return item;
          final map = _asMap(item);
          return _asNullableString(
            map[primaryKey] ?? map['name'] ?? map['value'],
          );
        })
        .whereType<String>()
        .where((item) => item.isNotEmpty)
        .toList();
  }

  static String _asString(dynamic value) => _asNullableString(value) ?? '';

  static String? _asNullableString(dynamic value) {
    if (value == null) return null;
    final result = value.toString().trim();
    return result.isEmpty ? null : result;
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _asDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static double? _asNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }
}

class ProductVariation {
  final String id;
  final String name;
  final String value;
  final double? priceAdjustment;
  final int stock;

  ProductVariation({
    required this.id,
    required this.name,
    required this.value,
    this.priceAdjustment,
    required this.stock,
  });

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      value: json['value'] ?? '',
      priceAdjustment: json['price_adjustment']?.toDouble(),
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'price_adjustment': priceAdjustment,
      'stock': stock,
    };
  }
}
