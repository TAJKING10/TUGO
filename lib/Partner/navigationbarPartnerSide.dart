import 'package:applicationstugo/Customer/Booking/detailedCompletedOrder(Customer).dart';
import 'package:applicationstugo/Customer/CustomersettingProfileScreen.dart';
import 'package:applicationstugo/Partner/detailedCompletedOrders.dart';
import 'package:applicationstugo/Partner/settingsScreen(Partner).dart';
import 'package:applicationstugo/Customer/CustomersignupScreen.dart';
import 'package:flutter/material.dart';

import 'ResetPassword.dart';
import 'dashboard(partner).dart';
import '../Screens/forgetPassword.dart';
import '../Screens/loginScreen.dart';
import 'Earnings/money.dart';

class Navigation_Bar_Partner_Side extends StatefulWidget {
  const Navigation_Bar_Partner_Side({Key? key, this.initialIndex = 0})
      : super(key: key);
  static const String id = 'Navigation_Bar_Partner_Side';
  final int initialIndex;

  @override
  State<Navigation_Bar_Partner_Side> createState() =>
      _Navigation_Bar_Partner_SideState();
}

class _Navigation_Bar_Partner_SideState
    extends State<Navigation_Bar_Partner_Side> {
  late int _index;
  final List<Widget> _screens = [
    Dashboard(),
    Bar_chart(),
    Settings_Screen_Partner(),
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
          // Use fixed type
          backgroundColor: Colors.white,
          // Set the background color to black
          currentIndex: _index,
          onTap: (int newIndex) {
            _navigateToScreen(newIndex);
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('images/dashboardiconinactive.png',
                  height: 48, width: 61),
              activeIcon: Image.asset('images/dashboardiconactive.png',
                  height: 48, width: 61),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('images/Earningsiconinactive.png',
                  height: 48, width: 61),
              activeIcon: Image.asset('images/Earningsiconactive.png',
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
