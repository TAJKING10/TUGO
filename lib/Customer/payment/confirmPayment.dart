import 'package:flutter/material.dart';

import '../homeScreen.dart';
import '../navigationBar.dart';

class Confirm_Payment extends StatelessWidget {
  static const String id = 'Confirm_Payment';

  const Confirm_Payment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/confirmPayment.png',
              width: 176,
              height: 185,
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Your Services has',
              style: TextStyle(
                fontFamily: 'Archivoblack',
                fontSize: 24,
              ),
            ),
            const Text(
              'been booked',
              style: TextStyle(
                fontFamily: 'Archivoblack',
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'TUGO team call you for booking ',
              style: TextStyle(
                fontFamily: 'poppins',
                fontSize: 16,
              ),
            ),
            const Text(
              'confirmation.',
              style: TextStyle(
                fontFamily: 'poppins',
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 199,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF007AFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Navigation_Bar(initialIndex: 2,),
                    ),
                  );
                },
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Colors.white,
                    fontSize: 16,
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
