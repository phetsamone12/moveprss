import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// TrackOrdersPage Widget
/// This StatefulWidget displays a list of orders for a specific customer,
/// allowing them to track the status of their deliveries.
class TrackOrdersPage extends StatefulWidget {
  final int customerId; // Receives customer id from login/previous page

  const TrackOrdersPage({super.key, required this.customerId});

  @override
  State<TrackOrdersPage> createState() => _TrackOrdersPageState();
}

/// State class for TrackOrdersPage
class _TrackOrdersPageState extends State<TrackOrdersPage> {
  List orders = []; // List to store fetched orders
  bool isLoading = true; // Controls loading indicator visibility
  String? errorMessage; // Stores error messages if fetching fails

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Fetch orders when the page initializes
  }

  /// Fetches orders from the API for the current customer.
  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true; // Set loading state to true
      errorMessage = null; // Clear any previous error messages
    });

    // Define the API URL for fetching customer orders
    final url = Uri.parse('http://192.168.10.100/transport_app_project/order/get_orders_by_customer.php'); // Replace with your actual local URL

    try {
      // Make a POST request to the API
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'customer_id': widget.customerId}), // Send customer ID in the request body
      );

      // Decode the JSON response body
      final data = jsonDecode(response.body);

      // Check if the API call was successful
      if (data['success']) {
        setState(() {
          orders = data['orders']; // Update the orders list with fetched data
        });
      } else {
        setState(() {
          errorMessage = data['message'] ?? 'Failed to load orders'; // Set error message from API
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Connection error: ${e.toString()}'; // Catch and display network/parsing errors
      });
    } finally {
      setState(() {
        isLoading = false; // Always set loading to false after operation
      });
    }
  }

  /// Determines the color for an order status.
  /// Adjusted colors for better visibility on a dark card background.
  Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.grey[400]!; // Lighter grey for visibility on black card
      case 'accepted':
        return Colors.orangeAccent; // Brighter orange
      case 'picked_up':
        return Colors.lightBlueAccent; // Brighter blue
      case 'delivered':
        return Colors.lightGreenAccent; // Brighter green
      case 'cancelled':
        return Colors.redAccent; // Brighter red
      default:
        return Colors.white; // Default white for unknown status on black card
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // Set scaffold background to yellow
      appBar: AppBar(
        title: const Text('Track Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87, // Darker color for app bar title/icon for contrast
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87), // Refresh icon
            onPressed: fetchOrders, // Call fetchOrders on refresh
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black87)) // Darker loading indicator
          : errorMessage != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
              const SizedBox(height: 20),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: fetchOrders,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      )
          : orders.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 80, color: Colors.grey[600]),
            const SizedBox(height: 20),
            Text(
              'No orders found.',
              style: TextStyle(color: Colors.grey[800], fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/select_vehicle')); // Go back to vehicle selection
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Book a New Order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(25.0, 100.0, 25.0, 25.0), // Adjust padding for app bar
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            color: Colors.black87, // Dark card background
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Rounded card corners
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order ID: ${order['id'] ?? 'N/A'}",
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "To: ${order['dest_address'] ?? 'N/A'}",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white), // White text on dark card
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "From: ${order['pickup_address'] ?? 'N/A'}",
                    style: TextStyle(color: Colors.grey[300], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status: ${order['order_status'] ?? 'N/A'}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: getStatusColor(order['order_status'] ?? ''), // Dynamic status color
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.yellow.withOpacity(0.2), // Subtle yellow background for vehicle type
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          order['vehicle_type'] ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.yellowAccent, // Yellow text for vehicle type
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (order['estimated_price'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Estimated Price: ฿${double.tryParse(order['estimated_price'].toString())?.toStringAsFixed(2) ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (order['driver_name'] != null && order['driver_name'].isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Driver: ${order['driver_name']}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  if (order['driver_phone'] != null && order['driver_phone'].isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Driver Phone: ${order['driver_phone']}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
