import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'navigationbarPartnerSide.dart';

class Detailed_New_Order extends StatefulWidget {
  static const String id = 'Detailed_New_Order';
  final String activityName;
  final double price;
  final String customerLocation;
  final String bookingId;
  final String dateTime;
  final String firstName;
  final String uid;
  final String googlemapsurl;
  final String phone;
  final double latitude;
  final double longitude;
  final String CUSTOMERrofileImageUrl;

  const Detailed_New_Order({Key? key, required this.activityName, required this.price, required this.customerLocation, required this.bookingId, required this.dateTime, required this.firstName, required this.uid, required this.googlemapsurl, required this.phone, required this.latitude, required this.longitude, required this.CUSTOMERrofileImageUrl}) : super(key: key);

  @override
  State<Detailed_New_Order> createState() => _Detailed_New_OrderState();
}

class _Detailed_New_OrderState extends State<Detailed_New_Order> {
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
                        widget.bookingId,
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
                      try {
                        _launchGoogleMaps("https://www.google.com/maps?q=${widget.latitude},${widget.longitude}");
                      } catch (e) {
                        print('Error launching Google Maps: $e');
                      }
                    },
                    icon: Image.asset(
                    "images/Google_maps.png",
                    width: 27,
                    height: 27,
                  ),
                  ),
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
            Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(
                            0XFFF1F1F1), // Set the border color to black
                        width: 1, // Set the border width
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
                                widget.firstName,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    color: Colors.black),
                              ),
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.transparent,
                                child: widget.CUSTOMERrofileImageUrl != null && widget.CUSTOMERrofileImageUrl!.isNotEmpty
                                    ? ClipOval(
                                  child: Image.network(
                                    widget.CUSTOMERrofileImageUrl!,
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
                          Text(
                            widget.dateTime,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              color: Color(0XFF808083),
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
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Service',
                        style:
                        TextStyle(fontFamily: 'Archivoblack', fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                            'just for you',
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
                          '\$${widget.price}',
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
                  SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Color(0XFFF1F1F1),
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
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
                child:  Column(
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
                                '\$${widget.price}',
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
                                  color: Colors.black,
                                ),
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
                              .doc(widget.uid) // Assuming 'bookingId' is the document ID
                              .update({'partnerStatus': 'REJECT'})
                              .then((_) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Navigation_Bar_Partner_Side(),
                              ),
                            );
                            // Document updated successfully
                            print('Document updated successfully');
                            // You can add any additional logic here
                          }).catchError((error) {
                            // An error occurred
                            print('Error updating document: $error');
                          });
                        },
                        child: const Center(
                          child: Text('Reject This Booking',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 16,
                                color: Color(0XFF007AFF),
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0XFF007AFF),
                      ),
                      width: 335,
                      height: 58,
                      child: InkWell(
                        onTap: () {
                          // Update document in Firestore
                          FirebaseFirestore.instance
                              .collection('INITIALBOOKING')
                              .doc(widget.uid) // Assuming 'bookingId' is the document ID
                              .update({'partnerStatus': 'ONGOING'})
                              .then((_) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Navigation_Bar_Partner_Side(),
                              ),
                            );
                            // Document updated successfully
                            print('Document updated successfully');
                            // You can add any additional logic here
                          }).catchError((error) {
                            // An error occurred
                            print('Error updating document: $error');
                          });
                        },
                        child: const Center(
                          child: Text('Accept this Booking',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 16,
                                color: Colors.white,
                              )),
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
  _launchGoogleMaps(String url) async {
    final encodedUrl = Uri.encodeFull(url); // Encode the URL
    if (await canLaunch(encodedUrl)) {
      await launch(encodedUrl);
    } else {
      throw 'Could not launch $encodedUrl';
    }
  }

}
