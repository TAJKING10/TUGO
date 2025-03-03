import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ONGOING.dart';
import 'dashboard(partner).dart';
import 'detailedNewOrder.dart';
import 'detailedOngoingOrders.dart';
import 'navigationbarPartnerSide.dart';

class Ongoing_Orders extends StatefulWidget {
  static const String id = 'Ongoing_Orders';

  const Ongoing_Orders({Key? key}) : super(key: key);

  @override
  State<Ongoing_Orders> createState() => _Ongoing_OrdersState();
}

class _Ongoing_OrdersState extends State<Ongoing_Orders> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userEmail = user?.email ?? ''; // Get user's email

    return Scaffold(
      body: Column(
        children: [
          // First column
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 35),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
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
                  'Ongoing Orders',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'ArchivoBlack',
                  ),
                ),
              ],
            ),
          ),
          // const Divider(
          //   color: Color(0XFFF1F1F1),
          //   thickness: 6,
          // ),

          // Second column
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<List<OngoingBooking>>(
                    future: fetchInitialBookings(userEmail),
                    // userEmail is the current user's email
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<OngoingBooking> initialBookings =
                            snapshot.data ?? [];
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: initialBookings.length,
                          itemBuilder: (context, index) {
                            OngoingBooking booking = initialBookings[index];
                            return Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Detailed_Ongoing_Orders(
                                        activityName: booking.activityName,
                                        price: booking.price,
                                        customerLocation:
                                            booking.customerLocation,
                                        bookingId: booking.bookingId,
                                        dateTime: booking.dateTime,
                                        firstName: booking.firstName,
                                            uid: booking.uid,
                                            googlemapsurl: booking.customerLocation, phone: booking.Customerphone, latitude: booking.latitude, longitude: booking.longitude, CUSTOMERrofileImageUrl: booking.CUSTOMERrofileImageUrl!, CUSTOMERINITIALuid: booking.CUSTOMERINITIALuid,
                                      ),
                                    ),
                                  );
                                  // Handle onTap event
                                },
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '#${booking.bookingId}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'poppins',
                                            color: Color(0XFF007AFF),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              booking.activityName,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              '\$ ${booking.price}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                color: Color(0XFF34A853),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          booking.dateTime,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            color: Color(0XFF808083),
                                          ),
                                        ),
                                        Divider(
                                          color: Color(0XFFF1F1F1),
                                          thickness: 2,
                                        ),
                                        Text(
                                          booking.firstName,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'images/loicon.png',
                                              width: 10,
                                              height: 13,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              booking.customerLocation,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                color: Color(0XFF808083),
                                              ),
                                            ),
                                            Spacer(),
                                            CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Colors.transparent,
                                              child: booking.CUSTOMERrofileImageUrl != null && booking.CUSTOMERrofileImageUrl!.isNotEmpty
                                                  ? ClipOval(
                                                child: Image.network(
                                                  booking.CUSTOMERrofileImageUrl!,
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
                                        Center(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: const Color(0XFF007AFF),
                                                // Set the border color to black
                                                width:
                                                    1, // Set the border width
                                              ),
                                            ),
                                            width: 303,
                                            height: 35,
                                            child: InkWell(
                                              onTap: () {
                                                // Update document in INITIALBOOKING collection
                                                FirebaseFirestore.instance
                                                    .collection('INITIALBOOKING')
                                                    .doc(booking.uid) // Assuming 'uid' is the document ID
                                                    .update({
                                                  'partnerStatus': 'COMPLETED'
                                                }).then((_) {
                                                  // Document updated successfully in INITIALBOOKING collection
                                                  print('Document updated successfully in INITIALBOOKING collection');

                                                  // Now, add/update the price in the TUGOPARTNERS collection
                                                  FirebaseFirestore.instance
                                                      .collection('TUGOPARTNERS')
                                                      .doc(booking.PARTNERUID) // Assuming 'PARTNERUID' is the document ID
                                                      .get()
                                                      .then((partnerDoc) {
                                                    if (partnerDoc.exists) {
                                                      // Partner document exists
                                                      final currentPrice = partnerDoc.data()?['price'] ?? 0; // Get current price or default to 0
                                                      final newPrice = currentPrice + booking.price; // Calculate new price by adding current and booking price
                                                      partnerDoc.reference.update({'price': newPrice,
                                                      })
                                                          .then((_) {
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => Navigation_Bar_Partner_Side(),
                                                          ),
                                                        );
                                                        // Price updated successfully
                                                        print('Price updated successfully in TUGOPARTNERS collection');
                                                        // You can add any additional logic here
                                                      })
                                                          .catchError((error) {
                                                        // An error occurred while updating price
                                                        print('Error updating price in TUGOPARTNERS collection: $error');
                                                      });
                                                    } else {
                                                      print('Partner document does not exist');
                                                    }
                                                  })
                                                      .catchError((error) {
                                                    // An error occurred while fetching partner document
                                                    print('Error fetching partner document: $error');
                                                  });
                                                }).catchError((error) {
                                                  // An error occurred while updating document in INITIALBOOKING collection
                                                  print('Error updating document in INITIALBOOKING collection: $error');
                                                });
                                              },

                                              child: const Center(
                                                child: Text('Request Complete',
                                                    style: TextStyle(
                                                      fontFamily: 'poppins',
                                                      fontSize: 16,
                                                      color: Color(0XFF007AFF),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
