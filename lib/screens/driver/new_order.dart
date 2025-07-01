import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewOrdersPage extends StatefulWidget {
  final int driverId;
  final double currentLat;
  final double currentLng;

  const NewOrdersPage({
    super.key,
    required this.driverId,
    required this.currentLat,
    required this.currentLng,
  });

  @override
  State<NewOrdersPage> createState() => _NewOrdersPageState();
}

class _NewOrdersPageState extends State<NewOrdersPage> {
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);
    final response = await http.post(
      Uri.parse('http://localhost/driver_api/get_available_orders.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "driver_id": widget.driverId,
        "lat": widget.currentLat,
        "lng": widget.currentLng,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        orders = data['orders'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load orders')),
      );
    }
  }

  Future<void> acceptOrder(int orderId) async {
    final response = await http.post(
      Uri.parse('http://localhost/driver_api/accept_order.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "driver_id": widget.driverId,
        "order_id": orderId
      }),
    );

    final data = json.decode(response.body);
    if (data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order accepted!')),
      );
      fetchOrders();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Failed to accept order')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9C4),
      appBar: AppBar(
        title: const Text('New Orders'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? const Center(child: Text('No available orders nearby'))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white,
            child: ListTile(
              title: Text('${order['pickup_address']} \u2794 ${order['dest_address']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type: ${order['vehicle_type']}'),
                  Text('Price: ${order['estimated_price']} \$'),
                  Text('Distance to pickup: ${order['distance_to_driver'].toStringAsFixed(2)} km'),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () => acceptOrder(order['id']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text('รับงาน'),
              ),
            ),
          );
        },
      ),
    );
  }
}
