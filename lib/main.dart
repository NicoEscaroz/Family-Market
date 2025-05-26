import 'package:flutter/material.dart';
import 'package:family_market/app/screens/missing_products_screen.dart';
import 'package:family_market/app/screens/shopping_cart_screen.dart';
import 'package:family_market/app/data/models/product.dart';
import 'package:family_market/app/screens/add_product_screen.dart';
// import 'package:firebase_core/firebase_core.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(FamilyInventoryApp());
}

class FamilyInventoryApp extends StatefulWidget {
  @override
  State<FamilyInventoryApp> createState() => _FamilyInventoryAppState();
}

class _FamilyInventoryAppState extends State<FamilyInventoryApp> {
  int _selectedIndex = 0;

  final List<Product> _missingProducts = [];
  final List<Product> _shoppingList = [];

  void _addProduct(Product product) {
    setState(() {
      _missingProducts.add(product);
    });
  }

  void _moveShoppingToMissing() {
    setState(() {
      _missingProducts.addAll(_shoppingList);
      _shoppingList.clear();
    });
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _navigateToAddProduct(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddProductScreen()),
    );
    if (result != null && result is Product) {
      _addProduct(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      MissingProductsScreen(products: _missingProducts),
      ShoppingCartScreen(
        shoppingList: _shoppingList,
        onBuy: _moveShoppingToMissing,
      ),
    ];

    return MaterialApp(
      title: 'Family Inventory',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Family Inventory')),
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
                      icon: Icon(Icons.add),
                      label: Text('Add Product'),
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
              label: 'Missing',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Shopping List',
            ),
          ],
        ),
      ),
    );
  }
}
