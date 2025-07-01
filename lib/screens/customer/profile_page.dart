import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth/login_page.dart'; // Assuming LoginPage is in this path

/// ProfilePage Widget
/// This StatefulWidget displays the user's profile information
/// and provides a logout option.
class ProfilePage extends StatefulWidget {
  final int customerId; // Receives customer ID to fetch profile data

  const ProfilePage({Key? key, required this.customerId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

/// State class for ProfilePage
class _ProfilePageState extends State<ProfilePage> {
  // State variables to hold user profile data and UI state
  String userName = '';
  String phoneNumber = '';
  bool isLoading = true; // Controls loading indicator visibility
  bool hasError = false; // Indicates if an error occurred during data fetching

  @override
  void initState() {
    super.initState();
    fetchProfile(); // Fetch user profile data when the page initializes
  }

  /// Fetches the user's profile information from the API.
  Future<void> fetchProfile() async {
    setState(() {
      isLoading = true; // Set loading state to true
      hasError = false; // Clear any previous error state
    });

    try {
      // Construct the API URL with the customer ID
      final response = await http.get(
        Uri.parse('http://192.168.10.100/transport_app_project/user/profile_user.php?customer_id=${widget.customerId}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if the API call was successful and data is available
        if (data['success'] == true && data['orders'] != null && data['orders'].isNotEmpty) {
          final user = data['orders'][0]; // Assuming user data is in the first element of 'orders'
          setState(() {
            userName = user['name'] ?? 'Guest'; // Set user name, default to 'Guest'
            phoneNumber = user['phone_number'] ?? 'N/A'; // Set phone number, default to 'N/A'
            isLoading = false; // Set loading to false
          });
        } else {
          // If API call was successful but no user data or success is false
          setState(() {
            hasError = true; // Indicate an error
            isLoading = false; // Set loading to false
          });
        }
      } else {
        // If HTTP status code is not 200
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions during the HTTP request or JSON decoding
      setState(() {
        hasError = true; // Indicate an error
        isLoading = false; // Set loading to false
        // Optionally store the error message: errorMessage = e.toString();
      });
    }
  }

  /// Handles the logout action.
  /// It navigates the user back to the LoginPage, replacing the current route.
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // Set scaffold background to yellow
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // No shadow
        foregroundColor: Colors.black87, // Darker color for app bar title/icon
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)), // Updated title
      ),
      extendBodyBehindAppBar: true, // Body extends behind app bar
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.black87)) // Darker loading indicator
            : hasError
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.redAccent), // Error icon
              const SizedBox(height: 20),
              const Text(
                "Failed to load profile data. Please try again.", // More descriptive error
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: fetchProfile, // Retry button
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87, // Dark button background
                  foregroundColor: Colors.yellow, // Yellow text
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          children: [
            // Profile picture/initials
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.black87, // Dark background for avatar
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                style: const TextStyle(
                    fontSize: 48, color: Colors.yellow, fontWeight: FontWeight.bold), // Yellow text for initial
              ),
            ),
            const SizedBox(height: 24),
            // User Name
            Text(
              userName,
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87), // Dark text
            ),
            const SizedBox(height: 8),
            // Phone Number
            Text(
              phoneNumber,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]), // Darker grey for phone number
            ),
            const SizedBox(height: 40), // Increased spacing before button
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87, // Dark button background
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  elevation: 5, // Add shadow
                ),
                child: const Text(
                  'Logout', // Changed text to English for consistency
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.yellow, // Yellow text on button
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
