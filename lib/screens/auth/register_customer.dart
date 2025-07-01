import 'package:flutter/material.dart';
import '../../services/api_service.dart'; // Assuming ApiService is correctly implemented in this path

/// RegisterCustomerPage Widget
/// This StatefulWidget manages the UI and logic for new customer registration.
class RegisterCustomerPage extends StatefulWidget {
  const RegisterCustomerPage({super.key});

  @override
  State<RegisterCustomerPage> createState() => _RegisterCustomerPageState();
}

/// State class for RegisterCustomerPage
class _RegisterCustomerPageState extends State<RegisterCustomerPage> {
  // Controllers for text input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variables for UI feedback
  bool _isLoading = false; // Controls the loading indicator visibility
  String? _error; // Stores error messages
  String? _successMessage; // Stores success messages

  /// Handles the customer registration process.
  /// It sets loading state, calls the API, and displays success/error messages.
  Future<void> _handleRegister() async {
    // Reset messages and set loading state
    setState(() {
      _isLoading = true;
      _error = null;
      _successMessage = null;
    });

    // Call the API service to register the customer
    final res = await ApiService.registerCustomer(
      _nameController.text.trim(),
      _phoneController.text.trim(),
      _passwordController.text,
    );

    // After API call, set loading state to false
    setState(() => _isLoading = false);

    // Process the API response
    if (res['success'] == true) {
      // On success, show a success message and navigate back to login after a short delay
      setState(() {
        _successMessage = 'Registration completed. Please log in.';
        // Clear input fields on successful registration
        _nameController.clear();
        _phoneController.clear();
        _passwordController.clear();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // Set scaffold background to yellow
      appBar: AppBar(
        title: const Text('New Customer', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87, // Darker color for app bar title/icon for contrast
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView( // Allows scrolling if content overflows
        child: Container(
          // Adjust height to cover screen or based on content
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
            children: [
              const SizedBox(height: 80), // Space for app bar
              Icon(
                Icons.person_add_alt_1_rounded, // Icon for registration
                size: 90,
                color: Colors.deepOrange, // Darker color for the main icon
              ),
              const SizedBox(height: 20),
              Text(
                'Create Your Customer Account',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Dark text on yellow background
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Fill in your details to get started with our services.',
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
                  labelStyle: TextStyle(color: Colors.grey[700]!), // Label text color
                  hintStyle: TextStyle(color: Colors.grey[500]!), // Hint text color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white, // White for input field background on yellow
                  prefixIcon: const Icon(Icons.person, color: Colors.black54), // Darker icon for contrast
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                style: const TextStyle(color: Colors.black87), // Input text color
              ),
              const SizedBox(height: 15),

              // Phone Number Text Field
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'e.g., 0812345678',
                  labelStyle: TextStyle(color: Colors.grey[700]!), // Label text color
                  hintStyle: TextStyle(color: Colors.grey[500]!), // Hint text color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white, // White for input field background on yellow
                  prefixIcon: const Icon(Icons.phone, color: Colors.black54), // Darker icon for contrast
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.black87), // Input text color
              ),
              const SizedBox(height: 15),

              // Password Text Field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Create a strong password',
                  labelStyle: TextStyle(color: Colors.grey[700]!), // Label text color
                  hintStyle: TextStyle(color: Colors.grey[500]!), // Hint text color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white, // White for input field background on yellow
                  prefixIcon: const Icon(Icons.lock, color: Colors.black54), // Darker icon for contrast
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.black87), // Input text color
              ),
              const SizedBox(height: 30),

              // Display Error/Success Messages
              if (_error != null)
                Column(
                  children: [
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red, fontSize: 14), // Red for error
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
                          ? TextStyle(color: Colors.green.shade700!, fontSize: 14) // Green for success
                          : const TextStyle(color: Colors.green, fontSize: 14), // Fallback
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),

              // Register Button or Loading Indicator
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.black87)) // Darker color for loading
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
                  'Register Account',
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
