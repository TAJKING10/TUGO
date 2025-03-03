import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:applicationstugo/Customer/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../Customer/navigationBar.dart';
import '../../Customer/payment/paymentMethods.dart';

import 'package:applicationstugo/components/datepicker/date_picker_widget.dart';
import 'confirmPayment.dart';
import 'failedPayment.dart';

class Payment_Methods extends StatefulWidget {
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
  final String selectedTime;
  final String selectedDate;
  const Payment_Methods({Key? key, required this.activityName, required this.activityDescription, required this.activityPrice, required this.activityImage, required this.formattedAddress, required this.lastPart, required this.PendikIstanbul, required this.firstPart, required this.middlePartController, required this.addressNicknameController, required this.helpController, required this.flatNoController, required this.floorController, required this.longitude, required this.latitude, required this.selectedTime, required this.selectedDate}) : super(key: key);

  @override
  State<Payment_Methods> createState() => _Payment_MethodsState();
}

class _Payment_MethodsState extends State<Payment_Methods> {
  String?
      _selectedPaymentMethod; // Define _selectedPaymentMethod as a String variable
  late String googlePageUrl1;

  @override
  void initState() {
    super.initState();
    googlePageUrl1 =
    'https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}'; // Initialize _selectedValue with current date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.only(left: 8, top: 35),
              child: Row(children: [
                SizedBox(
                  width: 60,
                  height: 60,
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
                const SizedBox(
                  width: 7,
                ),
                const Text(
                  'Payment Method',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'ArchivoBlack',
                  ),
                ),
              ])),
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0XFFF1F1F1),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/visa.png',
                          width: 69,
                          height: 21,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        const Text(
                          'Pay with Visa',
                          style: TextStyle(fontSize: 16, fontFamily: 'poppins'),
                        ),
                        Spacer(),
                        Radio(
                          value: 'visa',
                          groupValue:
                              _selectedPaymentMethod, // Provide the currently selected value
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0XFFF1F1F1),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/gpay.png',
                          width: 69,
                          height: 21,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        const Text(
                          'Pay with Gpay',
                          style: TextStyle(fontSize: 16, fontFamily: 'poppins'),
                        ),
                        Spacer(),
                        Radio(
                          value: 'Gpay',
                          groupValue:
                              _selectedPaymentMethod, // Provide the currently selected value
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0XFFF1F1F1),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/cash.png',
                          width: 69,
                          height: 21,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        const Text(
                          'Pay with Cash',
                          style: TextStyle(fontSize: 16, fontFamily: 'poppins'),
                        ),
                        Spacer(),
                        Radio(
                          value: 'Cash',
                          groupValue:
                              _selectedPaymentMethod, // Provide the currently selected value
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // const Spacer(),
              Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white, // Change the color as needed

                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                       Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Summary',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Archivoblack',
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Subtotal',
                                  style: TextStyle(
                                      color: Color(0xff808083),
                                      fontFamily: 'poppins',
                                      fontSize: 16),
                                ),
                                Spacer(),
                                Text(
                                  '\$${widget.activityPrice}',

                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Est. Tax',
                                  style: TextStyle(
                                      color: Color(0xff808083),
                                      fontFamily: 'poppins',
                                      fontSize: 16),
                                ),
                                Spacer(),
                                Text(
                                  '\$3',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: Color(0XFFF1F1F1),
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'poppins',
                                      fontSize: 16),
                                ),
                                Spacer(),
                                Text(
                                  '\$${widget.activityPrice + 3}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Archivoblack',
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0XFF007AFF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        width: 335,
                        height: 58,
                        child: InkWell(
                          onTap: () async {
                            if (_selectedPaymentMethod == null) {
                              // Show alert dialog if no payment method is selected
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("No Payment Method Selected"),
                                    content: Text("Please select a payment method to proceed."),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              // Perform payment process
                              // For demonstration purposes, let's assume the payment is successful
                              bool saveSuccessful = await saveDataToFirebase();

                              if ( saveSuccessful) {
                                // Navigate to Confirm_Payment if payment is successful
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Confirm_Payment(),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Failed_Payment(
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
                                      // selectedTime:  widget.selectedTime,
                                      // selectedDate: widget.selectedDate,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: Center(
                            child: Text(
                              'Pay Now',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  )),
            ],
          )
        ]),
      ),
    );
  }
  //
  // Future<void> saveDataToFirebase() async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //
  //   // Get the current user's email
  //   String? userEmail = _auth.currentUser?.email;
  //
  //   // Get the reference to the document in the "TUGOCUSTOMERS" collection based on the user's email
  //   if (userEmail != null) {
  //     final userDocSnapshot = await FirebaseFirestore.instance
  //         .collection('TUGOCUSTOMERS')
  //         .doc(uid)
  //         .get();
  //
  //     // Check if the user document exists
  //     if (userDocSnapshot.exists) {
  //       // Extract user details from the document
  //       String phone = userDocSnapshot.get('phone');
  //       String lastName = userDocSnapshot.get('lastName');
  //       String firstName = userDocSnapshot.get('firstName');
  //       String email =
  //       userDocSnapshot.get('email'); // Get the email from the document ID
  //       String CUSTOMERrofileImageUrl = userDocSnapshot
  //           .get('profileImageUrl'); // Get the email from the document ID
  //
  //       // Now, you can save other data along with the user details
  //       // ...
  //
  //       // Get the reference to the document containing the maximum serial number
  //       final maxSerialNumberRef = FirebaseFirestore.instance
  //           .collection('max_serial_number')
  //           .doc('max_serial_number');
  //
  //       // Get the current maximum serial number
  //       final maxSerialNumberDoc = await maxSerialNumberRef.get();
  //       int maxSerialNumber =
  //       maxSerialNumberDoc.exists ? maxSerialNumberDoc.data()!['value'] : 0;
  //
  //       // Increment the max serial number and update it in the database
  //       maxSerialNumber++;
  //       await maxSerialNumberRef.set({'value': maxSerialNumber});
  //
  //       // Get the reference to the document containing the current ticket number
  //       final currentTicketNumberRef = FirebaseFirestore.instance
  //           .collection('current_ticket_number')
  //           .doc('current_ticket_number');
  //
  //       // Get the current ticket number
  //       final currentTicketNumberDoc = await currentTicketNumberRef.get();
  //       int currentTicketNumber = currentTicketNumberDoc.exists
  //           ? currentTicketNumberDoc.data()!['value']
  //           : 0;
  //
  //       // Update the current ticket number in the database
  //       currentTicketNumber++;
  //       await currentTicketNumberRef.set({'value': currentTicketNumber});
  //
  //       // Now, you can save other data along with the current ticket number and max serial number
  //       FirebaseFirestore.instance.collection('BOOKING').add({
  //         'formattedAddress': widget.formattedAddress,
  //         'latitude': widget.latitude,
  //         'longitude': widget.longitude,
  //         'Price': widget.activityPrice,
  //
  //         // 'postalCode': postalCode,
  //         'googlePageUrl': googlePageUrl1,
  //         'floor': widget.floorController,
  //         'flatNo': widget.flatNoController,
  //         'help': widget.helpController,
  //         'addressNickname': widget.addressNicknameController,
  //         'StreetName': widget.middlePartController,
  //         'district': widget.firstPart, // Save the first part as district
  //         'area': widget.PendikIstanbul, // Save PendikIstanbul as area
  //         'country': widget.lastPart, // Save the last part as country
  //         'selectedDate': widget.selectedDate != null
  //             ? widget.selectedDate.split('T')[0]
  //             : null,
  //         'selectedTime': widget.selectedTime, // Save selected time to Firebase
  //         'ticketNumber': currentTicketNumber,
  //         'serialNumber': maxSerialNumber,
  //         'Customerphone': phone, // Save the user's phone number in the booking data
  //         'CustomerfirstName': firstName,
  //         'CustomerlastName': lastName,
  //         'Customeremail': email,
  //         'activityName': widget.activityName,
  //         'CUSTOMERrofileImageUrl': CUSTOMERrofileImageUrl
  //
  //         // 'counsdcfvbgn,try': DateTime,
  //       });
  //       print("Data saved to Firebase");
  //       if (widget.selectedTime == null || widget.selectedDate == null) {
  //         showDialog(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //             title: Text('Empty Time or Date'),
  //             content: Text('Please select both time and date.'),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('OK'),
  //               ),
  //             ],
  //           ),
  //         );
  //       } else {
  //         // Navigator.pushReplacement(
  //         //   context,
  //         //   MaterialPageRoute(
  //         //     builder: (context) => Payment_Methods(
  //         //       activityName: widget.activityName,
  //         //       activityDescription: widget.activityDescription,
  //         //       activityPrice: widget.activityPrice,
  //         //       activityImage: widget.activityImage,
  //         //       formattedAddress: widget.formattedAddress,
  //         //       lastPart: widget.lastPart,
  //         //       PendikIstanbul: widget.PendikIstanbul,
  //         //       firstPart: widget.firstPart,
  //         //       middlePartController: widget.middlePartController,
  //         //       addressNicknameController: widget.addressNicknameController,
  //         //       helpController: widget.helpController,
  //         //       flatNoController: widget.flatNoController,
  //         //       floorController: widget.floorController,
  //         //       longitude: widget.longitude,
  //         //       latitude: widget.latitude,
  //         //       selectedTime: _selectedTime ?? '',
  //         //       selectedDate: _selectedDate.toIso8601String(),
  //         //     ),
  //         //   ),
  //         // );
  //       }
  //
  //     } else {
  //       print('User document does not exist');
  //     }
  //   } else {
  //     print('User email is null');
  //   }
  //   // else {
  //   //   print('Error: Some data is null');
  //   // }
  // }
  Future<bool> saveDataToFirebase() async {
    try {
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
          String phone = userDocSnapshot.get('phone');
          String lastName = userDocSnapshot.get('lastName');
          String firstName = userDocSnapshot.get('firstName');
          String email =
          userDocSnapshot.get('email'); // Get the email from the document ID
          String CUSTOMERrofileImageUrl = userDocSnapshot
              .get('profileImageUrl'); // Get the email from the document ID

          // Now, you can save other data along with the user details
          // ...

          // Get the reference to the document containing the maximum serial number
          final maxSerialNumberRef = FirebaseFirestore.instance
              .collection('max_serial_number')
              .doc('max_serial_number');

          // Get the current maximum serial number
          final maxSerialNumberDoc = await maxSerialNumberRef.get();
          int maxSerialNumber =
          maxSerialNumberDoc.exists ? maxSerialNumberDoc.data()!['value'] : 0;

          // Increment the max serial number and update it in the database
          maxSerialNumber++;
          await maxSerialNumberRef.set({'value': maxSerialNumber});

          // Get the reference to the document containing the current ticket number
          final currentTicketNumberRef = FirebaseFirestore.instance
              .collection('current_ticket_number')
              .doc('current_ticket_number');

          // Get the current ticket number
          final currentTicketNumberDoc = await currentTicketNumberRef.get();
          int currentTicketNumber = currentTicketNumberDoc.exists
              ? currentTicketNumberDoc.data()!['value']
              : 0;

          // Update the current ticket number in the database
          currentTicketNumber++;
          await currentTicketNumberRef.set({'value': currentTicketNumber});
          String bookingId = Uuid().v4();

          // Now, you can save other data along with the current ticket number and max serial number
          await FirebaseFirestore.instance
              .collection('BOOKING')
              .doc(bookingId) // Set the document ID to the generated UUID
              .set({
            'formattedAddress': widget.formattedAddress,
            'latitude': widget.latitude,
            'longitude': widget.longitude,
            'Price': widget.activityPrice,

            // 'postalCode': postalCode,
            'googlePageUrl': googlePageUrl1,
            'floor': widget.floorController,
            'flatNo': widget.flatNoController,
            'help': widget.helpController,
            'addressNickname': widget.addressNicknameController,
            'StreetName': widget.middlePartController,
            'district': widget.firstPart, // Save the first part as district
            'area': widget.PendikIstanbul, // Save PendikIstanbul as area
            'country': widget.lastPart, // Save the last part as country
            'selectedDate': widget.selectedDate != null
                ? widget.selectedDate.split('T')[0]
                : null,
            'selectedTime': widget.selectedTime, // Save selected time to Firebase
            'ticketNumber': currentTicketNumber,
            'serialNumber': maxSerialNumber,
            'Customerphone': phone, // Save the user's phone number in the booking data
            'CustomerfirstName': firstName,
            'CustomerlastName': lastName,
            'Customeremail': email,
            'activityName': widget.activityName,
            'CUSTOMERrofileImageUrl': CUSTOMERrofileImageUrl,
            'CUSTOMERSTATUS': 'SUBMITTED',
            'uid': bookingId,
            'CUSTOMERINITIALuid': uid,


            // 'counsdcfvbgn,try': DateTime,ZDQDZ
          });
          print("Data saved to Firebase");
          return true; // Return true indicating data saving was successful
        } else {
          print('User document does not exist');
          return false; // Return false indicating data saving failed
        }
      } else {
        print('User email is null');
        return false; // Return false indicating data saving failed
      }
    } catch (e) {
      print('Error saving data to Firebase: $e');
      return false; // Return false indicating data saving failed
    }
  }

}
