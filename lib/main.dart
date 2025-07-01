import 'package:flutter/material.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/register_customer.dart';
import 'screens/auth/register_driver.dart';
import 'screens/customer/select_vehicle.dart';
import 'screens/customer/large_vehicle_order_form.dart';
import 'screens/customer/small_vehicle_order_form.dart';

void main() {
  runApp(MaterialApp(
    home: const LoginPage(),
    routes: {
      '/register': (context) => const RegisterCustomerPage(),
      '/register_driver': (context) => const RegisterDriverPage(),
      '/select_vehicle': (context) => const SelectVehiclePage(),
      '/large_vehicle_form': (context) => const LargeVehicleFormPage(),
      '/small_vehicle_form': (context) => const SmallVehicleFormPage(),
      //'/home': (context) => const HomePage(), // หน้าถัดไป
    },
  ));
}
