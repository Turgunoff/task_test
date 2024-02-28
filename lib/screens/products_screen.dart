//
// @Author: "Eldor Turgunov"
// @Date: 28.02.2024
//

import 'package:flutter/material.dart';

import 'cartScreen.dart';
import '../dbHelper/products_dbhelper.dart';

class ProductsScreen extends StatefulWidget {
  final int roomNumber;

  const ProductsScreen({super.key, required this.roomNumber});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Map<String, dynamic>> _products = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _isLoading = true;

  void _refreshItems() async {
    final data = await ProductDBHelper.getItems();
    setState(() {
      _products = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshItems();
    print("..number of items: ${_products.length}");
  }

  Future<void> _addItem() async {
    await ProductDBHelper.createItem(
      _titleController.text,
      _priceController.text,
    );
    _refreshItems();
    print("..number of items: ${_products.length}");
  }

  //update item
  Future<void> _updateItem(int id) async {
    await ProductDBHelper.updateItem(
      id,
      _titleController.text,
      _priceController.text,
    );
    _refreshItems();
  }

  void _showForm(int? id) {
    if (id != null) {
      final item = _products.firstWhere((element) => element['id'] == id);
      _titleController.text = item['title'] ?? '';
      _priceController.text = item['price'].toString() ?? '';
    } else {
      _titleController.text = '';
      _priceController.text = '';
    }
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: false,
      builder: (_) => SingleChildScrollView(
        child: Container(
          height: 500,
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Name Product'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (id != null) {
                    await _updateItem(id);
                  } else {
                    await _addItem();
                  }
                  _titleController.text = '';
                  _priceController.text = '';
                  Navigator.of(context).pop();
                },
                child: Text(id != null ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text('No products found'))
              : ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final item = _products[index];
                    return ListTile(
                      title: Text(item['title']),
                      subtitle: Text(
                        '\$ ${item['price'].toString()}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(item['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              //show snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('Product deleted'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              await ProductDBHelper.deleteItem(item['id']);
                              _refreshItems();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
