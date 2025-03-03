import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'COMPLETED.dart';
import 'detailedCompletedOrders.dart';
import 'detailedOngoingOrders.dart';



class Completed_Orders extends StatefulWidget {
  static const String id = 'Completed_Orders';

  const Completed_Orders({Key? key}) : super(key: key);

  @override
  State<Completed_Orders> createState() => _Completed_OrdersState();
}

class _Completed_OrdersState extends State<Completed_Orders> {
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
                  'Completed Orders',
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
                  FutureBuilder<List<CompletedBooking>>(
                    future: fetchInitialBookings(userEmail), // userEmail is the current user's email
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<CompletedBooking> initialBookings = snapshot.data ?? [];
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: initialBookings.length,
                          itemBuilder: (context, index) {
                            CompletedBooking booking = initialBookings[index];
                            return Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Detailed_Completed_Orders(activityName: booking.activityName,
                                        price: booking.price,
                                        customerLocation: booking.customerLocation,
                                        bookingId: booking.bookingId,
                                        dateTime: booking.dateTime,
                                        firstName: booking.firstName, googlemapsurl: booking.customerLocation, phone: booking.Customerphone, CUSTOMERrofileImageUrl:booking.CUSTOMERrofileImageUrl!,),
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          booking.firstName ,
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
