import 'package:flutter/material.dart';
import 'package:family_market/app/data/models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage(product.logo)),
      title: Text(product.name),
      subtitle: Text(
        '${product.description} • ${product.units} • ${product.category.name}',
      ),
    );
  }
}
