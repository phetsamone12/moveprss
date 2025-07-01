import 'package:flutter/material.dart';
import 'track_orders_page.dart';
import 'order_history_page.dart';
import 'profile_page.dart';

class SelectVehiclePage extends StatefulWidget {
  const SelectVehiclePage({super.key});

  @override
  State<SelectVehiclePage> createState() => _SelectVehiclePageState();
}

class _SelectVehiclePageState extends State<SelectVehiclePage> {
  int _selectedIndex = 0;
  late int customerId;

  final Color primaryColor = const Color(0xFF121212);
  final Color accentColor = const Color(0xFFFFD700);
  final Color backgroundColor = const Color(0xFFF3E76A);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ModalRoute.of(context)?.settings.arguments;
    customerId = user is Map ? user['id'] ?? 0 : 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleSelect(String vehicleType) {
    final route = ['truck', 'pickup', 'van'].contains(vehicleType)
        ? '/large_vehicle_form'
        : '/small_vehicle_form';

    Navigator.pushNamed(
      context,
      route,
      arguments: {
        'vehicleType': vehicleType,
        'customerId': customerId,
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Choose Your Ride', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: primaryColor,
        centerTitle: true,
      ),
      extendBody: true,
      body: _buildBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20),
          ),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2))],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: accentColor,
          unselectedItemColor: Colors.white60,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'ເລືອກລົດ'),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'ຕິດຕາມ'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'ປະຫວັດ'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ໂປຣໄຟລ'),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildVehicleSelection();
      case 1:
        return TrackOrdersPage(customerId: customerId);
      case 2:
        return OrderHistoryPage(customerId: customerId);
      case 3:
        return ProfilePage(customerId: customerId);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildVehicleSelection() {
    final vehicles = [
      {'type': 'truck', 'label': 'Truck', 'icon': '🚚'},
      {'type': 'pickup', 'label': 'Pickup', 'icon': '🛻'},
      {'type': 'van', 'label': 'Van', 'icon': '🚐'},
      {'type': 'tricycle', 'label': 'Tricycle', 'icon': '🛺'},
      {'type': 'motorcycle', 'label': 'Motorcycle', 'icon': '🏍️'},
      {'type': 'bicycle', 'label': 'Bicycle', 'icon': '🚲'},
    ];

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            'ເລືອກລົດຫັຍງດີມື້ນີ້',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(height: 15),
          Text(
            'ກະລຸຸຸນາເລືອກລົດໃຫ້ເໝາະສົມກັບນ້ຳໜັກເຄື່ອງ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: primaryColor.withOpacity(0.7)),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 15.0, mainAxisSpacing: 15.0, childAspectRatio: 0.9,
              ),
              itemCount: vehicles.length,
              itemBuilder: (_, index) {
                final vehicle = vehicles[index];
                return _buildVehicleCard(
                  vehicle['label']!, vehicle['icon']!, vehicle['type']!, () => _handleSelect(vehicle['type']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(String label, String icon, String type, VoidCallback onTap) {
    return Card(
      color: primaryColor,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: accentColor.withOpacity(0.3),
        highlightColor: accentColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 10),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 5),
              Text(
                ['truck', 'pickup', 'van'].contains(type) ? 'Large capacity' : 'Small capacity',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}