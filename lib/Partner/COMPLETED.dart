import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedBooking {
  final String bookingId;
  final String customerLocation;
  final String dateTime;
  final double price;
  final String firstName;
  final String lastName;
  final String activityName;
  final String uid;
  final String googlePageUrl;
  final String Customerphone;
  final String? CUSTOMERrofileImageUrl;


  CompletedBooking({
    required this.bookingId,
    required this.customerLocation,
    required this.dateTime,
    required this.price,
    required this.firstName,
    required this.lastName,
    required this.activityName,
    required this.uid,
    required this.googlePageUrl,
    required this.Customerphone,
    required this.CUSTOMERrofileImageUrl,

  });
}

// Assuming you have fetched initial booking data and stored it in a list called 'initialBookingsData'
Future<List<CompletedBooking>> fetchInitialBookings(String userEmail) async {
  List<CompletedBooking> initialBookings = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('INITIALBOOKING')
        .where('partnerEmail', isEqualTo: userEmail)
        .where('partnerStatus', isEqualTo: 'COMPLETED')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      initialBookings = querySnapshot.docs.map((doc) {
        return CompletedBooking(
          bookingId: doc['ticketNumber'].toString(),
          customerLocation: doc['StreetName']
              + ', ' + doc['area'],
          dateTime: doc['selectedDate']
              + ' ' + doc['selectedTime'],
          price: doc['Price'].toDouble(),
          firstName: doc['CustomerfirstName']+ ' ' +doc['CustomerlastName'],
          lastName: doc['CustomerlastName'],
          activityName: doc['activityName'],
          uid: doc['uidinitialbooking'],
          googlePageUrl: doc['googlePageUrl'],
          Customerphone: doc['Customerphone'],
          CUSTOMERrofileImageUrl: doc['CUSTOMERrofileImageUrl'] ?? '',

        );
      }).toList();
    }
  } catch (e) {
    print('Error fetching initial bookings: $e');
  }

  return initialBookings;
}

