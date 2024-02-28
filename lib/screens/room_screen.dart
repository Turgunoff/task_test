//
// @Author: "Eldor Turgunov"
// @Date: 28.02.2024
//

import 'package:flutter/material.dart';
import 'package:task_test/screens/order_screen.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Room'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderScreen(roomNumber: index + 1),
                      ),
                    );
                    print('Room ${index + 1} tapped');
                  },
                  child: Card(
                    elevation: 3,
                    child: Center(
                      child: Text(
                        'Room ${index + 1}',
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
