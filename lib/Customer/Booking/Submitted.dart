import 'package:cloud_firestore/cloud_firestore.dart';

class SubmittedBooking {
  final String bookingId;
  final String customerLocation;
  final String dateTime;
  final double price;
  final String firstName;
  final String lastName;
  final String activityName;
  final String uid;
  // final String PARTNERUID;
  // final String googlePageUrl;
  // final String Customerphone;
  // final double longitude;
  // final double latitude;
  // final String? CUSTOMERrofileImageUrl;


  SubmittedBooking({
    required this.bookingId,
    required this.customerLocation,
    required this.dateTime,
    required this.price,
    required this.firstName,
    required this.lastName,
    required this.activityName,
    required this.uid,
    // required this.PARTNERUID,
    // required this.googlePageUrl,
    // required this.Customerphone,
    // required this.latitude,
    // required this.longitude,
    // required this.CUSTOMERrofileImageUrl,

  });
}

// Assuming you have fetched initial booking data and stored it in a list called 'initialBookingsData'
Future<List<SubmittedBooking>> fetchSubmittedBooking(String userEmail) async {
  List<SubmittedBooking> initialBookings = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('BOOKING')
        .where('Customeremail', isEqualTo: userEmail)
        .where('CUSTOMERSTATUS', isEqualTo: 'SUBMITTED')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      initialBookings = querySnapshot.docs.map((doc) {
        return SubmittedBooking(
          bookingId: doc['ticketNumber'].toString(),
          customerLocation: doc['StreetName']
              + ', ' + doc['area'],
          dateTime: doc['selectedDate']
              + ' ' + doc['selectedTime'],
          price: doc['Price'].toDouble(),
          firstName: doc['CustomerfirstName']+ ' ' +doc['CustomerfirstName'],
          lastName: doc['CustomerlastName'],
          activityName: doc['activityName'],
          uid: doc['uid'],
          // PARTNERUID: doc['tugopartnerId'],
          // googlePageUrl: doc['googlePageUrl'],
          // Customerphone: doc['Customerphone'],
          // latitude: doc['latitude'],
          // longitude: doc['longitude'],
          // CUSTOMERrofileImageUrl: doc['partnerIMAGE'] ?? '',

        );
      }).toList();
    }
  } catch (e) {
    print('Error fetching initial bookings: $e');
  }

  return initialBookings;
}

