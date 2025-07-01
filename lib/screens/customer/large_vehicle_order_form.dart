import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LargeVehicleFormPage extends StatefulWidget {
  const LargeVehicleFormPage({super.key});

  @override
  State<LargeVehicleFormPage> createState() => _LargeVehicleFormPageState();
}

class _LargeVehicleFormPageState extends State<LargeVehicleFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destController = TextEditingController();

  bool _isLoading = false;
  String? _vehicleType;
  int _customerId = 0;
  String? _error;
  String? _successMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    _vehicleType = args?['vehicleType'];
    _customerId = args?['customerId'] ?? 0;
  }

  Future<void> _submitOrder() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _successMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.10.100/transport_app_project/order/create_order_large.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "customer_id": _customerId,
          "vehicle_type": _vehicleType,
          "sender_name": _nameController.text.trim(),
          "phone_number": _phoneController.text.trim(),
          "pickup_address": _pickupController.text.trim(),
          "dest_address": _destController.text.trim(),
        }),
      );

      setState(() => _isLoading = false);
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        setState(() {
          _successMessage = 'Order submitted successfully!';
          _nameController.clear();
          _phoneController.clear();
          _pickupController.clear();
          _destController.clear();
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.popUntil(context, ModalRoute.withName('/select_vehicle'));
          }
        });
      } else {
        setState(() => _error = data['message'] ?? 'Failed to submit order');
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
    _nameController.dispose();
    _phoneController.dispose();
    _pickupController.dispose();
    _destController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleLabel = _vehicleType == 'truck'
        ? 'Truck'
        : _vehicleType == 'pickup'
        ? 'Pickup'
        : _vehicleType == 'van'
        ? 'Van'
        : 'Vehicle';

    final vehicleIcon = _vehicleType == 'truck' || _vehicleType == 'pickup'
        ? Icons.local_shipping
        : _vehicleType == 'van'
        ? Icons.airport_shuttle
        : Icons.directions_car_filled;

    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Text('$vehicleLabel Delivery', style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Icon(vehicleIcon, size: 90, color: Colors.deepOrange),
              const SizedBox(height: 20),
              Text(
                'Book Your $vehicleLabel',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 15),
              Text(
                'Please provide details for your large vehicle delivery.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 40),

              _buildTextField(_nameController, 'Sender Name', 'Enter your name', Icons.person),
              const SizedBox(height: 15),
              _buildTextField(_phoneController, 'Phone Number', 'e.g., 0812345678', Icons.phone, keyboardType: TextInputType.phone),
              const SizedBox(height: 15),
              _buildTextField(_pickupController, 'Pickup Address', 'Enter pickup location', Icons.location_on),
              const SizedBox(height: 15),
              _buildTextField(_destController, 'Destination Address', 'Enter destination', Icons.flag),
              const SizedBox(height: 30),

              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              if (_successMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(_successMessage!, style: TextStyle(color: Colors.green[800])),
                ),

              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.black87))
                  : ElevatedButton(
                onPressed: _submitOrder,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.yellow,
                  elevation: 5,
                ),
                child: const Text('Submit Order', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.grey[700]),
        hintStyle: TextStyle(color: Colors.grey[500]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
      style: const TextStyle(color: Colors.black87),
    );
  }
}
