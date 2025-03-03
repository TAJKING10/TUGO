import 'package:applicationstugo/Screens/choosingAccType.dart';
import 'package:applicationstugo/Customer/CustomersignupScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Partner/navigationbarPartnerSide.dart';
import 'RETREIVAL.dart';
import 'forgetPassword.dart';
import '../Customer/navigationBar.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';

  LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;
  String? emailErrorText;
  String? passwordErrorText;

  @override
  void dispose() {
    emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    try {
      final email = emailController.text.trim();
      final password = _passwordController.text.trim();

      // Check if email or password is empty
      if (email.isEmpty || password.isEmpty) {
        setState(() {
          emailErrorText = email.isEmpty ? 'Email cannot be empty' : null;
          passwordErrorText = password.isEmpty ? 'Password cannot be empty' : null;
        });
        return; // Stop the function if fields are empty
      }

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Fetch user data from 'TUGOCUSTOMERS' collection
        DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
            .collection('TUGOCUSTOMERS')
            .doc(userCredential.user?.uid)
            .get();

        // Fetch user data from 'TUGOPARTNERS' collection
        DocumentSnapshot partnerSnapshot = await FirebaseFirestore.instance
            .collection('TUGOPARTNERS')
            .doc(userCredential.user?.uid)
            .get();

        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

        if (customerSnapshot.exists) {
          // User is a Customer
          sharedPreferences.setBool('isCustomerLoggedIn', true);
          sharedPreferences.setBool('isPartnerLoggedIn', false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Navigation_Bar(),
            ),
          );
        } else if (partnerSnapshot.exists) {
          // User is a Partner
          sharedPreferences.setBool('isCustomerLoggedIn', false);
          sharedPreferences.setBool('isPartnerLoggedIn', true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Navigation_Bar_Partner_Side(),
            ),
          );
        } else {
          // Data not found in both collections
          // You might want to handle this case or show an error message
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuthException errors
      if (e.code == 'user-not-found') {
        setState(() {
          emailErrorText = 'Email not found'; // Set error text for email field
          passwordErrorText = null; // Reset password error text
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          passwordErrorText =
              'Password is incorrect'; // Set error text for password field
          emailErrorText =
              'An error occurred. Please try again.'; // Reset email error text
        });
        // Reset other error messages (if any) to handle cases when the password was previously incorrect
        // but the user corrected it without refreshing the UI.
        // You can add other error resets here if needed.
        // setState(() {
        //   emailErrorText = null;
        // });
      } else {
        // Handle other errors or show a generic error message
        print('Login error: ${e.message}');
        setState(() {
          emailErrorText =
              'Incorrect email or password.'; // Set a generic error message
          passwordErrorText =
              'Incorrect email or password.'; // Reset password error text
        });
      }
    } catch (e) {
      // Handle login errors
      print('Login error: $e');
      setState(() {
        emailErrorText =
            'Incorrect email or password.'; // Set a generic error message
        passwordErrorText =
            'Incorrect email or password.'; // Reset password error text
      });
    }
  }

  // Create a TextEditingController
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // This prevents the screen from resizing when the keyboard appears

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
                            fontFamily: 'ArchivoBlack'),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 800,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
                  width: 1000,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Log In',
                              style: TextStyle(
                                  fontFamily: 'ArchivoBlack', fontSize: 24),
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
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'Archivoblack'),
                              controller: emailController,
                              onChanged: (_) {
                                if (emailErrorText != null &&
                                    emailController.text.isNotEmpty) {
                                  setState(() {
                                    emailErrorText = null;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: const TextStyle(
                                    fontFamily: 'poppins',
                                    color: Color(0XFFBFBFBF),
                                    fontSize: 13),
                                errorText: emailErrorText,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.white),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.white),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    emailController.clear();
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Color(0XFFBFBFBF),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 14,
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
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'Archivoblack'),
                              controller: _passwordController,
                              onChanged: (_) {
                                if (passwordErrorText != null &&
                                    _passwordController.text.isNotEmpty) {
                                  setState(() {
                                    passwordErrorText = null;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                hintStyle: const TextStyle(
                                  fontFamily: 'poppins',
                                  color: Color(0XFFBFBFBF),
                                  fontSize: 13,
                                ),
                                errorText: passwordErrorText,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.white),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.white),
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
                              ),
                              obscureText: _obscureText,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Center(
                              child: SizedBox(
                                width: 335,
                                height: 58,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                        0XFF007AFF), // Set the background color to grey
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                  ),
                                  onPressed: () {
                                    loginUser();
                                  },
                                  child: const Text(
                                    'Log In',
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
                              height: 23,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PasswordRetrievalPage(),
                                  ),
                                );
                              },
                              child: const Center(
                                child: Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'poppins',
                                    color: Color(0XFF808083),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const Choosing_Acc_Type(),
                                  ),
                                );
                              },
                              child: const Center(
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'poppins',
                                    color: Color(0XFF007AFF),
                                  ),
                                ),
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
          )
        ],
      ),
    );
  }
}
