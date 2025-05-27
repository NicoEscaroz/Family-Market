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

  // Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'units': units,
      'category': category,
    };
  }

  // Factory constructor to create a Product from Firestore map
  factory Product.fromFirestore(Map<String, dynamic> map, String docId) {
    return Product(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      units: map['units'] ?? '',
      category: map['category'] ?? '',
    );
  }

  // Convert to generic map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'units': units,
      'category': category,
    };
  }

  // Factory constructor to create a Product from a generic map
  factory Product.fromMap(Map<String, dynamic> map, String docId) {
    return Product(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      units: map['units'] ?? '',
      category: map['category'] ?? '',
    );
  }
}
