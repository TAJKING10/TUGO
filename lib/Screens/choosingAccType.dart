import 'package:applicationstugo/Customer/CustomersignupScreen.dart';
import 'package:flutter/material.dart';

import '../Partner/PartnerSignupScreen.dart';

class Choosing_Acc_Type extends StatefulWidget {
  static const String id = 'Choosing_Acc_Type';

  const Choosing_Acc_Type({Key? key}) : super(key: key);

  @override
  _Choosing_Acc_TypeState createState() => _Choosing_Acc_TypeState();
}

class _Choosing_Acc_TypeState extends State<Choosing_Acc_Type> {
  int? selectedContainerIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  height: 700,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 30),
                        child: Text(
                          'How are you planning to use TUGO?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Archivoblack',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              //offering a service button
                              setState(() {
                                selectedContainerIndex =
                                    selectedContainerIndex == 0 ? null : 0;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0XFFF7F6F4),
                                border: Border.all(
                                  color: selectedContainerIndex == 0
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: 180,
                              height: 200,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Image.asset(
                                        'images/offer a service.png',
                                        width: 100,
                                        height: 100,
                                      ),
                                      const Text(
                                        'Offer a service.',
                                        style: TextStyle(
                                            fontFamily: 'poppins',
                                            fontSize: 17),
                                      ),
                                      const Text(
                                        'Join Our Team, Offer Services.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'poppins',
                                          fontSize: 15,
                                          color: Color(0XFF808083),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (selectedContainerIndex == 0)
                                    const Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              //needing a service button
                              setState(() {
                                selectedContainerIndex =
                                    selectedContainerIndex == 1 ? null : 1;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0XFFF7F6F4),
                                border: Border.all(
                                  color: selectedContainerIndex == 1
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: 180,
                              height: 200,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Image.asset(
                                        'images/nned a service.png',
                                        width: 100,
                                        height: 100,
                                      ),
                                      const Text(
                                        'Need a service.',
                                        style: TextStyle(
                                            fontFamily: 'poppins',
                                            fontSize: 17),
                                      ),
                                      const Text(
                                        'Your Desires, Our Deliveries.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'poppins',
                                          fontSize: 15,
                                          color: Color(0XFF808083),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (selectedContainerIndex == 1)
                                    const Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 70,
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
                              if (selectedContainerIndex == 0) {
                                // Navigate to PartnerSignUpScreen for offering a service
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PartnerSignupScreen()),
                                );
                              } else if (selectedContainerIndex == 1) {
                                // Navigate to CustomerSignUpScreen for needing a service
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerSignupScreen()),
                                );
                              }
                            },
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                color: Colors.white,
                                fontSize: 16,
                              ),
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
    );
  }
}
