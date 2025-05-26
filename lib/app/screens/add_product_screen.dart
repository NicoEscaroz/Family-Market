import 'package:flutter/material.dart';
import 'package:family_market/app/data/models/product.dart';
import 'package:uuid/uuid.dart';
import 'package:family_market/app/data/services/firebase_service.dart';

class AddProductScreen extends StatefulWidget {
  final bool toWishlist;
  const AddProductScreen({super.key, required this.toWishlist});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _category = 'food';
  String _description = '';
  String _units = '';
  final _uuid = const Uuid();
  final List<String> _categories = ['food', 'hygiene', 'cleaning', 'others'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value!,
              ),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items:
                    _categories.map((String cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat.toUpperCase()),
                      );
                    }).toList(),
                onChanged: (value) => setState(() => _category = value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Units'),
                onSaved: (value) => _units = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState!.save();
                  final newProduct = Product(
                    id: _uuid.v4(),
                    name: _name,
                    category: _category,
                    description: _description,
                    units: _units,
                  );
                  await FirebaseService().addProduct(
                    toWishlist: widget.toWishlist,
                    newProduct,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
