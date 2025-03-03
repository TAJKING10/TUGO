import 'package:applicationstugo/Customer/payment/confirmPayment.dart';
import 'package:applicationstugo/Customer/payment/failedPayment.dart';
import 'package:applicationstugo/Customer/payment/paymentMethods.dart';
import 'package:applicationstugo/Customer/searchScreen.dart';
import 'package:flutter/material.dart';
import '../Partner/OTP(Partner).dart';
import '../Partner/completedOrders.dart';
import '../Partner/dashboard(partner).dart';
import '../Partner/detailedCompletedOrders.dart';
import '../Partner/detailedNewOrder.dart';
import '../Partner/detailedOngoingOrders.dart';
import '../Partner/newOrders.dart';
import '../Partner/ongoingOrders.dart';
import 'Booking/bookingBlank.dart';
import 'Booking/booking.dart';
import 'GOOGLEMAPSCUSTOMER.dart';
import 'ResetPasswordCustomer.dart';
import 'homeScreen.dart';
import 'package:applicationstugo/Customer/Settings/settingsScreen.dart';

import 'moreServicesButton.dart';

class Navigation_Bar extends StatefulWidget {
  const Navigation_Bar({Key? key, this.initialIndex = 0}) : super(key: key);
  static const String id = 'Navigation_Bar';
  final int initialIndex;

  @override
  State<Navigation_Bar> createState() => _Navigation_BarState();
}

class _Navigation_BarState extends State<Navigation_Bar> {
  late int _index;
  final List<Widget> _screens = [
    const Home_Page(),
    const Search_Screen(),
    const Booking(),
    const Settings_Screen(),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _screens[_index],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: _index,
          onTap: (int newIndex) {
            _navigateToScreen(newIndex);
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('images/home icon nav.png',
                  height: 48, width: 61),
              activeIcon: Image.asset('images/active home icon.png',
                  height: 48, width: 61),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('images/search icon nav.png',
                  height: 48, width: 61),
              activeIcon: Image.asset('images/active search icon.png',
                  height: 48, width: 61),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('images/booking icon nav.png',
                  height: 48, width: 61),
              activeIcon: Image.asset('images/active booking icon.png',
                  height: 48, width: 61),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('images/Profile icon nav.png',
                  height: 48, width: 61),
              activeIcon: Image.asset('images/active profile icon.png',
                  height: 48, width: 61),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(int newIndex) {
    setState(() {
      _index = newIndex;
    });
  }
}
