import 'package:flutter/material.dart';

import '../../components/datepicker/booking.dart';
import '../homeScreen.dart';
import '../navigationBar.dart';

class Failed_Payment extends StatefulWidget {
  static const String id = 'Failed_Payment';
  final String activityName;
  final String activityDescription;
  final int activityPrice;
  final String activityImage;
  final String formattedAddress;
  final String lastPart;
  final String PendikIstanbul;
  final String firstPart;
  final String middlePartController;
  final String addressNicknameController;
  final String helpController;
  final String flatNoController;
  final String floorController;
  final double longitude;
  final double latitude;
  const Failed_Payment(
      {Key? key,
        required this.activityName,
        required this.activityDescription,
        required this.activityPrice,
        required this.activityImage,
        required this.formattedAddress,
        required this.lastPart,
        required this.PendikIstanbul,
        required this.firstPart,
        required this.middlePartController,
        required this.addressNicknameController,
        required this.helpController,
        required this.flatNoController,
        required this.floorController,
        required this.longitude,
        required this.latitude})
      : super(key: key);

  @override
  State<Failed_Payment> createState() => _Failed_PaymentState();
}

class _Failed_PaymentState extends State<Failed_Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/failedPayment.png',
              width: 176,
              height: 185,
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Oops! Something went',
              style: TextStyle(
                fontFamily: 'Archivoblack',
                fontSize: 24,
              ),
            ),
            const Text(
              'terribly wrong.',
              style: TextStyle(
                fontFamily: 'Archivoblack',
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'oh! something happen there please',
              style: TextStyle(
                fontFamily: 'poppins',
                fontSize: 16,
              ),
            ),
            const Text(
              'click on this button and retry',
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
                      builder: (context) => Booking_Screen(

                        activityName: widget.activityName,
                        activityDescription: widget.activityDescription,
                        activityPrice: widget.activityPrice,
                        activityImage: widget.activityImage,
                        formattedAddress: widget.formattedAddress,
                        lastPart: widget.lastPart,
                        PendikIstanbul: widget.PendikIstanbul,
                        firstPart: widget.firstPart,
                        middlePartController: widget.middlePartController,
                        addressNicknameController: widget.addressNicknameController,
                        helpController: widget.helpController,
                        flatNoController: widget.flatNoController,
                        floorController: widget.floorController,
                        longitude: widget.longitude,
                        latitude: widget.latitude,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Retry!',
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
