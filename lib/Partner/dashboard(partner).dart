import 'package:applicationstugo/Partner/completedOrders.dart';
import 'package:applicationstugo/Partner/newOrders.dart';
import 'package:applicationstugo/Partner/ongoingOrders.dart';
import 'package:applicationstugo/Partner/rejectedOrders.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/locationService.dart';

final user = FirebaseAuth.instance.currentUser;
final uid = user?.uid;

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late String global_lat;
late String global_long;
late String global_country;
late String global_adminArea;
late String global_postalcode;
late String global_adress;
late String global_district;
late String global_currentUser;

class Dashboard extends StatefulWidget {
  static const String id = 'Dashboard';

  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? lat,
      long,
      country,
      adminArea,
      postalcode,
      adress,
      district,
      currentUser;

  @override
  void initState() {
    super.initState();
    getLocation();
    loadUserData();
    updateCurrentDate();
    _fetchNewRequestsCount();
    _fetchREJECTEDRequestsCount();
    _fetchCOMPLETEDRequestsCount();
    _fetchONGOINGRequestsCount();
  }

  int _newRequestsCount = 0; // Store the number of new requests
  int _ONGOINGRequestsCount = 0; // Store the number of new requests
  int _COMPLETEDRequestsCount = 0; // Store the number of new requests
  int _REJECTEDRequestsCount = 0; // Store the number of new requests
  int _REJECTEDInitialBookingCount = 0; // Store the number of new requests
  int _totalRejectedCount = 0; // Store the number of new requests

  String? partnerEmail = user?.email;

  Future<void> _fetchNewRequestsCount() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('INITIALBOOKING')
          .where('partnerEmail', isEqualTo: partnerEmail)
          .where('partnerStatus', isEqualTo: 'NEW')
          .get();

      setState(() {
        _newRequestsCount = querySnapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching new requests count: $e');
    }
  }

  Future<void> _fetchONGOINGRequestsCount() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('INITIALBOOKING')
          .where('partnerEmail', isEqualTo: partnerEmail)
          .where('partnerStatus', isEqualTo: 'ONGOING')
          .get();

      setState(() {
        _ONGOINGRequestsCount = querySnapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching new requests count: $e');
    }
  }

  Future<void> _fetchCOMPLETEDRequestsCount() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('INITIALBOOKING')
          .where('partnerEmail', isEqualTo: partnerEmail)
          .where('partnerStatus', isEqualTo: 'COMPLETED')
          .get();

      setState(() {
        _COMPLETEDRequestsCount = querySnapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching new requests count: $e');
    }
  }

  Future<void> _fetchREJECTEDRequestsCount() async {
    try {
      QuerySnapshot rejectedQuerySnapshot = await FirebaseFirestore.instance
          .collection('REJECTEDBOOKINGS')
          .where('partnerEmail', isEqualTo: partnerEmail)
          .where('partnerStatus', isEqualTo: 'NEW')
          .get();

      QuerySnapshot rejectedInitialBookingQuerySnapshot =
          await FirebaseFirestore.instance
              .collection('INITIALBOOKING')
              .where('partnerEmail', isEqualTo: partnerEmail)
              .where('CustomerStatus', isEqualTo: 'REJECT')
              .get();

      setState(() {
        _REJECTEDRequestsCount = rejectedQuerySnapshot.docs.length;
        _REJECTEDInitialBookingCount =
            rejectedInitialBookingQuerySnapshot.docs.length;

        // Sum up the counts
        int totalCount = _REJECTEDRequestsCount + _REJECTEDInitialBookingCount;
        // Assign the total count to a state variable
        _totalRejectedCount = totalCount;
      });
    } catch (e) {
      print('Error fetching new requests count: $e');
    }
  }

  late String currentDate;
  late int _PRICE = 0;
  late String picturepartner = '';

  late String _firstName = '';
  late String _lastName = '';

  void getLocation() async {
    final service = LocationService();
    final locationData = await service.getLocation();
    if (locationData != null) {
      final placeMark = await service.getPlaceMark(locationData: locationData);
      setState(() {
        global_lat = locationData.latitude!.toStringAsFixed(2);
        global_long = locationData.longitude!.toStringAsFixed(2);
        global_country = placeMark?.country ?? ' could not get country';
        global_adminArea =
            placeMark?.administrativeArea ?? ' could not get admin area';
        global_district = placeMark?.subAdministrativeArea ?? 'no';
        global_adress = placeMark?.street ?? 'could not find street';
        global_postalcode =
            placeMark?.postalCode ?? 'could not get admin postal code ';
      });

      saveLocationDataToFirestore(uid); // Pass the UID
    }
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
            _firstName = userMap['firstName'] ?? '';
            _lastName = userMap['lastName'] ?? '';
            _PRICE = (userMap['price'] ?? 0).toInt(); // Convert double to int
            picturepartner = userMap['profileImageUrl'] ?? '';
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  void saveLocationDataToFirestore(String? uid) async {
    try {
      if (uid != null) {
        final userDocRef = _firestore.collection('TUGOPARTNERS').doc(uid);

        // Check if the document exists
        final userDocSnapshot = await userDocRef.get();

        if (userDocSnapshot.exists) {
          // Update the existing document
          await userDocRef.update({
            'latitude': global_lat,
            'longitude': global_long,
            'country': global_country,
            'adminArea': global_adminArea,
            'district': global_district,
            'address': global_adress,
            'postalCode': global_postalcode,
            'timestamp': FieldValue.serverTimestamp(),
          });

          print('Location data updated in Firestore.');
        } else {
          print('Error: Document does not exist for UID: $uid');
        }
      } else {
        print('Error: UID is null');
      }
    } catch (e) {
      print('Error saving location data: $e');
    }
  }

  void updateCurrentDate() {
    setState(() {
      // Get the current date and take only the first 9 characters
      currentDate = DateTime.now()
          .toString()
          .substring(0, 10); // Extract the first 10 characters
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    child: Image.asset(
                      'images/blck background.png',
                    ),
                    decoration: const BoxDecoration(),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$_firstName $_lastName',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Archivoblack',
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                currentDate ?? 'Loading...',
                                style: TextStyle(
                                  color: Color(0XFFBFBFBF),
                                  fontSize: 14,
                                  fontFamily: 'poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(width: 50), // Adjust the width as needed
                        // Text(
                        //   'TUGO',
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 20,
                        //     fontFamily: 'Archivoblack',
                        //   ),
                        // ),
                        // SizedBox(width: 50), // Adjust the width as needed
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      'Total Earning',
                      style: TextStyle(
                        fontFamily: 'Archivoblack',
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
                    //////////////////////// NUMBERS OF TOTAL EARNINGS

                    Text(
                      '\$ $_PRICE', // Concatenate the '$' symbol with the price
                      style: TextStyle(
                        fontFamily: 'Archivoblack',
                        fontSize: 18,
                        color: Color(0XFF007AFF),
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => New_Orders(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    width: 335,
                    height: 92,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                      border: Border.all(
                        color: const Color(0XFFF1F1F1),
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: Color(0XFF0CCE4FF),
                            ),
                            width: 60,
                            height: 60,
                            child: Center(
                              child: Text(
                                '$_newRequestsCount',
                                // Dynamically display count
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Archivoblack',
                                  color: Color(0XFF007AFF),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'You got new request${_newRequestsCount > 1 ? 's' : ''}', // Pluralize request text
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 12,
                                  color: Color(0XFF808083),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Image.asset(
                            'images/parnter nexticon.png',
                            width: 21,
                            height: 21,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 11,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Ongoing_Orders(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    width: 335,
                    height: 92,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                      border: Border.all(
                        color: const Color(0XFFF1F1F1),
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: Color(0XFFFFE9CC),
                            ),
                            width: 60,
                            height: 60,
                            child: Center(
                              //////////////////////// NUMBERS OF ONGOING
                              child: Text(
                                '$_ONGOINGRequestsCount',
                                // Dynamically display count
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Archivoblack',
                                  color: Color(0XFFFF9100),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ongoing',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Need to work on this${_ONGOINGRequestsCount > 1 ? 's' : ''}', // Pluralize request text
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 12,
                                  color: Color(0XFF808083),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Image.asset(
                            'images/parnter nexticon.png',
                            width: 21,
                            height: 21,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 11,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Completed_Orders(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    width: 335,
                    height: 92,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                      border: Border.all(
                        color: const Color(0XFFF1F1F1),
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: Color(0XFFD6EEDD),
                            ),
                            width: 60,
                            height: 60,
                            child: Center(
                              //////////////////////// NUMBERS OF Completed work
                              child: Text(
                                '$_COMPLETEDRequestsCount',
                                // Dynamically display count
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Archivoblack',
                                  color: Color(0XFF34A853),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Completed',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Your finished work${_COMPLETEDRequestsCount > 1 ? 's' : ''}', // Pluralize request text
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 12,
                                  color: Color(0XFF808083),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Image.asset(
                            'images/parnter nexticon.png',
                            width: 21,
                            height: 21,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 11,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Rejected_Orders(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    width: 335,
                    height: 92,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                      border: Border.all(
                        color: const Color(0XFFF1F1F1),
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: Color(0XFFFFCCCC),
                            ),
                            width: 60,
                            height: 60,
                            child: Center(
                              //////////////////////// NUMBERS OF Rejected work
                              child: Text(
                                '$_REJECTEDRequestsCount',
                                // Dynamically display count
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Archivoblack',
                                  color: Color(0XFFFF0000),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rejected',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Rejected by you${_REJECTEDRequestsCount > 1 ? 's' : ''}', // Pluralize request text
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 12,
                                  color: Color(0XFF808083),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Image.asset(
                            'images/parnter nexticon.png',
                            width: 21,
                            height: 21,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
