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
  final String PARTNERUID;
  final String googlePageUrl;
  final String Customerphone;
  final double longitude;
  final double latitude;
  final String? CUSTOMERrofileImageUrl;
  final String tugopartnerId;
  final String uidinitialbooking;


  CompletedBooking({
    required this.bookingId,
    required this.customerLocation,
    required this.dateTime,
    required this.price,
    required this.firstName,
    required this.lastName,
    required this.activityName,
    required this.uid,
    required this.PARTNERUID,
    required this.googlePageUrl,
    required this.Customerphone,
    required this.latitude,
    required this.longitude,
    required this.CUSTOMERrofileImageUrl,
    required this.uidinitialbooking,
    required this.tugopartnerId,
  });
}

// Assuming you have fetched initial booking data and stored it in a list called 'initialBookingsData'
Future<List<CompletedBooking>> fetchCompletedBooking(String userEmail) async {
  List<CompletedBooking> initialBookings = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('INITIALBOOKING')
        .where('Customeremail', isEqualTo: userEmail)
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
          firstName: doc['partnerFirstName']+ ' ' +doc['partnerLastName'],
          lastName: doc['CustomerlastName'],
          activityName: doc['activityName'],
          uid: doc['uidinitialbooking'],
          PARTNERUID: doc['tugopartnerId'],
          googlePageUrl: doc['googlePageUrl'],
          Customerphone: doc['partnerPhone'],
          latitude: doc['latitude'],
          longitude: doc['longitude'],
          CUSTOMERrofileImageUrl: doc['partnerIMAGE'] ?? '',
          uidinitialbooking: doc['uidinitialbooking'],
          tugopartnerId: doc['tugopartnerId'],
        );
      }).toList();
    }
  } catch (e) {
    print('Error fetching initial bookings: $e');
  }

  return initialBookings;
}

