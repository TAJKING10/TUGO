import 'package:applicationstugo/Customer/Booking/ONgoing.dart';
import 'package:applicationstugo/Customer/Booking/initialBooking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Partner/detailedCompletedOrders.dart';
import '../../Partner/detailedRejectedOrders.dart';
import 'COMPLETEDCUSTDETAILS.dart';
import 'CUSTOMERREJECT.dart';
import 'Completed.dart';
import '../navigationBar.dart';
import 'DETAILSREJECTEDCUST.dart';
import 'PartnerReject.dart';
import 'Submitted.dart';

import 'bookingBlank.dart';
import 'detailedAcceptedOrder.dart';
import 'detailedCompletedOrder(Customer).dart';
import 'detailssubmitted.dart';

class Booking extends StatefulWidget {
  static const String id = 'Booking';

  const Booking({Key? key}) : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

User? user = FirebaseAuth.instance.currentUser;
String userEmail = user?.email ?? ''; // Get user's email

class _BookingState extends State<Booking> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userEmail = user?.email ?? ''; // Get user's email

    // Return a FutureBuilder to handle the asynchronous call
    return FutureBuilder<bool>(
      future: _allListsEmpty(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          bool allListsEmpty =
              snapshot.data ?? true; // Get the result from the snapshot
          // Return the appropriate widget based on the condition
          return allListsEmpty ? Booking_Blank() : _buildScaffold();
        }
      },
    );
  }

  Widget _buildScaffold() {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              // give the tab bar a height [can change hheight to preferred height]
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0XFFF1F1F1),
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ),
                    color: const Color(0XFFFBCE50),
                  ),
                  indicatorPadding: EdgeInsets.symmetric(horizontal: -40.0),
                  // Adjust this value to make the indicator wider

                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  labelStyle:
                      const TextStyle(fontSize: 16, fontFamily: 'poppins'),
                  tabs: const [
                    // first tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Active',
                    ),
                    // second tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Completed',
                    ),
                    Tab(
                      text: 'Rejected',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // first tab bar view widget
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          FutureBuilder<List<InitialBooking>>(
                            future: fetchInitialBookings(userEmail),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.white,
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                List<InitialBooking> initialBookings =
                                    snapshot.data ?? [];
                                return FutureBuilder<List<OngoingBooking>>(
                                  future: fetchOngoingBookings(userEmail),
                                  builder: (context, snapshotSubmitted) {
                                    if (snapshotSubmitted.connectionState ==
                                            ConnectionState.waiting ||
                                        snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ));
                                    } else if (snapshotSubmitted.hasError ||
                                        snapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              'Error: ${snapshot.error ?? snapshotSubmitted.error}'));
                                    } else {
                                      List<OngoingBooking> submittedBookings =
                                          snapshotSubmitted.data ?? [];
                                      return FutureBuilder<
                                          List<SubmittedBooking>>(
                                        future:
                                            fetchSubmittedBooking(userEmail),
                                        builder: (context, snapshotOngoing) {
                                          if (snapshotOngoing.connectionState ==
                                                  ConnectionState.waiting ||
                                              snapshot.connectionState ==
                                                  ConnectionState.waiting ||
                                              snapshotSubmitted
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Colors.white,
                                            ));
                                          } else if (snapshotOngoing.hasError ||
                                              snapshot.hasError ||
                                              snapshotSubmitted.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error ?? snapshotSubmitted.error ?? snapshotOngoing.error}'));
                                          } else {
                                            List<SubmittedBooking>
                                                ongoingOrders =
                                                snapshotOngoing.data ?? [];
                                            if (initialBookings.isEmpty &&
                                                submittedBookings.isEmpty &&
                                                ongoingOrders.isEmpty) {
                                              return Container();
                                            } else {
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    initialBookings.length,
                                                itemBuilder: (context, index) {
                                                  InitialBooking booking =
                                                      initialBookings[index];
                                                  return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Detailed_Accepted_Orders(
                                                                activityName:
                                                                    booking
                                                                        .activityName,
                                                                price: booking
                                                                    .price,
                                                                customerLocation:
                                                                    booking
                                                                        .customerLocation,
                                                                bookingId: booking
                                                                    .bookingId,
                                                                dateTime: booking
                                                                    .dateTime,
                                                                firstName: booking
                                                                    .firstName,
                                                                googlemapsurl:
                                                                    booking
                                                                        .customerLocation,
                                                                phone: booking
                                                                    .Customerphone,
                                                                CUSTOMERrofileImageUrl:
                                                                    booking
                                                                        .CUSTOMERrofileImageUrl!,
                                                                uid:
                                                                    booking.uid,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  '#${booking.bookingId}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        'poppins',
                                                                    color: Color(
                                                                        0XFF007AFF),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 83,
                                                                  height: 26,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                    color: const Color(
                                                                        0XFFD9EBFF),
                                                                  ),
                                                                  child:
                                                                      const Center(
                                                                    child: Text(
                                                                      'Accepted',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontFamily:
                                                                              'poppins',
                                                                          color:
                                                                              Color(0XFF007AFF)),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  booking
                                                                      .activityName,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '\$ ${booking.price}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: Color(
                                                                        0XFF34A853),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              '${booking.dateTime}',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color(
                                                                    0XFF808083),
                                                              ),
                                                            ),
                                                            const Divider(
                                                              color: Color(
                                                                  0XFFF1F1F1),
                                                              thickness: 2,
                                                            ),
                                                            Text(
                                                              '${booking.firstName}',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.star,
                                                                  color: Color(
                                                                      0XFFFBCE50),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  ' ${booking.averageRating}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: Color(
                                                                        0XFFFBCE50),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '  ${booking.numRatings.toStringAsFixed(0)} ratings',
                                                                  // Convert double to string with 0 decimal places
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: Color(
                                                                        0XFF808083),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                CircleAvatar(
                                                                  radius: 18,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  child: booking.CUSTOMERrofileImageUrl !=
                                                                              null &&
                                                                          booking
                                                                              .CUSTOMERrofileImageUrl!
                                                                              .isNotEmpty
                                                                      ? ClipOval(
                                                                          child:
                                                                              Image.network(
                                                                            booking.CUSTOMERrofileImageUrl!,
                                                                            width:
                                                                                36,
                                                                            height:
                                                                                36,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        )
                                                                      : Image
                                                                          .asset(
                                                                          'images/blank_img.png',
                                                                          width:
                                                                              36,
                                                                          height:
                                                                              36,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                },
                                              );
                                            }
                                          }
                                        },
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FutureBuilder<List<SubmittedBooking>>(
                            future: fetchSubmittedBooking(userEmail),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.white,
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                List<SubmittedBooking> initialBookings =
                                    snapshot.data ?? [];
                                return FutureBuilder<List<OngoingBooking>>(
                                  future: fetchOngoingBookings(userEmail),
                                  builder: (context, snapshotSubmitted) {
                                    if (snapshotSubmitted.connectionState ==
                                            ConnectionState.waiting ||
                                        snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ));
                                    } else if (snapshotSubmitted.hasError ||
                                        snapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              'Error: ${snapshot.error ?? snapshotSubmitted.error}'));
                                    } else {
                                      List<OngoingBooking> submittedBookings =
                                          snapshotSubmitted.data ?? [];
                                      return FutureBuilder<
                                          List<InitialBooking>>(
                                        future: fetchInitialBookings(userEmail),
                                        builder: (context, snapshotOngoing) {
                                          if (snapshotOngoing.connectionState ==
                                                  ConnectionState.waiting ||
                                              snapshot.connectionState ==
                                                  ConnectionState.waiting ||
                                              snapshotSubmitted
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Colors.white,
                                            ));
                                          } else if (snapshotOngoing.hasError ||
                                              snapshot.hasError ||
                                              snapshotSubmitted.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error ?? snapshotSubmitted.error ?? snapshotOngoing.error}'));
                                          } else {
                                            List<InitialBooking> ongoingOrders =
                                                snapshotOngoing.data ?? [];
                                            if (initialBookings.isEmpty &&
                                                submittedBookings.isEmpty &&
                                                ongoingOrders.isEmpty) {
                                              return Container();
                                            } else {
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    initialBookings.length,
                                                itemBuilder: (context, index) {
                                                  SubmittedBooking booking =
                                                      initialBookings[index];
                                                  return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      DetailedSUB(
                                                                activityName:
                                                                    booking
                                                                        .activityName,
                                                                price: booking
                                                                    .price,
                                                                customerLocation:
                                                                    booking
                                                                        .customerLocation,
                                                                bookingId: booking
                                                                    .bookingId,
                                                                dateTime: booking
                                                                    .dateTime,
                                                                firstName: booking
                                                                    .firstName,
                                                                googlemapsurl:
                                                                    booking
                                                                        .customerLocation,
                                                                uid:
                                                                    booking.uid,
                                                                // phone: booking.Customerphone,
                                                                // CUSTOMERrofileImageUrl: booking
                                                                //     .CUSTOMERrofileImageUrl!,
                                                                // uid: booking.uid,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  '#${booking.bookingId}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        'poppins',
                                                                    color: Color(
                                                                        0XFF007AFF),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 83,
                                                                  height: 26,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                    color: const Color(
                                                                        0XFFE1F2E5),
                                                                  ),
                                                                  child:
                                                                      const Center(
                                                                    child: Text(
                                                                      'Submitted',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontFamily:
                                                                              'poppins',
                                                                          color:
                                                                              Color(0XFF34A853)),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  booking
                                                                      .activityName,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '\$ ${booking.price}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: Color(
                                                                        0XFF34A853),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              booking.dateTime,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color(
                                                                    0XFF808083),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Center(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .red,
                                                                    width: 1,
                                                                  ),
                                                                ),
                                                                width: 303,
                                                                height: 35,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'BOOKING')
                                                                        .doc(booking
                                                                            .uid) // Assuming 'bookingId' is the document ID
                                                                        .update({
                                                                      'CUSTOMERSTATUS':
                                                                          'NEW'
                                                                    }).then(
                                                                            (_) {
                                                                      // Document updated successfully
                                                                      print(
                                                                          'Document updated successfully');
                                                                      // You can add any additional logic here
                                                                    }).catchError(
                                                                            (error) {
                                                                      // An error occurred
                                                                      print(
                                                                          'Error updating document: $error');
                                                                    });
                                                                  },
                                                                  child:
                                                                      const Center(
                                                                    child: Text(
                                                                      'Cancel Booking',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'poppins',
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                },
                                              );
                                            }
                                          }
                                        },
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FutureBuilder<List<OngoingBooking>>(
                            future: fetchOngoingBookings(userEmail),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.white,
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                List<OngoingBooking> initialBookings =
                                    snapshot.data ?? [];
                                return FutureBuilder<List<SubmittedBooking>>(
                                  future: fetchSubmittedBooking(userEmail),
                                  builder: (context, snapshotSubmitted) {
                                    if (snapshotSubmitted.connectionState ==
                                            ConnectionState.waiting ||
                                        snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ));
                                    } else if (snapshotSubmitted.hasError ||
                                        snapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              'Error: ${snapshot.error ?? snapshotSubmitted.error}'));
                                    } else {
                                      List<SubmittedBooking> submittedBookings =
                                          snapshotSubmitted.data ?? [];
                                      return FutureBuilder<
                                          List<InitialBooking>>(
                                        future: fetchInitialBookings(userEmail),
                                        builder: (context, snapshotOngoing) {
                                          if (snapshotOngoing.connectionState ==
                                                  ConnectionState.waiting ||
                                              snapshot.connectionState ==
                                                  ConnectionState.waiting ||
                                              snapshotSubmitted
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Colors.white,
                                            ));
                                          } else if (snapshotOngoing.hasError ||
                                              snapshot.hasError ||
                                              snapshotSubmitted.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error ?? snapshotSubmitted.error ?? snapshotOngoing.error}'));
                                          } else {
                                            List<InitialBooking> ongoingOrders =
                                                snapshotOngoing.data ?? [];
                                            if (initialBookings.isEmpty &&
                                                submittedBookings.isEmpty &&
                                                ongoingOrders.isEmpty) {
                                              return Booking_Blank();
                                            } else {
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    initialBookings.length,
                                                itemBuilder: (context, index) {
                                                  OngoingBooking booking =
                                                      initialBookings[index];
                                                  return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Detailed_Completed_Order_Customer(
                                                                activityName:
                                                                    booking
                                                                        .activityName,
                                                                price: booking
                                                                    .price,
                                                                customerLocation:
                                                                    booking
                                                                        .customerLocation,
                                                                bookingId: booking
                                                                    .bookingId,
                                                                dateTime: booking
                                                                    .dateTime,
                                                                firstName: booking
                                                                    .firstName,
                                                                googlemapsurl:
                                                                    booking
                                                                        .customerLocation,
                                                                phone: booking
                                                                    .Customerphone,
                                                                CUSTOMERrofileImageUrl:
                                                                    booking
                                                                        .CUSTOMERrofileImageUrl!,
                                                                uid:
                                                                    booking.uid,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  '#${booking.bookingId}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        'poppins',
                                                                    color: Color(
                                                                        0XFF007AFF),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 83,
                                                                  height: 26,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                    color: const Color(
                                                                        0XFFFFEFD9),
                                                                  ),
                                                                  child:
                                                                      const Center(
                                                                    child: Text(
                                                                      'Ongoing',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontFamily:
                                                                              'poppins',
                                                                          color:
                                                                              Color(0XFFFF9100)),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  booking
                                                                      .activityName,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '\$ ${booking.price}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: Color(
                                                                        0XFF34A853),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              booking.dateTime,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color(
                                                                    0XFF808083),
                                                              ),
                                                            ),
                                                            const Divider(
                                                              color: Color(
                                                                  0XFFF1F1F1),
                                                              thickness: 2,
                                                            ),
                                                            Text(
                                                              booking.firstName,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.star,
                                                                  color: Color(
                                                                      0XFFFBCE50),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  ' ${booking.averageRating}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: Color(
                                                                        0XFFFBCE50),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '  ${booking.numRatings.toStringAsFixed(0)} ratings',
                                                                  // Convert double to string with 0 decimal places
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: Color(
                                                                        0XFF808083),
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                CircleAvatar(
                                                                  radius: 18,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  child: booking.CUSTOMERrofileImageUrl !=
                                                                              null &&
                                                                          booking
                                                                              .CUSTOMERrofileImageUrl!
                                                                              .isNotEmpty
                                                                      ? ClipOval(
                                                                          child:
                                                                              Image.network(
                                                                            booking.CUSTOMERrofileImageUrl!,
                                                                            width:
                                                                                36,
                                                                            height:
                                                                                36,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        )
                                                                      : Image
                                                                          .asset(
                                                                          'images/blank_img.png',
                                                                          width:
                                                                              36,
                                                                          height:
                                                                              36,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                },
                                              );
                                            }
                                          }
                                        },
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // second tab bar view widget
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          FutureBuilder<List<CompletedBooking>>(
                            future: fetchCompletedBooking(userEmail),
                            // userEmail is the current user's email
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.white,
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                List<CompletedBooking> initialBookings =
                                    snapshot.data ?? [];
                                if (initialBookings.isEmpty) {
                                  // Show Booking_Blank if the list is empty
                                  return Booking_Blank();
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: initialBookings.length,
                                    itemBuilder: (context, index) {
                                      CompletedBooking booking =
                                          initialBookings[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CUSTOMERDETAILEDCOMPLETED(
                                                  activityName:
                                                      booking.activityName,
                                                  price: booking.price,
                                                  customerLocation:
                                                      booking.customerLocation,
                                                  bookingId: booking.bookingId,
                                                  dateTime: booking.dateTime,
                                                  firstName: booking.firstName,
                                                  googlemapsurl:
                                                      booking.customerLocation,
                                                  phone: booking.Customerphone,
                                                  CUSTOMERrofileImageUrl: booking
                                                      .CUSTOMERrofileImageUrl!,
                                                  tugopartnerId:
                                                      booking.tugopartnerId,
                                                  uidinitialbooking:
                                                      booking.uidinitialbooking,
                                                ),
                                              ),
                                            );
                                            // Handle onTap event
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: const Color(0XFFF1F1F1),
                                                width: 1,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
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
                                                        MainAxisAlignment
                                                            .spaceBetween,
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
                                                          color:
                                                              Color(0XFF34A853),
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
                                                        booking
                                                            .customerLocation,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: 'Poppins',
                                                          color:
                                                              Color(0XFF808083),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      CircleAvatar(
                                                        radius: 18,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: booking.CUSTOMERrofileImageUrl !=
                                                                    null &&
                                                                booking
                                                                    .CUSTOMERrofileImageUrl!
                                                                    .isNotEmpty
                                                            ? ClipOval(
                                                                child: Image
                                                                    .network(
                                                                  booking
                                                                      .CUSTOMERrofileImageUrl!,
                                                                  width: 36,
                                                                  height: 36,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              )
                                                            : Image.asset(
                                                                'images/blank_img.png',
                                                                width: 36,
                                                                height: 36,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      ),
                                                    ],
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
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          FutureBuilder<List<CustomerRejectBooking>>(
                            future: fetchCustomerRejectBooking(userEmail),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.white,
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                List<CustomerRejectBooking> initialBookings =
                                    snapshot.data ?? [];
                                return FutureBuilder<
                                    List<PartnerRejectBooking>>(
                                  future: fetchPartnerRejectBooking(userEmail),
                                  builder: (context, snapshotSubmitted) {
                                    if (snapshotSubmitted.connectionState ==
                                            ConnectionState.waiting ||
                                        snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ));
                                    } else if (snapshotSubmitted.hasError ||
                                        snapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              'Error: ${snapshot.error ?? snapshotSubmitted.error}'));
                                    } else {
                                      List<PartnerRejectBooking>
                                          submittedBookings =
                                          snapshotSubmitted.data ?? [];
                                      if (initialBookings.isEmpty &&
                                          submittedBookings.isEmpty) {
                                        return Container();
                                      } else {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: initialBookings.length,
                                          itemBuilder: (context, index) {
                                            CustomerRejectBooking booking =
                                                initialBookings[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(24.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DETAILSREJECTCUST(
                                                        activityName: booking
                                                            .activityName,
                                                        price: booking.price,
                                                        customerLocation: booking
                                                            .customerLocation,
                                                        bookingId:
                                                            booking.bookingId,
                                                        dateTime:
                                                            booking.dateTime,
                                                        firstName:
                                                            booking.firstName,
                                                        googlemapsurl: booking
                                                            .customerLocation,
                                                        phone: booking
                                                            .Customerphone,
                                                        CUSTOMERrofileImageUrl:
                                                            booking
                                                                .CUSTOMERrofileImageUrl!,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                      color: const Color(
                                                          0XFFF1F1F1),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '#${booking.bookingId}',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'poppins',
                                                            color: Color(
                                                                0XFF007AFF),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              booking
                                                                  .activityName,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              '\$ ${booking.price}',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color(
                                                                    0XFF34A853),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          booking.dateTime,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Poppins',
                                                            color: Color(
                                                                0XFF808083),
                                                          ),
                                                        ),
                                                        Divider(
                                                          color:
                                                              Color(0XFFF1F1F1),
                                                          thickness: 2,
                                                        ),
                                                        Text(
                                                          booking.firstName,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Poppins',
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
                                                              booking
                                                                  .customerLocation,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color(
                                                                    0XFF808083),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            CircleAvatar(
                                                              radius: 18,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              child: booking.CUSTOMERrofileImageUrl !=
                                                                          null &&
                                                                      booking
                                                                          .CUSTOMERrofileImageUrl!
                                                                          .isNotEmpty
                                                                  ? ClipOval(
                                                                      child: Image
                                                                          .network(
                                                                        booking
                                                                            .CUSTOMERrofileImageUrl!,
                                                                        width:
                                                                            36,
                                                                        height:
                                                                            36,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    )
                                                                  : Image.asset(
                                                                      'images/blank_img.png',
                                                                      width: 36,
                                                                      height:
                                                                          36,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                            ),
                                                          ],
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
                                    }
                                  },
                                );
                              }
                            },
                          ),
                          FutureBuilder<List<PartnerRejectBooking>>(
                            future: fetchPartnerRejectBooking(userEmail),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.white,
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                List<PartnerRejectBooking> initialBookings =
                                    snapshot.data ?? [];
                                return FutureBuilder<
                                    List<CustomerRejectBooking>>(
                                  future: fetchCustomerRejectBooking(userEmail),
                                  builder: (context, snapshotSubmitted) {
                                    if (snapshotSubmitted.connectionState ==
                                            ConnectionState.waiting ||
                                        snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ));
                                    } else if (snapshotSubmitted.hasError ||
                                        snapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              'Error: ${snapshot.error ?? snapshotSubmitted.error}'));
                                    } else {
                                      List<CustomerRejectBooking>
                                          submittedBookings =
                                          snapshotSubmitted.data ?? [];
                                      if (initialBookings.isEmpty &&
                                          submittedBookings.isEmpty) {
                                        return Booking_Blank();
                                      } else {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: initialBookings.length,
                                          itemBuilder: (context, index) {
                                            PartnerRejectBooking booking =
                                                initialBookings[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(24.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DETAILSREJECTCUST(
                                                        activityName: booking
                                                            .activityName,
                                                        price: booking.price,
                                                        customerLocation: booking
                                                            .customerLocation,
                                                        bookingId:
                                                            booking.bookingId,
                                                        dateTime:
                                                            booking.dateTime,
                                                        firstName:
                                                            booking.firstName,
                                                        googlemapsurl: booking
                                                            .customerLocation,
                                                        phone: booking
                                                            .Customerphone,
                                                        CUSTOMERrofileImageUrl:
                                                            booking
                                                                .CUSTOMERrofileImageUrl!,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                      color: const Color(
                                                          0XFFF1F1F1),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '#${booking.bookingId}',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'poppins',
                                                            color: Color(
                                                                0XFF007AFF),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              booking
                                                                  .activityName,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              '\$ ${booking.price}',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color(
                                                                    0XFF34A853),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          booking.dateTime,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Poppins',
                                                            color: Color(
                                                                0XFF808083),
                                                          ),
                                                        ),
                                                        Divider(
                                                          color:
                                                              Color(0XFFF1F1F1),
                                                          thickness: 2,
                                                        ),
                                                        Text(
                                                          booking.firstName,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Poppins',
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
                                                              booking
                                                                  .customerLocation,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color(
                                                                    0XFF808083),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            CircleAvatar(
                                                              radius: 18,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              child: booking.CUSTOMERrofileImageUrl !=
                                                                          null &&
                                                                      booking
                                                                          .CUSTOMERrofileImageUrl!
                                                                          .isNotEmpty
                                                                  ? ClipOval(
                                                                      child: Image
                                                                          .network(
                                                                        booking
                                                                            .CUSTOMERrofileImageUrl!,
                                                                        width:
                                                                            36,
                                                                        height:
                                                                            36,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    )
                                                                  : Image.asset(
                                                                      'images/blank_img.png',
                                                                      width: 36,
                                                                      height:
                                                                          36,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                            ),
                                                          ],
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
                                    }
                                  },
                                );
                              }
                            },
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
      ),
    );
  }

  Future<bool> _allListsEmpty() async {
    try {
      // Fetch initial bookings
      List<InitialBooking> initialBookings =
          await fetchInitialBookings(userEmail);

      // Fetch ongoing bookings
      List<OngoingBooking> ongoingBookings =
          await fetchOngoingBookings(userEmail);

      // Fetch submitted bookings
      List<SubmittedBooking> submittedBookings =
          await fetchSubmittedBooking(userEmail);

      // Check if all lists are empty
      return initialBookings.isEmpty &&
          ongoingBookings.isEmpty &&
          submittedBookings.isEmpty;
    } catch (error) {
      print('Error fetching bookings: $error');
      return true; // Return true in case of an error to handle it gracefully
    }
  }
}
