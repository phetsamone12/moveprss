import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.10.100/transport_app_project/auth/"; // เปลี่ยนเป็น URL จริง

  static Future<Map<String, dynamic>> login(String phone, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "phone_number": phone,
          "password": password,
        }),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return {"success": false, "message": "Server error: ${res.statusCode}"};
      }
    } catch (e) {
      return {"success": false, "message": "Network error: $e"};
    }
  }

  static Future<Map<String, dynamic>> registerCustomer(String name, String phone, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register_customer.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"name": name, "phone_number": phone, "password": password}),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> registerDriver({
    required String name,
    required String phone,
    required String password,
    required String vehicleType,
    required String licensePlate,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register_driver.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": name,
        "phone_number": phone,
        "password": password,
        "vehicle_type": vehicleType,
        "license_plate": licensePlate
      }),
    );
    return jsonDecode(res.body);
  }
}
