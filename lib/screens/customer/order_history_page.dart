import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderHistoryPage extends StatefulWidget {
  final int customerId;

  const OrderHistoryPage({super.key, required this.customerId});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late Future<List<Map<String, dynamic>>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _futureOrders = fetchOrderHistory(widget.customerId);
  }

  Future<List<Map<String, dynamic>>> fetchOrderHistory(int customerId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.10.100/transport_app_project/order/get_order_history.php?customer_id=$customerId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        return List<Map<String, dynamic>>.from(data['orders']);
      } else {
        throw Exception('Failed to load order history');
      }
    } else {
      throw Exception('Failed to connect to API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9C4),
      appBar: AppBar(
        title: const Text('ประวัติการใช้งาน'),
        backgroundColor: const Color(0xFFFFF9C4),
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ไม่พบประวัติการใช้งาน'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.black,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  title: Text(
                    '${order['vehicle_type']} - ${order['order_status']}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('จาก: ${order['pickup_address']}', style: const TextStyle(color: Colors.white70)),
                      Text('ถึง: ${order['dest_address']}', style: const TextStyle(color: Colors.white70)),
                      Text('ราคา: ฿${order['estimated_price']} (${order['distance_km']} กม.)', style: const TextStyle(color: Colors.amberAccent)),
                      Text('วันที่: ${order['created_at']}', style: const TextStyle(color: Colors.white38)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
