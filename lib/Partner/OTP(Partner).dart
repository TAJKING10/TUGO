import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../components/EmailSent.dart';
import 'PartnerSettingProfileScreen.dart';

class PartnerOTP extends StatefulWidget {
  static const String id = 'CustomerOTP';
  final String phoneNumber; // The phone number entered by the user

  final String email;
  final String password;
  const PartnerOTP({
    Key? key,
    required this.email,
    required this.password,
    required this.phoneNumber,

  }) : super(key: key);

  @override
  _PartnerOTPState createState() => _PartnerOTPState();
}

class _PartnerOTPState extends State<PartnerOTP> {
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> controllers =
  List.generate(6, (index) => TextEditingController());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void moveToNext(int currentIndex) {
    if (currentIndex < 5) {
      FocusScope.of(context).requestFocus(focusNodes[currentIndex + 1]);
    }
  }

  Future<void> verifyOTP() async {
    try {
      // Combine the OTP digits from the text fields
      final enteredCode = controllers.map((controller) => controller.text).join();

      // Compare the entered code with the stored code
      bool codesMatch = await VerificationStorage().compareVerificationCode(enteredCode);
      // Print the stored code and comparison result
      print('Entered code: $enteredCode');
      // Print the stored code and comparison result
      print('Codes match: $codesMatch');

      if (codesMatch) {
        // Codes match, proceed with user creation and saving to Firestore
        String email = widget.email; // Get this from user input
        String password = widget.password; // Get this from user input

        // Create user with email and password
        UserCredential emailCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Get the user's UID
        String? uid = emailCredential.user?.uid;
        String phoneNumberWithoutCode = widget.phoneNumber.replaceAll(RegExp(r'^\+'), '');
int numRatings = 0;
        int averageRating = 5;

        // Save user data to Firestore 'TUGOCUSTOMERS' collection
        await FirebaseFirestore.instance.collection('TUGOPARTNERS').doc(uid).set({
          'email': email,
          'phoneWithoutCountryCode': phoneNumberWithoutCode,
          'phoneWithCountryCode': widget.phoneNumber,
          'uid': uid,
          'numRatings': numRatings,
          'averageRating': averageRating,

          'phone': widget.phoneNumber,
          'password': widget.password,
          'status': 'Partner',

          // Add other user data here if needed
        });

        // Navigate to the home screen or perform any other action
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>  PartnerSettingProfile(),
          ),
        );         } else {
        // Codes don't match, show an error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("The entered OTP does not match. Please check your OTP and try again."),
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
      }
    } catch (e) {
      // Handle any errors
      print('Error verifying OTP: $e');
      // Show error message to the user
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'images/Fixing AC.jpg',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 35),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/logo.png",
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Tugo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'ArchivoBlack',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  height: 700,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email Verification',
                              style: TextStyle(
                                  fontFamily: 'ArchivoBlack', fontSize: 24),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Enter your 6-digit OTP code from Tugo to ${widget.email}:',
                              style: TextStyle(
                                  color: Color(0XFF808083),
                                  fontSize: 18,
                                  fontFamily: 'poppins'),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Form(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  for (var i = 0; i < 6; i++)
                                    SizedBox(
                                      height: 68,
                                      width: 40,
                                      child: TextFormField(
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            controllers[i].text = value; // Update the controller's text
                                            if (i < 5) {
                                              FocusScope.of(context).nextFocus(); // Move focus to the next field
                                            } else {
                                              // When the last digit is entered, perform the verification
                                              verifyOTP();
                                            }
                                          } else if (i > 0) {
                                            FocusScope.of(context).previousFocus(); // Move focus to the previous field
                                          }
                                        },

                                        style: const TextStyle(fontSize: 24, fontFamily: 'ArchivoBlack'),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(1),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 335,
                                  height: 58,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0XFF007AFF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                    ),
                                    onPressed:
                                    verifyOTP, // Call the verifyOTP function
                                    child: const Text(
                                      'Confirm',
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
                          ],
                        ),
                      ),
                    ],
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
