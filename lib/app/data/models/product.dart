class Product {
  final String id;
  final String name;
  final String description;
  final String units;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.units,
    required this.category,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      units: data['units'] ?? '',
      category: data['category'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'units': units,
      'category': category,
    };
  }
}
