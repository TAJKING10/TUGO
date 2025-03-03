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
  final String googlePageUrl;
  final String Customerphone;
  final double longitude;
  final double latitude;
  final String? CUSTOMERrofileImageUrl;
  final String tugopartnerId;
  final String uidinitialbooking;
  final double averageRating;
  final double numRatings;
  OngoingBooking({
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
    required this.latitude,
    required this.longitude,
    required this.CUSTOMERrofileImageUrl,
    required this.uidinitialbooking,
    required this.tugopartnerId,
    required this.averageRating,
    required this.numRatings,

  });
}

// Assuming you have fetched initial booking data and stored it in a list called 'initialBookingsData'
Future<List<OngoingBooking>> fetchOngoingBookings(String userEmail) async {
  List<OngoingBooking> initialBookings = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('INITIALBOOKING')
        .where('Customeremail', isEqualTo: userEmail)
        .where('partnerStatus', isEqualTo: 'ONGOING')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot doc in querySnapshot.docs) {
        // Get the partner ID from INITIALBOOKING document
        String partnerId = doc['tugopartnerId'];

        // Fetch the corresponding partner document from TUGOPARTNERS collection
        DocumentSnapshot partnerDoc = await FirebaseFirestore.instance
            .collection('TUGOPARTNERS')
            .doc(partnerId)
            .get();

        // If partner document exists, extract numRatings and averageRating
        double numRatings = partnerDoc.exists ? (partnerDoc['numRatings'] as int).toDouble() : 0.0;
        double averageRating = partnerDoc.exists ? partnerDoc['averageRating'].toDouble() : 0;



        // Create InitialBooking object
        OngoingBooking booking = OngoingBooking(
          bookingId: doc['ticketNumber'].toString(),
          customerLocation: doc['StreetName'] + ', ' + doc['area'],
          dateTime: doc['selectedDate'] + ' ' + doc['selectedTime'],
          price: doc['Price'].toDouble(),
          firstName: doc['partnerFirstName'] + ' ' + doc['partnerLastName'],
          lastName: doc['CustomerlastName'],
          activityName: doc['activityName'],
          uid: doc['uidinitialbooking'],
          googlePageUrl: doc['googlePageUrl'],
          Customerphone: doc['partnerPhone'],
          latitude: doc['latitude'],
          longitude: doc['longitude'],
          CUSTOMERrofileImageUrl: doc['partnerIMAGE'] ?? '',
          uidinitialbooking: doc['uidinitialbooking'],
          tugopartnerId: doc['tugopartnerId'],
          numRatings: numRatings,
          averageRating: averageRating,
        );

        initialBookings.add(booking);
      }
    }
  } catch (e) {
    print('Error fetching initial bookings: $e');
  }

  return initialBookings;
}

