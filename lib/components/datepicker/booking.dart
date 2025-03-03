import 'package:applicationstugo/Customer/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Customer/navigationBar.dart';
import '../../Customer/payment/paymentMethods.dart';
import '../TilmeBooking.dart';
import 'date_picker_widget.dart';
import 'package:applicationstugo/components/datepicker/date_picker_widget.dart';

class Booking_Screen extends StatefulWidget {
  static const String id = 'Booking_Screen';
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

  const Booking_Screen(
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
  State<Booking_Screen> createState() => _Booking_ScreenState();
}

class _Booking_ScreenState extends State<Booking_Screen> {
  late DateTime _selectedDate; // Change _selectedValue to _selectedDate

  late String googlePageUrl;
  String? _selectedTime; // Store selected time

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    googlePageUrl =
        'https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}'; // Initialize _selectedValue with current date
  }

  Future<void> saveDataToFirebase() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Get the current user's email
    String? userEmail = _auth.currentUser?.email;

    // Get the reference to the document in the "TUGOCUSTOMERS" collection based on the user's email
    if (userEmail != null) {
      final userDocSnapshot = await FirebaseFirestore.instance
          .collection('TUGOCUSTOMERS')
          .doc(uid)
          .get();

      // Check if the user document exists
      if (userDocSnapshot.exists) {
        // Extract user details from the document
        // String phone = userDocSnapshot.get('phone');
        // String lastName = userDocSnapshot.get('lastName');
        // String firstName = userDocSnapshot.get('firstName');
        // String email =
        //     userDocSnapshot.get('email'); // Get the email from the document ID
        // String CUSTOMERrofileImageUrl = userDocSnapshot
        //     .get('profileImageUrl'); // Get the email from the document ID

        // Now, you can save other data along with the user details
        // ...

        // // Get the reference to the document containing the maximum serial number
        // final maxSerialNumberRef = FirebaseFirestore.instance
        //     .collection('max_serial_number')
        //     .doc('max_serial_number');
        //
        // // Get the current maximum serial number
        // final maxSerialNumberDoc = await maxSerialNumberRef.get();
        // int maxSerialNumber =
        //     maxSerialNumberDoc.exists ? maxSerialNumberDoc.data()!['value'] : 0;
        //
        // // Increment the max serial number and update it in the database
        // maxSerialNumber++;
        // await maxSerialNumberRef.set({'value': maxSerialNumber});
        //
        // // Get the reference to the document containing the current ticket number
        // final currentTicketNumberRef = FirebaseFirestore.instance
        //     .collection('current_ticket_number')
        //     .doc('current_ticket_number');
        //
        // // Get the current ticket number
        // final currentTicketNumberDoc = await currentTicketNumberRef.get();
        // int currentTicketNumber = currentTicketNumberDoc.exists
        //     ? currentTicketNumberDoc.data()!['value']
        //     : 0;
        //
        // // Update the current ticket number in the database
        // currentTicketNumber++;
        // await currentTicketNumberRef.set({'value': currentTicketNumber});

        // Now, you can save other data along with the current ticket number and max serial number
        // FirebaseFirestore.instance.collection('BOOKING').add({
        //   'formattedAddress': widget.formattedAddress,
        //   'latitude': widget.latitude,
        //   'longitude': widget.longitude,
        //   'Price': widget.activityPrice,
        //
        //   // 'postalCode': postalCode,
        //   'googlePageUrl': googlePageUrl,
        //   'floor': widget.floorController,
        //   'flatNo': widget.flatNoController,
        //   'help': widget.helpController,
        //   'addressNickname': widget.addressNicknameController,
        //   'StreetName': widget.middlePartController,
        //   'district': widget.firstPart, // Save the first part as district
        //   'area': widget.PendikIstanbul, // Save PendikIstanbul as area
        //   'country': widget.lastPart, // Save the last part as country
        //   'selectedDate': _selectedDate != null
        //       ? _selectedDate.toIso8601String().split('T')[0]
        //       : null,
        //   'selectedTime': _selectedTime, // Save selected time to Firebase
        //   'ticketNumber': currentTicketNumber,
        //   'serialNumber': maxSerialNumber,
        //   'Customerphone': phone, // Save the user's phone number in the booking data
        //   'CustomerfirstName': firstName,
        //   'CustomerlastName': lastName,
        //   'Customeremail': email,
        //   'activityName': widget.activityName,
        //   'CUSTOMERrofileImageUrl': CUSTOMERrofileImageUrl
        //
        //   // 'counsdcfvbgn,try': DateTime,
        // });
        // print("Data saved to Firebase");
        if (_selectedTime == null || _selectedDate == null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Empty Time or Date'),
              content: Text('Please select both time and date.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Payment_Methods(
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
                selectedTime: _selectedTime ?? '',
                selectedDate: _selectedDate.toIso8601String(),
              ),
            ),
          );
        }

      } else {
        print('User document does not exist');
      }
    } else {
      print('User email is null');
    }
    // else {
    //   print('Error: Some data is null');
    // }
  }

  @override
  Widget build(BuildContext context) {
    int startIndex = 1; // Define and initialize the start index variable
    int numberOfAppointments =
        4; // Define the number of appointments    const Color wColor = Colors.white;
    const Color bColor = Colors.black;
    const Color wColor = Colors.white;
    const Color pColor = Colors.blue;
    const Color sdColor = Colors.black12;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 35),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  //  height: 60,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    icon: Image.asset(
                      "images/BackButton.png",
                    ),
                  ),
                ),
                // const SizedBox(
                //   width: 7,
                // ),
                const Text(
                  'Booking',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'ArchivoBlack',
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0XFFF1F1F1),
            thickness: 6,
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12.0, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.activityName}',
                      style: TextStyle(fontSize: 16, fontFamily: 'poppins'),
                    ),
                    Text(
                      'Suited for repair or replcacment ',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 12,
                        color: Color(0XFF808083),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Text(
                '\$ ${widget.activityPrice}',
                style: TextStyle(
                    fontFamily: 'poppins',
                    fontSize: 18,
                    color: Color(0XFF34A853)),
              ),
              // SizedBox(
              //   width: 12,
              // )
            ],
          ),
          const Divider(
            color: Color(0XFFF1F1F1),
            thickness: 1,
          ),
          // const SizedBox(
          //   height: 30,
          // ),
          const Padding(
            padding: EdgeInsets.only(
              left: 12.0,
            ),
            child: Text(
              'Appointment',
              style: TextStyle(fontSize: 16, fontFamily: 'poppins'),
            ),
          ),
          // const SizedBox(
          //   height: 20,
          // ),
          DatePicker(
            DateTime.now(),
            initialSelectedDate: DateTime.now(),
            selectionColor: const Color(0XFF007AFF),
            dateTextStyle:
                const TextStyle(fontSize: 24, fontFamily: 'Archivoblack'),
            onDateChange: (date) {
              // New date selected
              setState(() {
                _selectedDate = DateTime(date.year, date.month,
                    date.day); // Create a new DateTime object with time set to 00:00:00
              });
            },
          ),
          // SizedBox(
          //   height: 5,
          // ),

          // SizedBox(
          //   height: 8,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
            child: TimeBooking(
              onTimeChanged: (time) {
                // New time selected
                setState(() {
                  _selectedTime = time;
                });
              },
              selectedValue: _selectedDate,
              bColor: bColor,
              pColor: pColor,
              sdColor: sdColor,
            ),
          ),

          const Spacer(),
          Container(
            color: Colors.white, // Change the color as needed
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '\$${widget.activityPrice}',
                          style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 18,
                              color: Color(0XFF34A853)),
                        ),
                        Text(
                          '  1 item',
                          style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 12,
                              color: Color(0XFF808083)),
                        ),
                      ],
                    ),
                    Text(
                      'inc. of all taxes',
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 12,
                          color: Color(0XFF808083)),
                    ),
                  ],
                ),
                SizedBox(
                  width: 206,
                  // height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      saveDataToFirebase();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF007AFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: const Text(
                      'Proceed',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'poppins',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
