//
// @Author: "Eldor Turgunov"
// @Date: 28.02.2024
//

import 'package:flutter/material.dart';

import '../dbHelper/order_dbhelper.dart';
import '../dbHelper/products_dbhelper.dart';

class OrderScreen extends StatefulWidget {
  final int roomNumber;
  const OrderScreen({super.key, required this.roomNumber});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Map<String, dynamic>> _products = [];
  final Map<int, int> _selectedProducts = {};
  double _totalPrice = 0;
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
  }

  void _calculateTotalPrice() {
    double totalPrice = 0;
    _selectedProducts.forEach((productId, quantity) {
      final product = _products.firstWhere((item) => item['id'] == productId);
      final price = product['price'].toDouble();
      totalPrice += price * quantity;
    });
    setState(() {
      _totalPrice = totalPrice;
    });
  }

  void _showConfirmationDialog() {
    DateTime now = DateTime.now();
    String currentTime = '${now.hour}:${now.minute}';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Order'),
          content: const Text('Are you sure you want to place the order?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                OrderDBHelper.addItem(
                  _totalPrice.toInt(),
                  widget.roomNumber.toString(),
                  currentTime,
                );
                _selectedProducts.clear();
                _calculateTotalPrice();
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
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
        title: const Text('Order'),
      ),
      body: Stack(
        children: [
          Positioned(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? const Center(child: Text('No items found'))
                    : ListView.builder(
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final item = _products[index];
                          final productId = item['id'] as int;
                          final isSelected =
                              _selectedProducts.containsKey(productId);

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item['title'],
                                          style:
                                              const TextStyle(fontSize: 20.0)),
                                      Text('\$ ${item['price'].toString()}'),
                                    ],
                                  ),
                                  if (isSelected)
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            setState(() {
                                              if (_selectedProducts[
                                                      productId]! >
                                                  0) {
                                                _selectedProducts[productId] =
                                                    _selectedProducts[
                                                            productId]! -
                                                        1;
                                                _calculateTotalPrice();
                                              }
                                            });
                                          },
                                        ),
                                        Text(
                                          _selectedProducts[productId]
                                              .toString(),
                                          style:
                                              const TextStyle(fontSize: 20.0),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              _selectedProducts[productId] =
                                                  (_selectedProducts[
                                                              productId] ??
                                                          0) +
                                                      1;
                                              _calculateTotalPrice();
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  else
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          _selectedProducts[productId] = 1;
                                          _calculateTotalPrice();
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 1.0),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Total Price: \$ $_totalPrice',
                      style: const TextStyle(fontSize: 20.0),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _showConfirmationDialog();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                      ),
                      child: const Text(
                        'Check Out',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
