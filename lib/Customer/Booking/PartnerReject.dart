import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerRejectBooking {
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


  PartnerRejectBooking({
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

  });
}

// Assuming you have fetched initial booking data and stored it in a list called 'initialBookingsData'
Future<List<PartnerRejectBooking>> fetchPartnerRejectBooking(String userEmail) async {
  List<PartnerRejectBooking> initialBookings = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('REJECTEDBOOKINGS')
        .where('Customeremail', isEqualTo: userEmail)
        .where('partnerStatus', isEqualTo: 'NEW')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      initialBookings = querySnapshot.docs.map((doc) {
        return PartnerRejectBooking(
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
          Customerphone: doc['Customerphone'],
          latitude: doc['latitude'],
          longitude: doc['longitude'],
          CUSTOMERrofileImageUrl: doc['partnerIMAGE'] ?? '',

        );
      }).toList();
    }
  } catch (e) {
    print('Error fetching initial bookings: $e');
  }

  return initialBookings;
}

