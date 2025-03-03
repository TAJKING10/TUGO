import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Customer/navigationBar.dart';
import '../Partner/navigationbarPartnerSide.dart';
import '../components/EmailSent.dart';
import 'ForgetPasswordOTP.dart';

class PasswordRetrievalPage extends StatefulWidget {
  @override
  _PasswordRetrievalPageState createState() => _PasswordRetrievalPageState();
}

class _PasswordRetrievalPageState extends State<PasswordRetrievalPage> {
  final TextEditingController _emailController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? emailErrorText;

  Future<void> retrievePasswordAndReauthenticate() async {
    String email = _emailController.text.trim();

    // Check if email is empty
    if (email.isEmpty) {
      setState(() {
        emailErrorText = 'Email cannot be empty';
      });
      return;
    } else {
      // Reset error text if email is not empty
      setState(() {
        emailErrorText = null;
      });
    }

    try {
      // Query TUGOCUSTOMERS collection
      QuerySnapshot<Map<String, dynamic>> customersSnapshot = await _firestore
          .collection('TUGOCUSTOMERS')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      // Query TUGOPARTNERS collection if email not found in TUGOCUSTOMERS
      if (customersSnapshot.docs.isEmpty) {
        QuerySnapshot<Map<String, dynamic>> partnersSnapshot = await _firestore
            .collection('TUGOPARTNERS')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (partnersSnapshot.docs.isNotEmpty) {
          String password = partnersSnapshot.docs.first.get('password');
          User? user = _auth.currentUser;

          if (user != null) {
            // Reauthenticate the user with their current email and password
            await user.reauthenticateWithCredential(
              EmailAuthProvider.credential(email: email, password: password),
            );

            // Send reset password email
            await EmailSending().sendResetPasswordEmail(email);

            // Navigate to the ForgetPasswordOTP page with email
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ForgetPasswordOTP(
                  email: email,
                ),
              ),
            );

            // Print "User logged in" and "Password retrieved"
             print('User logged in $password !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
            // print('Password retrieved');
          } else {
            // User is not signed in
            // print('User is not signed in.');
          }
        } else {
          // No user found with the specified email in TUGOPARTNERS collection
          print('No user found with the specified email in TUGOPARTNERS collection.');
          // Show appropriate error message to the user
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Email Not Found"),
                content: Text("The email provided is not associated with any account. Please use the correct email."),
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
      } else {
        // No user found with the specified email in TUGOCUSTOMERS collection
        print('No user found with the specified email in TUGOCUSTOMERS collection.');
        // Show appropriate error message to the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Email Not Found"),
              content: Text("The email provided is not associated with any account. Please use the correct email."),
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
      // Error occurred during the query or reauthentication process
      print('Error: $e');
      // Show error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("An error occurred. Please try again later."),
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
  }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Password Retrieval Page'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: retrievePasswordAndReauthenticate,
//               child: Text('Retrieve Password and Reauthenticate'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 35),
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
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
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
                              'Forgot Password',
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
                              controller: _emailController,
                              onChanged: (_) {
                                if (emailErrorText != null &&
                                    _emailController.text.isNotEmpty) {
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
                                    _emailController.clear();
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Color(0XFFBFBFBF),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
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
                                  onPressed: retrievePasswordAndReauthenticate,
                                  child: const Text(
                                    'Continue',
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
