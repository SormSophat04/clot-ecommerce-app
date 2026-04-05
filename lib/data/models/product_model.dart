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
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final bool hasVariations;
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
    this.rating = 0,
    this.reviewCount = 0,
    this.isFavorite = false,
    this.hasVariations = false,
    this.variations,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      salePrice: json['sale_price']?.toDouble(),
      image: json['image'],
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : null,
      stock: json['stock'] ?? 0,
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      isFavorite: json['is_favorite'] ?? false,
      hasVariations: json['has_variations'] ?? false,
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
      'rating': rating,
      'review_count': reviewCount,
      'is_favorite': isFavorite,
      'has_variations': hasVariations,
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
    double? rating,
    int? reviewCount,
    bool? isFavorite,
    bool? hasVariations,
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
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      hasVariations: hasVariations ?? this.hasVariations,
      variations: variations ?? this.variations,
    );
  }

  double get finalPrice => salePrice ?? price;
  bool get onSale => salePrice != null && salePrice! < price;
  double get discountPercentage {
    if (salePrice == null || salePrice! >= price) return 0;
    return ((price - salePrice!) / price * 100);
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
