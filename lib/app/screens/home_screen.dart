// lib/app/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:family_market/app/screens/products_screen.dart';
import 'package:family_market/app/screens/wishlist_screen.dart';
import 'package:family_market/app/screens/add_product_screen.dart';
import 'package:family_market/app/data/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  final AuthService? authService;
  const HomeScreen({super.key, this.authService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AuthService _authService2;
  int _selectedIndex = 0;
  final _authService = AuthService();

  final List<Widget> _screens = const [ProductsScreen(), WishlistScreen()];

  @override
  void initState() {
    super.initState();
    _authService2 = widget.authService ?? AuthService();
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Método para navegar a la pantalla de agregar producto
  Future<void> _navigateToAddProduct(BuildContext context) async {
    final isWishlist = _selectedIndex == 1;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddProductScreen(toWishlist: isWishlist),
      ),
    );
  }

  // Método para cerrar sesión
  Future<void> _signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cerrar sesión: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Método para mostrar el diálogo de confirmación de cierre de sesión
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _signOut();
              },
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Market'),
        actions: [
          IconButton(
            onPressed: _showLogoutDialog,
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _screens[_selectedIndex]),
          Builder(
            builder: (innerContext) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToAddProduct(innerContext),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar producto'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Comprados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Wishlist',
          ),
        ],
      ),
    );
  }
}
