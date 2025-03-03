import 'package:applicationstugo/Screens/loginScreen.dart';
import 'package:applicationstugo/Customer/CustomersignupScreen.dart';
import 'package:flutter/material.dart';

import 'choosingAccType.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'WelcomeScreen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/Fixing AC.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, left: 10),
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
                    Text(
                      'Tugo',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'ArchivoBlack'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0, left: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'All services on\nyour fingertips.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'ArchivoBlack'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 58.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 158,
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0XFF007AFF),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17))),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 158,
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .grey[500], // Set the background color to grey
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17))),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Choosing_Acc_Type(),
                            ),
                          );
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
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
