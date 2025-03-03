import 'package:flutter/material.dart';

class Booking_Blank extends StatelessWidget {
  static const String id = 'Booking_Blank';

  const Booking_Blank({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/blank_booking.png',
            width: 154,
            height: 154,
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            'No Appointment',
            style: TextStyle(
              fontFamily: 'Archivoblack',
              fontSize: 24,
            ),
          ),
          const Text(
            'Booked',
            style: TextStyle(
              fontFamily: 'Archivoblack',
              fontSize: 24,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'You have not booked any',
            style: TextStyle(
              fontFamily: 'poppins',
              fontSize: 16,
            ),
          ),
          const Text(
            'appointment yet.',
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => Home_Page(),
                //   ),
                // );
              },
              child: const Text(
                'Book Now',
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
    );
  }
}
