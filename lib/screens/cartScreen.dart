//
// @Author: "Eldor Turgunov"
// @Date: 28.02.2024
//

import 'package:flutter/material.dart';

import '../dbHelper/order_dbhelper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _orders = [];

  void _refreshItems() async {
    final data = await OrderDBHelper.getItems();
    setState(() {
      _orders = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _orders.isEmpty
            ? const Center(
                child: Text('The cart is empty.'),
              )
            : ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        Text('Room: ${order['roomNumber']}' ?? ''),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text('№:${order['id']}'),
                                const SizedBox(width: 10.0),
                                Text(order['orderTime'] ?? ''),
                              ],
                            ),
                            Text(
                              'Total price: \$${order['totalPrice']}',
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
