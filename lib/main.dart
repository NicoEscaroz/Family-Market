import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:family_market/app/screens/products_screen.dart';
import 'package:family_market/app/screens/wishlist_screen.dart';
import 'package:family_market/app/screens/add_product_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FamilyInventoryApp());
}

class FamilyInventoryApp extends StatefulWidget {
  const FamilyInventoryApp({super.key});

  @override
  State<FamilyInventoryApp> createState() => _FamilyInventoryAppState();
}

class _FamilyInventoryAppState extends State<FamilyInventoryApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [ProductsScreen(), WishlistScreen()];

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _navigateToAddProduct(BuildContext context) async {
    final isWishlist = _selectedIndex == 1;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddProductScreen(toWishlist: isWishlist),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Inventory',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Family Inventory')),
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
      ),
    );
  }
}
