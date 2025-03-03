import 'package:applicationstugo/Screens/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../components/EmailSent.dart';
import 'forgetPassword.dart';

class ForgetPasswordOTP extends StatefulWidget {
  static const String id = 'CustomerOTP';

  final String email;
  const ForgetPasswordOTP({
    Key? key,
    required this.email,

  }) : super(key: key);

  @override
  _ForgetPasswordOTPState createState() => _ForgetPasswordOTPState();
}

class _ForgetPasswordOTPState extends State<ForgetPasswordOTP> {
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

      if (codesMatch) {
        // Navigate to the reset password screen
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => ForgetPassword(email: widget.email),
          ),
        );
      } else {
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

          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(

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
                              'Forget Password0',
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


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 150,
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
