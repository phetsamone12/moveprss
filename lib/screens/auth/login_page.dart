import 'package:flutter/material.dart';
import '../../services/api_service.dart'; // Assuming ApiService is correctly implemented in this path

/// LoginPage Widget
/// This StatefulWidget manages the UI and logic for the user login process.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// State class for LoginPage
class _LoginPageState extends State<LoginPage> {
  // Controllers for the phone number and password text fields
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variables to manage UI feedback
  bool _isLoading = false; // Controls the visibility of a loading indicator
  String? _error; // Stores error messages to display to the user

  /// Handles the login process when the login button is pressed.
  /// It sets loading state, calls the API, and navigates or shows errors based on the response.
  Future<void> _handleLogin() async {
    // Set loading state to true and clear any previous errors
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Call the login API service with trimmed phone number and password
    final response = await ApiService.login(
      _phoneController.text.trim(),
      _passwordController.text,
    );

    // After API call, set loading state to false
    setState(() => _isLoading = false);

    // Check if login was successful
    if (response['success'] == true) {
      final user = response['user']; // Extract user data from the response
      // Navigate to the '/select_vehicle' page upon successful login,
      // replacing the current route to prevent going back to login.
      // Pass the user object as arguments.
      Navigator.pushReplacementNamed(context, '/select_vehicle', arguments: user);
    } else {
      // If login failed, update the error message state
      setState(() => _error = response['message'] ?? 'Login failed');
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources when the widget is removed from the widget tree
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // Set scaffold background to yellow
      appBar: AppBar(
        title: const Text('Welcome Back!'), // More inviting app bar title
        elevation: 0, // Remove shadow for a flatter look
        backgroundColor: Colors.transparent, // Make app bar transparent
        foregroundColor: Colors.black87, // Darker color for app bar title/icon for contrast
      ),
      extendBodyBehindAppBar: true, // Allows body to extend behind the app bar
      body: SingleChildScrollView( // Prevents overflow on small screens or keyboard appearance
        child: Container(
          height: MediaQuery.of(context).size.height, // Ensure it takes full screen height
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0), // Consistent horizontal padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
            children: [
              // Header Section with Logo/Icon
              const SizedBox(height: 80), // Space for app bar
              Icon(
                Icons.person_pin_circle_rounded, // Example icon for branding
                size: 100,
                color: Colors.deepOrange, // Darker color for the main icon
              ),
              const SizedBox(height: 20),
              Text(
                'MOVE PRESS',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Dark text on yellow background
                ),
              ),
              const SizedBox(height: 30),

              // Text field for phone number input
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  labelStyle: TextStyle(color: Colors.grey[700]!), // Label text color
                  hintStyle: TextStyle(color: Colors.grey[500]!), // Hint text color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // More rounded corners
                    borderSide: BorderSide.none, // Remove border line initially
                  ),
                  filled: true, // Fill the background
                  fillColor: Colors.white, // White for input field background on yellow
                  prefixIcon: const Icon(Icons.phone, color: Colors.black54), // Darker icon for contrast
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.black87), // Input text color
              ),
              const SizedBox(height: 15), // Spacer
              // Text field for password input
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  labelStyle: TextStyle(color: Colors.grey[700]!), // Label text color
                  hintStyle: TextStyle(color: Colors.grey[500]!), // Hint text color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // More rounded corners
                    borderSide: BorderSide.none, // Remove border line initially
                  ),
                  filled: true,
                  fillColor: Colors.white, // White for input field background on yellow
                  prefixIcon: const Icon(Icons.lock, color: Colors.black54), // Darker icon for contrast
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                obscureText: true, // Hides the input text for security
                style: const TextStyle(color: Colors.black87), // Input text color
              ),
              const SizedBox(height: 10), // Spacer

              // Forgot Password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password navigation
                    print('Forgot Password clicked!');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black87, // Darker color for link
                  ),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Spacer

              // Display error message if present
              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 14), // Red for error
                  textAlign: TextAlign.center,
                ),
              if (_error != null)
                const SizedBox(height: 10), // Spacer after error message

              // Conditional rendering of loading indicator or login button
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.black87)) // Darker color for loading
                  : ElevatedButton(
                onPressed: _handleLogin, // Call _handleLogin when button is pressed
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55), // Slightly taller button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // More rounded corners
                  ),
                  backgroundColor: Colors.black87, // Dark background for button
                  foregroundColor: Colors.yellow, // Yellow text on button
                  elevation: 5, // Add a subtle shadow
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Larger, bolder text
                ),
              ),
              const SizedBox(height: 30), // Spacer

              // Divider with 'OR'
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade400!)), // Lighter grey for divider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.grey.shade700!, fontWeight: FontWeight.w500), // Darker grey for 'OR' text
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade400!)), // Lighter grey for divider
                ],
              ),
              const SizedBox(height: 30), // Spacer

              // Registration buttons
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Colors.black87, width: 2), // Dark border
                  foregroundColor: Colors.black87, // Dark text color
                ),
                child: const Text(
                  "Register as Customer",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15), // Spacer
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register_driver');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Colors.deepOrange, width: 2), // Deep orange border
                  foregroundColor: Colors.deepOrange, // Deep orange text color
                ),
                child: const Text(
                  "Register as Driver",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
