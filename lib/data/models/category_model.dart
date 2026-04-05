class CategoryModel {
  final String id;
  final String name;
  final String? image;
  final String? icon;
  final String? parentId;
  final int productCount;
  final int order;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    this.image,
    this.icon,
    this.parentId,
    this.productCount = 0,
    this.order = 0,
    this.isActive = true,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      icon: json['icon'],
      parentId: json['parent_id'],
      productCount: json['product_count'] ?? 0,
      order: json['order'] ?? 0,
      isActive: json['is_active'] ?? true,
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
    };
  }
}
