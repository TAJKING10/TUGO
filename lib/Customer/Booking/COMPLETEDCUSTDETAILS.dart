import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:url_launcher/url_launcher.dart';

import '../navigationBar.dart';

class CUSTOMERDETAILEDCOMPLETED extends StatefulWidget {
  final String activityName;
  final double price;
  final String customerLocation;
  final String bookingId;
  final String dateTime;
  final String firstName;
  final String googlemapsurl;
  final String phone;
  final String CUSTOMERrofileImageUrl;
  final String tugopartnerId;
  final String uidinitialbooking;

  const CUSTOMERDETAILEDCOMPLETED({Key? key, required this.activityName, required this.price, required this.customerLocation, required this.bookingId, required this.dateTime, required this.firstName, required this.googlemapsurl, required this.phone, required this.CUSTOMERrofileImageUrl, required this.tugopartnerId, required this.uidinitialbooking, }) : super(key: key);

  @override
  State<CUSTOMERDETAILEDCOMPLETED> createState() =>
      _CUSTOMERDETAILEDCOMPLETEDState();
}

class _CUSTOMERDETAILEDCOMPLETEDState
    extends State<CUSTOMERDETAILEDCOMPLETED> {
  double _rating = 3.5;
  // Define a variable to hold the rating value
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 35),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${widget.bookingId}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ArchivoBlack',
                        ),
                      ),
                      Text(
                        widget.dateTime,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          color: Color(0XFF808083),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      _launchPhone(widget.phone);
                    },
                    icon: Image.asset(
                      "images/Phone.png",
                      width: 36,
                      height: 36,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Color(0XFFF1F1F1),
              thickness: 6,
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.activityName,
                            style:
                            TextStyle(fontFamily: 'poppins', fontSize: 16),
                          ),
                          Text(
                            'Just for you',
                            style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 13,
                                color: Color(0XFF808083)),
                          ),
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 18.0),
                        child: Text(
                          '\$ ${widget.price}',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              color: Color(0XFF34A853)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Color(0XFFF1F1F1),
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'Waste Pipe Leakage',
                  //           style:
                  //               TextStyle(fontFamily: 'poppins', fontSize: 16),
                  //         ),
                  //         Text(
                  //           'Suited for waste pipe leakage',
                  //           style: TextStyle(
                  //               fontFamily: 'poppins',
                  //               fontSize: 13,
                  //               color: Color(0XFF808083)),
                  //         ),
                  //       ],
                  //     ),
                  //     Spacer(),
                  //     Padding(
                  //       padding: EdgeInsets.only(right: 18.0),
                  //       child: Text(
                  //         '\$29',
                  //         style: TextStyle(
                  //             fontSize: 16,
                  //             fontFamily: 'Poppins',
                  //             color: Color(0XFF34A853)),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  const Divider(
                    color: Color(0XFFF1F1F1),
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0XFFF1F1F1),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '#${widget.bookingId}',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'poppins',
                              color: Color(0XFF007AFF),
                            ),
                          ),
                          Container(
                            width: 83,
                            height: 26,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: const Color(0XFFF5D9FF),
                            ),
                            child: const Center(
                              child: Text(
                                'Waiting',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'poppins',
                                    color: Color(0XFFBD00FF)),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.firstName,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'images/loicon.png',
                            width: 10,
                            height: 13,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.customerLocation,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              color: Color(0XFF808083),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0XFFF1F1F1),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.firstName,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0XFFFBCE50),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            '4.7',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              color: Color(0XFFFBCE50),
                            ),
                          ),
                          const Text(
                            '  192 ratings',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              color: Color(0XFF808083),
                            ),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                            Colors.transparent,
                            child: widget.CUSTOMERrofileImageUrl !=
                                null &&
                                widget
                                    .CUSTOMERrofileImageUrl!
                                    .isNotEmpty
                                ? ClipOval(
                              child:
                              Image.network(
                                widget
                                    .CUSTOMERrofileImageUrl!,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Image.asset(
                              'images/blank_img.png',
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        color: Color(0XFFF1F1F1),
                        thickness: 1,
                      ),
                      const Text(
                        'PENDING',
                        style: TextStyle(fontFamily: 'poppins', fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0XFFF1F1F1),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Rating',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'poppins',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedRatingStars(
                            initialRating:
                            _rating, // Use the variable for initial rating
                            minRating: 0.0,
                            maxRating: 5.0,
                            filledColor: Colors.amber,
                            emptyColor: Color(0XFFF1F1F1),
                            filledIcon: Icons.star,
                            halfFilledIcon: Icons.star_half,
                            emptyIcon: Icons.star,
                            onChanged: (double rating) {
                              // Handle the rating change here
                              setState(() {
                                _rating = rating; // Update the rating variable
                              });
                              print('Rating: $rating');
                            },
                            displayRatingValue: true,
                            interactiveTooltips: true,
                            customFilledIcon: Icons.star,
                            customHalfFilledIcon: Icons.star_half,
                            customEmptyIcon: Icons.star,
                            starSize: 30.0,
                            animationDuration:
                            const Duration(milliseconds: 300),
                            animationCurve: Curves.easeInOut,
                            readOnly: false,
                          ),
                          Container(
                            width: 60,
                            height: 31,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0XFFF1F1F1),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$_rating', // Display the rating in the Text widget
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'poppins'),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white, // Change the color as needed

                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Archivoblack',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                'Subtotal',
                                style: TextStyle(
                                    color: Color(0xff808083),
                                    fontFamily: 'poppins',
                                    fontSize: 16),
                              ),
                              Spacer(),
                              Text(
                                '\$ ${widget.price}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Est. Tax',
                                style: TextStyle(
                                    color: Color(0xff808083),
                                    fontFamily: 'poppins',
                                    fontSize: 16),
                              ),
                              Spacer(),
                              Text(
                                '\$3',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            color: Color(0XFFF1F1F1),
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'poppins',
                                    fontSize: 16),
                              ),
                              Spacer(),
                              Text(
                                '\$${widget.price + 3}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Archivoblack',
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(
                              0XFF007AFF), // Set the border color to black
                          width: 1, // Set the border width
                        ),
                      ),
                      width: 335,
                      height: 58,
                      child: InkWell(
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection('INITIALBOOKING')
                              .doc(widget.uidinitialbooking)
                              .update({
                            'partnerStatus': 'COMPLETED',
                            'selectedrating': _rating, // Use _rating variable here
                          }).then((_) {
                            print('Document updated successfully');
                            final FirebaseAuth _auth = FirebaseAuth.instance;
                            // Get the current user's email
                            String? uid11 = _auth.currentUser?.uid;
                            // Fetch customer document
                            FirebaseFirestore.instance.collection('TUGOPARTNERS').doc(widget.tugopartnerId).get().then((customerDoc) {
                              if (customerDoc.exists) {
                                double currentTotalRating = customerDoc.data()?['totalRating'] ?? 0;
                                double currentNumRatings = customerDoc.data()?['numRatings'] ?? 0;

                                // Calculate new total rating and number of ratings
                                double newTotalRating = currentTotalRating + _rating; // Use _rating here
                                double newNumRatings = currentNumRatings + 1;

                                // Update customer document
                                FirebaseFirestore.instance.collection('TUGOPARTNERS').doc(widget.tugopartnerId).update({
                                  'totalRating': newTotalRating,
                                  'numRatings': newNumRatings,
                                }).then((_) {
                                  print('Customer rating updated successfully');

                                  // Calculate average rating
                                  double averageRating = newTotalRating / newNumRatings;

                                  // Update average rating in Firestore
                                  FirebaseFirestore.instance.collection('TUGOPARTNERS').doc(widget.tugopartnerId).update({
                                    'averageRating': averageRating,
                                  }).then((_) {
                                    print('Average rating updated successfully');
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Navigation_Bar(initialIndex: 2,
                                        ),
                                      ),
                                    );
                                    // You can add any additional logic here
                                  }).catchError((error) {
                                    print('Error updating average rating: $error');
                                  });
                                }).catchError((error) {
                                  print('Error updating customer rating: $error');
                                });
                              } else {
                                print('Customer document not found');
                              }
                            }).catchError((error) {
                              print('Error fetching customer document: $error');
                            });
                          }).catchError((error) {
                            print('Error updating document: $error');
                          });
                        },
                        child: const Center(
                          child: Text('Rate',
                            style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 16,
                              color: Color(0XFF007AFF),
                            ),
                          ),
                        ),
                      ),

                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
  _launchPhone(String phone) async {
    final url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
