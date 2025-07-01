import 'package:flutter/material.dart';
import '../../services/api_service.dart'; // Assuming ApiService is correctly implemented in this path

/// RegisterDriverPage Widget
/// This StatefulWidget manages the UI and logic for new driver registration.
class RegisterDriverPage extends StatefulWidget {
  const RegisterDriverPage({super.key});

  @override
  State<RegisterDriverPage> createState() => _RegisterDriverPageState();
}

/// State class for RegisterDriverPage
class _RegisterDriverPageState extends State<RegisterDriverPage> {
  // Controllers for text input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _licensePlateController = TextEditingController();

  // State variables for dropdown and UI feedback
  String _selectedVehicle = 'truck'; // Default selected vehicle
  bool _isLoading = false; // Controls loading indicator visibility
  String? _error; // Stores error messages
  String? _successMessage; // Stores success messages

  /// Handles the driver registration process.
  /// It sets loading state, calls the API, and displays success/error messages.
  Future<void> _handleRegister() async {
    // Reset messages and set loading state
    setState(() {
      _isLoading = true;
      _error = null;
      _successMessage = null;
    });

    // Call the API service to register the driver
    final res = await ApiService.registerDriver(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      vehicleType: _selectedVehicle,
      licensePlate: _licensePlateController.text.trim(),
    );

    // After API call, set loading state to false
    setState(() => _isLoading = false);

    // Process the API response
    if (res['success'] == true) {
      // On success, show a success message and navigate back to login after a short delay
      setState(() {
        _successMessage = 'Driver registration complete. Please login.';
        // Clear input fields on successful registration
        _nameController.clear();
        _phoneController.clear();
        _passwordController.clear();
        _licensePlateController.clear();
        _selectedVehicle = 'truck'; // Reset dropdown
      });

      // Navigate back to the login page after displaying success for a brief moment
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) { // Check if the widget is still in the widget tree
          Navigator.pop(context); // Go back to login page
        }
      });
    } else {
      // On failure, display the error message
      setState(() => _error = res['message'] ?? 'Registration failed');
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _licensePlateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List of vehicle types for the dropdown
    final List<Map<String, String>> vehicleOptions = [
      {'value': 'truck', 'label': '🚚 Truck'},
      {'value': 'pickup', 'label': '🛻 Pickup'},
      {'value': 'van', 'label': '🚐 Van'}, // Added van option
      {'value': 'tricycle', 'label': '🛺 Tricycle'},
      {'value': 'motorcycle', 'label': '🏍️ Motorcycle'},
      {'value': 'bicycle', 'label': '🚲 Bicycle'}, // Added bicycle option
    ];

    return Scaffold(
      backgroundColor: Colors.yellow, // Set scaffold background to yellow
      appBar: AppBar(
        title: const Text('New Driver', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87, // Darker color for app bar title/icon for contrast
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView( // Allows scrolling if content overflows
        child: Container(
          height: MediaQuery.of(context).size.height, // Adjust height to cover screen or based on content
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
            children: [
              const SizedBox(height: 80), // Space for app bar
              Icon(
                Icons.person_pin_circle_rounded, // Icon for driver registration
                size: 90,
                color: Colors.deepOrange, // Darker color for the main icon
              ),
              const SizedBox(height: 20),
              Text(
                'Register as a Driver',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Dark text on yellow background
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Join our team and start earning!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700], // Darker grey for descriptive text
                ),
              ),
              const SizedBox(height: 40),

              // Full Name Text Field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  labelStyle: TextStyle(color: Colors.grey[700]!),
                  hintStyle: TextStyle(color: Colors.grey[500]!),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person, color: Colors.black54),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 15),

              // Phone Number Text Field
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'e.g., 0812345678',
                  labelStyle: TextStyle(color: Colors.grey[700]!),
                  hintStyle: TextStyle(color: Colors.grey[500]!),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.phone, color: Colors.black54),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 15),

              // Password Text Field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Create a strong password',
                  labelStyle: TextStyle(color: Colors.grey[700]!),
                  hintStyle: TextStyle(color: Colors.grey[500]!),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 15),

              // Vehicle Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedVehicle,
                items: vehicleOptions.map((option) {
                  return DropdownMenuItem(
                    value: option['value'],
                    child: Text(
                      option['label']!,
                      style: const TextStyle(color: Colors.black87), // Text color for dropdown items
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedVehicle = value!),
                decoration: InputDecoration(
                  labelText: 'Vehicle Type',
                  labelStyle: TextStyle(color: Colors.grey[700]!),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.drive_eta, color: Colors.black54), // Vehicle icon
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                dropdownColor: Colors.yellow, // Dropdown menu background
                style: const TextStyle(color: Colors.black87), // Selected value text style
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black54), // Dropdown arrow color
              ),
              const SizedBox(height: 15),

              // License Plate Text Field
              TextField(
                controller: _licensePlateController,
                decoration: InputDecoration(
                  labelText: 'License Plate',
                  hintText: 'e.g., ABC-1234',
                  labelStyle: TextStyle(color: Colors.grey[700]!),
                  hintStyle: TextStyle(color: Colors.grey[500]!),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.credit_card, color: Colors.black54), // License plate icon
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 30),

              // Display Error/Success Messages
              if (_error != null)
                Column(
                  children: [
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              if (_successMessage != null)
                Column(
                  children: [
                    Text(
                      _successMessage!,
                      style: Colors.green.shade700 != null
                          ? TextStyle(color: Colors.green.shade700!, fontSize: 14)
                          : const TextStyle(color: Colors.green, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),

              // Register Button or Loading Indicator
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.black87))
                  : ElevatedButton(
                onPressed: _handleRegister,
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
                  'Register Driver',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 50), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
