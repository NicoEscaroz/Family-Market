import 'package:flutter/material.dart';
import 'package:family_market/app/data/models/product.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  ProductCategory _category = ProductCategory.food;
  String _description = '';
  String _units = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value!,
              ),
              DropdownButtonFormField<ProductCategory>(
                value: _category,
                items:
                    ProductCategory.values.map((ProductCategory cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat.name.toUpperCase()),
                      );
                    }).toList(),
                onChanged: (value) => setState(() => _category = value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Units'),
                onSaved: (value) => _units = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  final newProduct = Product(
                    name: _name,
                    category: _category,
                    description: _description,
                    units: _units,
                    logo: 'assets/images/default.png', // Placeholder
                  );
                  Navigator.pop(context, newProduct);
                },
                child: Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
