import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/EmailSent.dart';
import 'ForgetPasswordOTP.dart';
import 'loginScreen.dart';

class ForgetPassword extends StatefulWidget {
  static const String id = 'ForgetPassword';

  final String email;
  const ForgetPassword({
    Key? key,
    required this.email,

  }) : super(key: key);
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String passwordErrorText = ''; // State variable for phone number error text
  String confirmpasswordErrorText = ''; // State variable for phone number error text
  // Method to reset password
  // Future<void> resetPassword(String newPassword) async {
  //   try {
  //     // Get current user
  //     User? user = FirebaseAuth.instance.currentUser;
  //
  //     // Update password in Firebase Authentication
  //     await user?.updatePassword(newPassword);
  //
  //     // Update password in Firestore database (TUGOPARTNERS)
  //     await FirebaseFirestore.instance
  //         .collection('TUGOPARTNERS')
  //         .doc(user?.uid)
  //         .update({'password': newPassword});
  //
  //     // Password reset successful, navigate to login screen or any other screen
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => LoginScreen()),
  //     );
  //   } catch (error) {
  //     // Handle password reset errors
  //     print("Error resetting password: $error");
  //     // You can show an error message or toast here
  //   }
  // }
  Future<void> resetPassword(String newPassword) async {
    try {
      // Get current user
      User? user = FirebaseAuth.instance.currentUser;
      String password = passwordController.text.trim();
      String confirmPassword = confirmPasswordController.text.trim();
      if (password.isEmpty) {
        setState(() {
          passwordErrorText = 'Password cannot be empty';
        });
      } else if (password.length < 8 || !password.contains(RegExp(r'[A-Z]'))) {
        setState(() {
          if (password.length < 8) {
            passwordErrorText = 'Password must be at least 8 characters';
          }
          if (!password.contains(RegExp(r'[A-Z]'))) {
            passwordErrorText = 'Password must contain at least 1 uppercase letter';
          }
        });
      }

      if (confirmPassword.isEmpty) {
        setState(() {
          confirmpasswordErrorText = 'Confirm password cannot be empty';
        });
      } else if (confirmPassword.length < 8 || !confirmPassword.contains(RegExp(r'[A-Z]'))) {
        setState(() {
          if (confirmPassword.length < 8) {
            confirmpasswordErrorText = 'Password must be at least 8 characters';
          }
          if (!confirmPassword.contains(RegExp(r'[A-Z]'))) {
            confirmpasswordErrorText = 'Password must contain at least 1 uppercase letter';
          }
        });
      }
      if (password != confirmPassword) {
        setState(() {
          passwordErrorText = 'Passwords do not match';
          confirmpasswordErrorText = 'Passwords do not match';

        });
      }

      // Determine the collection based on where the user is found
      String? collectionName;
      DocumentReference<Map<String, dynamic>>? userDocRef;

      QuerySnapshot<Map<String, dynamic>> customersSnapshot = await FirebaseFirestore.instance
          .collection('TUGOCUSTOMERS')
          .where('email', isEqualTo: user?.email)
          .limit(1)
          .get();

      if (customersSnapshot.docs.isNotEmpty) {
        collectionName = 'TUGOCUSTOMERS';
        userDocRef = FirebaseFirestore.instance.collection(collectionName).doc(user?.uid);
      } else {
        QuerySnapshot<Map<String, dynamic>> partnersSnapshot = await FirebaseFirestore.instance
            .collection('TUGOPARTNERS')
            .where('email', isEqualTo: user?.email)
            .limit(1)
            .get();

        if (partnersSnapshot.docs.isNotEmpty) {
          collectionName = 'TUGOPARTNERS';
          userDocRef = FirebaseFirestore.instance.collection(collectionName).doc(user?.uid);
        }
      }

      if (passwordErrorText.isEmpty &&
          confirmpasswordErrorText.isEmpty && collectionName != null && userDocRef != null) {
        // Update password in Firebase Authentication
        await user?.updatePassword(newPassword);

        // Update password in Firestore database
        await userDocRef.update({'password': newPassword});

        // Password reset successful, navigate to login screen or any other screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // User not found in any collection
        print('User not found in any collection.');
        // Show appropriate error message to the user
      }
    } catch (error) {
      // Handle password reset errors
      print("Error resetting password: $error");
      // You can show an error message or toast here
    }
  }

  bool _obscureText = true;

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 35),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 55,
                        height: 55,
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
                        'Forgot Password',
                        style: TextStyle(
                            color: Color(0XFFF1F1F1),
                            fontSize: 18,
                            fontFamily: 'ArchivoBlack'),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 700,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Forgot Password',
                              style: TextStyle(fontFamily: 'ArchivoBlack', fontSize: 24),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              'E-mail',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0XFF808083),
                              ),
                            ),
                            TextField(
                              readOnly: true, // Set readOnly to true to make the TextField non-editable
                              style: const TextStyle(fontSize: 18, fontFamily: 'Archivoblack'),
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: const TextStyle(fontFamily: 'poppins', color: Color(0XFFBFBFBF), fontSize: 13),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(width: 2, color: Colors.white),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(width: 2, color: Colors.white),
                                ),
                                // suffixIcon: IconButton(
                                //   onPressed: () {
                                //     emailController.clear();
                                //   },
                                //   icon: const Icon(
                                //     Icons.cancel,
                                //     color: Color(0XFFBFBFBF),
                                //   ),
                                // ),
                              ),
                              // Set the initial value to widget.email
                              // This value won't be editable due to readOnly property
                              // You can customize the style further if needed
                              controller: TextEditingController(text: widget.email),
                            ),

                            const Text(
                              'Password',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 16,
                                color: Color(0XFF808083),
                              ),
                            ),
                            TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                hintStyle: const TextStyle(
                                  fontFamily: 'poppins',
                                  color: Color(0XFFBFBFBF),
                                  fontSize: 13,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color(0XFFBFBFBF),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                                errorText: passwordErrorText.isNotEmpty ? passwordErrorText : null,

                              ),
                              obscureText: _obscureText,
                              onChanged: (value) {
                                setState(() {
                                  // Reset error text when user edits the email field
                                  passwordErrorText = '';
                                });
                              },

                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Text(
                              'Confirm Password',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 16,
                                color: Color(0XFF808083),
                              ),
                            ),
                            TextField(
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                hintStyle: const TextStyle(
                                  fontFamily: 'poppins',
                                  color: Color(0XFFBFBFBF),
                                  fontSize: 13,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color(0XFFBFBFBF),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                                errorText: confirmpasswordErrorText.isNotEmpty ? confirmpasswordErrorText : null,

                              ),
                              obscureText: _obscureText,
                              onChanged: (value) {
                                setState(() {
                                  // Reset error text when user edits the email field
                                  confirmpasswordErrorText = '';
                                });
                              },

                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Center(
                              child: SizedBox(
                                width: 335,
                                height: 58,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0XFF007AFF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                  ),
                                  onPressed: () {
                                    resetPassword(passwordController.text.trim());
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'poppins',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
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
