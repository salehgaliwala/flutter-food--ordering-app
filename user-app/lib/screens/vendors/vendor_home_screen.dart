import 'package:flutter/material.dart';
import 'package:foodie/screens/vendors/home_screen.dart';
import 'package:foodie/screens/vendors/vendor_order_screen.dart';
import 'package:foodie/screens/vendors/vendor_profile_screen.dart';
import 'package:foodie/screens/vendors/vendor_wallet_screen.dart';

class VendorHomeScreen extends StatefulWidget {
  final String vendorId;
  const VendorHomeScreen({super.key, required this.vendorId});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      HomeScreen(
        vendorId: widget.vendorId,
      ),
      VendorOrderScreen(
        vendorId: widget.vendorId,
      ),
      VendorWallet(
        vendorId: widget.vendorId,
      ),
      VendorProfileScreen(
        vendorId: widget.vendorId,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false,
        title: const Text("Foodie"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset("assets/Home.png"),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/food.png"),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/wallet.png"),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/user.png"),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
