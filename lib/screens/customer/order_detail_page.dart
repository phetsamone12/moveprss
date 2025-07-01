import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("รายละเอียดออเดอร์")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _infoTile("ประเภทรถ", order['vehicle_type']),
            _infoTile("สถานะ", order['order_status']),
            const Divider(),
            _infoTile("จาก", order['pickup_address']),
            _infoTile("ไปยัง", order['dest_address']),
            const Divider(),
            _infoTile("ระยะทาง", "${order['distance_km']} กม."),
            if (order['item_weight_kg'] != null)
              _infoTile("น้ำหนัก", "${order['item_weight_kg']} กก."),
            if (order['estimated_price'] != null)
              _infoTile("ราคาประเมิน", "${order['estimated_price']} บาท"),
            const Divider(),
            _infoTile("เวลาสร้างออเดอร์", order['created_at'] ?? "-"),
            _infoTile("รับงานเมื่อ", order['accepted_at'] ?? "-"),
            _infoTile("รับของเมื่อ", order['picked_up_at'] ?? "-"),
            _infoTile("ส่งของเสร็จ", order['delivered_at'] ?? "-"),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text("$title:", style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
