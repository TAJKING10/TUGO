import 'package:applicationstugo/Partner/Earnings/barGraph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final user = FirebaseAuth.instance.currentUser;
final uid = user?.uid;
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class Bar_chart extends StatefulWidget {
  const Bar_chart({super.key});

  @override
  State<Bar_chart> createState() => _Bar_chartState();
}

class _Bar_chartState extends State<Bar_chart> {
  List<double> weeklySummary = [
    180,
    120,
    150,
    100,
    100.20,
    118.99,
    130,
  ];
  late int _PRICE = 0;

  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;

      try {
        DocumentSnapshot userData =
            await _firestore.collection('TUGOPARTNERS').doc(uid).get();

        if (userData.exists) {
          Map<String, dynamic> userMap =
              userData.data() as Map<String, dynamic>;
          setState(() {
            _PRICE = (userMap['price'] ?? 0).toInt(); // Convert double to int
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20,),
          const Text(
            'Coming Soon!!!',
            style: TextStyle(fontFamily: 'Archivoblack', fontSize: 24),
          ),

          const Spacer(),
          Container(
            decoration: const BoxDecoration(
              color: Color(0XFF007AFF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                    height: 343,
                    child: Center(
                      child: MyBarGraph(
                        weeklySummary: weeklySummary,
                      ),
                    )),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 18.0, left: 18, right: 18),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0XFF3190F7),
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Completed',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Archivoblack',
                                    color: Colors.white),
                              ),
                              Text(
                                'Services',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Archivoblack',
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          Text(
                            '$_PRICE',
                            style: const TextStyle(
                                fontSize: 24,
                                fontFamily: 'Archivoblack',
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'View all transaction',
                          style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 13,
                              color: Colors.white),
                        ),
                        Image.asset(
                          'images/doublerightarrow.png',
                          width: 10,
                          height: 10,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
