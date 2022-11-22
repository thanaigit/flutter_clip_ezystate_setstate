import 'package:flutter/material.dart';

import '../models/order.dart';
import '../widgets/circle_count.dart';
import 'order_input.dart';

final List<Order?> orders = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _orderSum;

  @override
  Widget build(BuildContext context) {
    _orderSum = Order.sumOrder(orders);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('รายการ'),
        actions: [
          CircleCount(value: _orderSum),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OrderInputPage(),
              ),
            ).then((_) => setState(() {})),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return ListTile(
            horizontalTitleGap: 0,
            leading: Text('${index + 1}.'),
            title: Text(orders[index]?.productName ?? ''),
            trailing: Text(orders[index]?.quantity?.toString() ?? ''),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderInputPage(order: orders[index]),
              ),
            ).then((_) => setState(() {})),
          );
        },
      ),
    );
  }
}
