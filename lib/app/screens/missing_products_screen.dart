import 'package:flutter/material.dart';
import 'package:family_market/app/data/models/product.dart';
import '../widgets/product_tile.dart';

class MissingProductsScreen extends StatefulWidget {
  final List<Product> products;

  const MissingProductsScreen({required this.products, Key? key})
    : super(key: key);

  @override
  State<MissingProductsScreen> createState() => _MissingProductsScreenState();
}

class _MissingProductsScreenState extends State<MissingProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.products.isEmpty
        ? Center(child: Text('No missing products.'))
        : ListView.builder(
          itemCount: widget.products.length,
          itemBuilder:
              (context, index) => ProductTile(product: widget.products[index]),
        );
  }
}
