import 'package:cloud_firestore/cloud_firestore.dart';

class OngoingBooking {
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
  final String CUSTOMERINITIALuid;


  OngoingBooking({
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
    required this.CUSTOMERINITIALuid,

  });
}

// Assuming you have fetched initial booking data and stored it in a list called 'initialBookingsData'
Future<List<OngoingBooking>> fetchInitialBookings(String userEmail) async {
  List<OngoingBooking> initialBookings = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('INITIALBOOKING')
        .where('partnerEmail', isEqualTo: userEmail)
        .where('partnerStatus', isEqualTo: 'ONGOING')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      initialBookings = querySnapshot.docs.map((doc) {
        return OngoingBooking(
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
          PARTNERUID: doc['tugopartnerId'],
          googlePageUrl: doc['googlePageUrl'],
          Customerphone: doc['Customerphone'],
          latitude: doc['latitude'],
          longitude: doc['longitude'],
          CUSTOMERrofileImageUrl: doc['CUSTOMERrofileImageUrl'] ?? '',
          CUSTOMERINITIALuid: doc['CUSTOMERINITIALuid'] ?? '',

        );
      }).toList();
    }
  } catch (e) {
    print('Error fetching initial bookings: $e');
  }

  return initialBookings;
}

