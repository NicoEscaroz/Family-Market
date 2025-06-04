import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirebaseService {
  final FirebaseFirestore _db;

  // Constructor que permite dependency injection para testing
  FirebaseService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  /// Todos los productos
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Todos los productos (wishlist)
  Stream<List<Product>> getWishlist() {
    return _db.collection('wishlist').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Agrega un producto
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

  /// Elimina un producto
  Future<void> deleteProduct(String id, {required bool fromWishlist}) async {
    final collectionName = fromWishlist ? 'wishlist' : 'products';
    await _db.collection(collectionName).doc(id).delete();
  }
}
