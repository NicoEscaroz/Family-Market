import 'package:flutter/material.dart';
import '../data/services/firebase_service.dart';
import '../data/models/product.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

  Future<void> _confirmMoveToProducts() async {
    final shouldMove = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar'),
            content: const Text(
              '¿Deseas mover todos los productos a "comprados"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirmar'),
              ),
            ],
          ),
    );

    if (shouldMove == true) {
      setState(() => _isLoading = true);
      try {
        await _firebaseService.moveWishlistToProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Productos movidos con éxito.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de compras')),
      body: Stack(
        children: [
          StreamBuilder<List<Product>>(
            stream: _firebaseService.getWishlist(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Error al cargar la lista'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final products = snapshot.data!;
              if (products.isEmpty) {
                return const Center(
                  child: Text('No hay productos en la lista.'),
                );
              }
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Dismissible(
                    key: Key(product.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('¿Eliminar producto?'),
                              content: const Text(
                                'Esta acción no se puede deshacer.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            ),
                      );
                    },
                    onDismissed: (direction) async {
                      await _firebaseService.deleteProduct(
                        product.id,
                        fromWishlist: true,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name} eliminado.')),
                      );
                    },
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text('${product.units} - ${product.category}'),
                    ),
                  );
                },
              );
            },
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _confirmMoveToProducts,
          child: const Text('Marcar como comprados'),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'hygiene':
        return Colors.blue;
      case 'cleaning':
        return Colors.cyan;
      case 'food':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.apple;
      case 'cleaning':
        return Icons.cleaning_services;
      case 'hygiene':
        return Icons.soap;
      default:
        return Icons.shopping_bag;
    }
  }
}
