import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Screens/loginScreen.dart';
import '../components/EmailSent.dart';
import 'OTP(Partner).dart';

class PartnerSignupScreen extends StatefulWidget {
  static const String id = 'SignUpScreen';

  PartnerSignupScreen({Key? key}) : super(key: key);

  @override
  _PartnerSignupScreenState createState() => _PartnerSignupScreenState();
}

class _PartnerSignupScreenState extends State<PartnerSignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String phoneNumber = ''; // State variable to store the phone number
  String emailErrorText = ''; // State variable to hold email error text
  String phoneErrorText = ''; // State variable for phone number error text
  String passwordErrorText = ''; // State variable for phone number error text
  String confirmpasswordErrorText = ''; // State variable for phone number error text

  // Update the phone number state variable when IntlPhoneField changes
  void updatePhoneNumber(String phone) {
    setState(() {
      phoneNumber = phone;
    });
  }

  bool _obscureText = true;
  Future<void> signUp() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String phone = phoneNumber; // Use the phone number from the state variable
// Reset all error texts before validation
    setState(() {
      emailErrorText = '';
      phoneErrorText = '';
    });

    if (email.isEmpty) {
      setState(() {
        emailErrorText = 'Email cannot be empty';
      });
    } else if (!EmailValidator.validate(email)) {
      setState(() {
        emailErrorText = 'Enter a valid email address';
      });
    } else {
      // No errors found
      setState(() {
        emailErrorText = ''; // Reset error text
      });
    }
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

    if (phone.isEmpty) {
      setState(() {
        phoneErrorText = 'Phone number cannot be empty';
      });
    }

    // Check if the email already exists in the Firestore collection
    try {
      // Check if the email exists in 'TUGOPARTNERS' collection
      QuerySnapshot partnersEmailQuerySnapshot = await _firestore
          .collection('TUGOPARTNERS')
          .where('email', isEqualTo: email)
          .get();

      // Check if the email exists in 'TUGOCUSTOMERS' collection
      QuerySnapshot customersEmailQuerySnapshot = await _firestore
          .collection('TUGOCUSTOMERS')
          .where('email', isEqualTo: email)
          .get();

      if (partnersEmailQuerySnapshot.docs.isNotEmpty ||
          customersEmailQuerySnapshot.docs.isNotEmpty) {
        // Email already exists in either collection
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('User Already Exists'),
              content: Text('The email is already registered.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      // Email does not exist in either collection, proceed with registration
      // ... code to create user or navigate to OTP screen
    } catch (e) {
      // Handle exceptions if needed
      print(e.toString());
      // Show an error message or handle accordingly
    }


    // Check if the phone number already exists in the Firestore collection
    try {
      // Check if the email exists in 'TUGOPARTNERS' collection
      QuerySnapshot partnersEmailQuerySnapshot = await _firestore
          .collection('TUGOPARTNERS')
          .where('phone', isEqualTo: phone)
          .get();

      // Check if the email exists in 'TUGOCUSTOMERS' collection
      QuerySnapshot customersEmailQuerySnapshot = await _firestore
          .collection('TUGOCUSTOMERS')
          .where('phone', isEqualTo: phone)
          .get();

      if (partnersEmailQuerySnapshot.docs.isNotEmpty ||
          customersEmailQuerySnapshot.docs.isNotEmpty) {
        // Email already exists in either collection
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Phone Number Already Exists'),
              content: Text('The Phone Number is already registered.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      // Email does not exist in either collection, proceed with registration
      // ... code to create user or navigate to OTP screen
    } catch (e) {
      // Handle exceptions if needed
      print(e.toString());
      // Show an error message or handle accordingly
    }

    try {
      // Check if there are no error messages for email, phone, password, and confirm password
      if (emailErrorText.isEmpty &&
          phoneErrorText.isEmpty &&
          passwordErrorText.isEmpty &&
          confirmpasswordErrorText.isEmpty) {
        await EmailSending().sendVerificationEmail(email);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PartnerOTP(
              email: email,
              password: password, phoneNumber: phone,
            ),
          ),
        );

        // _auth.verifyPhoneNumber(
        //   phoneNumber: phone,
        //   verificationCompleted: (PhoneAuthCredential credential) {},
        //   verificationFailed: (FirebaseAuthException e) {
        //     // Handle verification failure
        //     print('Phone verification failed: $e');
        //     // You can show an error message or toast here
        //   },
        //   codeSent: (String verificationId, int? resendToken) {
        //     // Code sent to the phone number
        //     // Navigate to the OTP screen with the verification ID
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => CustomerOTP(
        //           verificationId: verificationId,
        //           phoneNumber: phone,
        //           email: email, // Pass the email
        //           password: password, // Pass the password
        //         ),
        //       ),
        //     );
        //   },
        //   codeAutoRetrievalTimeout: (String verificationId) {},
        // );
      }
    } catch (e) {
      // Handle any errors here
      print(e.toString());
      // You can show an error message or toast here
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
            physics: ClampingScrollPhysics(),
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
                          horizontal: 20,
                          vertical: 30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sign up',
                              style: TextStyle(
                                fontFamily: 'ArchivoBlack',
                                fontSize: 24,
                              ),
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

                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(
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
                                  onPressed: () {
                                    emailController.clear();
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Color(0XFFBFBFBF),
                                  ),
                                ),
                                errorText: emailErrorText.isNotEmpty ? emailErrorText : null,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  // Reset error text when user edits the email field
                                  emailErrorText = '';
                                });
                              },
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Mobile Number',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0XFF808083),
                              ),
                            ),
                            IntlPhoneField(
                              decoration: InputDecoration(
                                hintText: 'Enter your Number',
                                hintStyle: TextStyle(
                                  fontFamily: 'poppins',
                                  color: Color(0XFFBFBFBF),
                                  fontSize: 13,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                errorText: phoneErrorText.isNotEmpty ? phoneErrorText : null,
                              ),
                              initialCountryCode: 'TR',
                              onChanged: (phone) {
                                setState(() {
                                  if (phone.number.isEmpty) {
                                    phoneErrorText = 'Phone number cannot be empty';
                                  } else {
                                    phoneErrorText = '';
                                    phoneNumber = phone.completeNumber;
                                  }
                                });
                              },
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
                              height: 13,
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
                              height: 12,
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
                                    signUp();
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: const Center(
                                child: Text(
                                  'Log In',
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
          ),
        ],
      ),
    );
  }
}
