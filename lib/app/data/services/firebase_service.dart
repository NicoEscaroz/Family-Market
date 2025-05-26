import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Stream de productos comprados
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Stream de productos por comprar (wishlist)
  Stream<List<Product>> getWishlist() {
    return _db.collection('wishlist').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Agrega un producto a la colección deseada
  Future<void> addProduct(Product product, {required bool toWishlist}) async {
    final collectionName = toWishlist ? 'wishlist' : 'products';
    await _db.collection(collectionName).add(product.toFirestore());
  }

  /// Mueve todos los productos de wishlist a products
  Future<void> moveWishlistToProducts() async {
    final wishlistSnapshot = await _db.collection('wishlist').get();

    final batch = _db.batch();

    for (final doc in wishlistSnapshot.docs) {
      final data = doc.data();

      // Crear nuevo documento en 'products'
      final newDocRef = _db.collection('products').doc();
      batch.set(newDocRef, data);

      // Eliminar documento de 'wishlist'
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
