import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SmallVehicleFormPage extends StatefulWidget {
  const SmallVehicleFormPage({super.key});

  @override
  State<SmallVehicleFormPage> createState() => _SmallVehicleFormPageState();
}

class _SmallVehicleFormPageState extends State<SmallVehicleFormPage> {
  final _pickupController = TextEditingController();
  final _destController = TextEditingController();
  final _weightController = TextEditingController();

  String? _vehicleType;
  int _customerId = 0;

  bool _isLoading = false;
  String? _error;
  String? _successMessage;
  double? _estimatedPrice;

  final Color backgroundColor = const Color(0xFFF3E76A);
  final Color primaryColor = const Color(0xFF121212);
  final Color accentColor = const Color(0xFFFFD700);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    _vehicleType = args?['vehicleType'];
    _customerId = args?['customerId'] ?? 0;
  }

  Future<void> _submitOrder() async {
    final pickup = _pickupController.text.trim();
    final dest = _destController.text.trim();
    final weight = double.tryParse(_weightController.text);

    if (pickup.isEmpty || dest.isEmpty || weight == null || weight <= 0) {
      setState(() => _error = 'Please fill all fields correctly.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _successMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.10.100/transport_app_project/order/create_order_small.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'customer_id': _customerId,
          'vehicle_type': _vehicleType,
          'pickup_address': pickup,
          'dest_address': dest,
          'item_weight_kg': weight,
        }),
      );

      final data = jsonDecode(response.body);
      setState(() => _isLoading = false);

      if (data['success'] == true) {
        _estimatedPrice = (data['estimated_price'] ?? 0).toDouble();
        _successMessage = 'Order submitted! Estimated Price: ฿${_estimatedPrice!.toStringAsFixed(2)}';

        _pickupController.clear();
        _destController.clear();
        _weightController.clear();

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) Navigator.popUntil(context, ModalRoute.withName('/select_vehicle'));
        });
      } else {
        setState(() => _error = data['message'] ?? 'Order submission failed.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelIcon = _getVehicleLabelAndIcon(_vehicleType);
    final label = labelIcon['label'] ?? 'Vehicle';
    final icon = labelIcon['icon'] ?? Icons.local_shipping;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('$label Delivery', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primaryColor,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Icon(icon, size: 90, color: primaryColor),
            const SizedBox(height: 20),
            Text('Book Your $label Delivery',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
                textAlign: TextAlign.center),
            const SizedBox(height: 15),
            Text('Please enter delivery details',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                textAlign: TextAlign.center),
            const SizedBox(height: 30),

            _buildTextField(_pickupController, 'Pickup Address', Icons.location_on),
            const SizedBox(height: 15),
            _buildTextField(_destController, 'Destination Address', Icons.flag),
            const SizedBox(height: 15),
            _buildTextField(_weightController, 'Item Weight (kg)', Icons.fitness_center,
                keyboardType: TextInputType.number),

            const SizedBox(height: 20),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
            if (_successMessage != null)
              Text(_successMessage!,
                  style: TextStyle(color: Colors.green[800]), textAlign: TextAlign.center),
            const SizedBox(height: 15),

            // Submit Order Button or Loading Indicator
            _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.black87))
                : ElevatedButton(
              onPressed: _submitOrder,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.black87, // Dark background for button
                foregroundColor: Colors.yellow, // Yellow text on button
                elevation: 5,
              ),
              child: const Text(
                'Submit Order',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        labelStyle: TextStyle(color: Colors.grey[700]),
      ),
      style: const TextStyle(color: Colors.black87),
    );
  }

  Map<String, dynamic> _getVehicleLabelAndIcon(String? type) {
    switch (type) {
      case 'motorcycle':
        return {'label': 'Motorcycle', 'icon': Icons.motorcycle};
      case 'tricycle':
        return {'label': 'Tricycle', 'icon': Icons.pedal_bike};
      case 'bicycle':
        return {'label': 'Bicycle', 'icon': Icons.directions_bike};
      default:
        return {'label': 'Vehicle', 'icon': Icons.local_shipping};
    }
  }
}
