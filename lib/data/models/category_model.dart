class CategoryModel {
  final String id;
  final String name;
  final String? image;
  final String? icon;
  final String? parentId;
  final int productCount;
  final int order;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    this.image,
    this.icon,
    this.parentId,
    this.productCount = 0,
    this.order = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: _asString(json['id'] ?? json['categoryId']),
      name: _asString(json['name'] ?? json['categoryName']),
      image: _asNullableString(json['image']),
      icon: _asNullableString(json['icon']),
      parentId: _asNullableString(json['parent_id'] ?? json['parentId']),
      productCount: _asInt(json['product_count'] ?? json['productCount']),
      order: _asInt(json['order']),
      isActive: _asBool(json['is_active'] ?? json['isActive'] ?? true),
      createdAt: _asNullableDateTime(json['created_at'] ?? json['createdAt']),
      updatedAt: _asNullableDateTime(json['updated_at'] ?? json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'icon': icon,
      'parent_id': parentId,
      'product_count': productCount,
      'order': order,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static String _asString(dynamic value) {
    final parsed = _asNullableString(value);
    return parsed ?? '';
  }

  static String? _asNullableString(dynamic value) {
    if (value == null) return null;
    final trimmed = value.toString().trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
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

  static DateTime? _asNullableDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
