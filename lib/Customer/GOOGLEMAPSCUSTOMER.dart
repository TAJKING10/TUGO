import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:geocoding/geocoding.dart' as geo;

import '../components/datepicker/booking.dart';

class PlacePickerWithButton extends StatefulWidget {
  final String activityName;
  final String activityDescription;
  final int activityPrice;
  final String activityImage;

  const PlacePickerWithButton(
      {Key? key,
      required this.activityName,
      required this.activityDescription,
      required this.activityPrice,
      required this.activityImage})
      : super(key: key);

  @override
  _PlacePickerWithButtonState createState() => _PlacePickerWithButtonState();
}

class _PlacePickerWithButtonState extends State<PlacePickerWithButton> {
  bool isSearchBarFocused = false;
  TextEditingController floorController = TextEditingController();
  TextEditingController flatNoController = TextEditingController();
  TextEditingController helpController = TextEditingController();
  TextEditingController addressNicknameController = TextEditingController();
  String FLAT = ''; // State variable to store the phone number
  String FLOOR = ''; // State variable to hold email error text

  // Initialize Firebase
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

//   Function to save data to Firebase
// Function to save data to Firebase
//   Function to save data to Firebase

  Future<void> saveDataToFirebase(
    String formattedAddress,
    double latitude,
    double longitude,
    TextEditingController floorController,
    TextEditingController flatNoController,
    TextEditingController helpController,
    TextEditingController addressNicknameController,
    TextEditingController middlePartController,
    String firstPart,
    String PendikIstanbul,
    String lastPart,
  ) async {
    if (formattedAddress != null && latitude != null && longitude != null) {
      // Extracting district, country, and postal code from formatted address
      List<String> addressComponents = formattedAddress.split(',');

      String googlePageUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

      FirebaseFirestore.instance.collection('locations').add({
        'formattedAddress': formattedAddress,
        'latitude': latitude,
        'longitude': longitude,
        // 'postalCode': postalCode,
        'googlePageUrl': googlePageUrl,
        'floor': floorController.text,
        'flatNo': flatNoController.text,
        'help': helpController.text,
        'addressNickname': addressNicknameController.text,
        'StreetName': middlePartController.text,
        'district': firstPart, // Save the first part as district
        'area': PendikIstanbul, // Save PendikIstanbul as area
        'country': lastPart, // Save the last part as country
      });
      print("Data saved to Firebase");
    } else {
      print('Error: Some data is null');
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFirebase(); // Initialize Firebase when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  isSearchBarFocused = hasFocus;
                });
              },
        child: PlacePicker(
          apiKey: dotenv.env['GOOGLE_MAPS_API_KEY'] ?? 'API_KEY_NOT_FOUND', // Corrected this line
          initialPosition: const LatLng(0, 0),
          useCurrentLocation: true,
          selectInitialPosition: true,
          usePlaceDetailSearch: true,
          onPlacePicked: (result) {
            // Handle the picked place
            print('Picked Place: ${result.formattedAddress}');
          },
        forceSearchOnZoomChanged: true,
                automaticallyImplyAppBarLeading: false,
                autocompleteLanguage: "en",
                region: 'tr',
                hintText: 'Search',
                searchingText: 'Searching...',
                selectedPlaceWidgetBuilder:
                    (_, selectedPlace, state, isSearchBarFocused) {
                  String formattedAddress =
                      selectedPlace?.formattedAddress ?? '';
                  List<String> addressParts = formattedAddress
                      .split(',')
                      .map((part) => part.trim())
                      .toList();

                  String firstPart =
                      addressParts.isNotEmpty ? addressParts.first : '';
                  String lastPart =
                      addressParts.length > 1 ? addressParts.last : '';
                  // String middlePart = '';
                  // if (addressParts.length > 2) {
                  //   middlePart = addressParts.getRange(1, addressParts.length - 1).join(', ');
                  // }
                  String streetName = '';
                  if (addressParts.length >= 2) {
                    streetName = addressParts[
                        1]; // Extract the second part, which should be the street name
                  }
                  String pendikIstanbulPart = addressParts.length > 1
                      ? addressParts[addressParts.length - 2]
                      : '';
                  if (pendikIstanbulPart.length > 5) {
                    pendikIstanbulPart =
                        pendikIstanbulPart.substring(5).trimLeft();
                  }
                  //  String pendikIstanbulPart = addressParts.length > 1 ? addressParts[addressParts.length - 3] : '';
                  String PendikIstanbul = addressParts.length > 1
                      ? addressParts[addressParts.length - 2]
                      : '';
                  if (PendikIstanbul.length > 5) {
                    PendikIstanbul = PendikIstanbul.substring(5).trimLeft();
                  }
                  // List<String> partsWithoutPostalCode = PendikIstanbul.split(' ');
                  // if (partsWithoutPostalCode.isNotEmpty && partsWithoutPostalCode[0].length == 5 && int.tryParse(partsWithoutPostalCode[0]) != null) {
                  //   // If the first part is a 5-digit number, consider it as a postal code and remove it
                  //   PendikIstanbul = partsWithoutPostalCode.skip(1).join(' ');
                  // }
                  PendikIstanbul =
                      PendikIstanbul.isNotEmpty ? PendikIstanbul : '';
                  firstPart = firstPart.isNotEmpty ? firstPart : '';
                  lastPart = lastPart.isNotEmpty ? lastPart : '';
                  TextEditingController middlePartController =
                      TextEditingController(text: streetName);
                  TextEditingController firstPartController =
                      TextEditingController(text: firstPart);
                  TextEditingController lastPartController =
                      TextEditingController(text: lastPart);

// Concatenate the first and last two parts
//                   String modifiedAddress = firstPart + (addressParts.length > 2 ? ', ${addressParts[1]}, ' : '') + lastPart;

                  return isSearchBarFocused
                      ? Container()
                      : FloatingCard(
                          bottomPosition: 0,
                          leftPosition: 0.0,
                          rightPosition: 0.0,
                          // width: 100,
                          height: 75,
                          child: state == SearchingState.Searching
                              ? const Center(
                                  child: CircularProgressIndicator(
                                  color: Color(0XFF007AFF),
                                ))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 58,
                                      width: 335,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0XFF007AFF),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                  height:
                                                      600, // Set your desired height here
                                                  color: Colors
                                                      .white, // You can customize the color
                                                  child: SingleChildScrollView(
                                                    child: Padding(
                                                        // Add padding to the bottom to avoid covering by the keyboard
                                                        padding:
                                                            EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: const Color(
                                                                      0XFFCCE4FF),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              21)),
                                                              height: 110,
                                                              width: 500,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(20),
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Row(
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "images/Google_maps.png",
                                                                          color:
                                                                              Color(0XFF007AFF),
                                                                          width:
                                                                              25,
                                                                          height:
                                                                              22,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            "$firstPart,$PendikIstanbul,$lastPart",
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: const TextStyle(
                                                                                fontSize: 10,
                                                                                color: Color(0XFF007AFF),
                                                                                fontWeight: FontWeight.bold,
                                                                                fontFamily: 'OpenSans'),
                                                                          ),
                                                                        ),
                                                                        const Spacer(),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(7.0),
                                                                              border: Border.all(
                                                                                color: const Color(0XFF007AFF),
                                                                              ),
                                                                              color: Colors.white,
                                                                            ),
                                                                            child:
                                                                                const Padding(
                                                                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                                                                              child: Text(
                                                                                'Change',
                                                                                style: TextStyle(
                                                                                  fontSize: 12,
                                                                                  color: Color(0XFF007AFF),
                                                                                  fontFamily: 'OpenSans',
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'Your service will be at the location shown on the map.',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'OpenSans',
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.grey),
                                                                      ),
                                                                      Text(
                                                                        'Adding address details below also assist ultrafast delivery.',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'OpenSans',
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.grey),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            //Street Name
                                                            Container(
                                                              height: 50,
                                                              width: 500,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                              child:
                                                                  DecoratedBox(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  border: Border
                                                                      .all(
                                                                    color: const Color(
                                                                        0XFFE6E5FD),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                                  child:
                                                                      TextField(
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'OpenSans'),
                                                                    controller:
                                                                        middlePartController,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      hintText:
                                                                          'Street Name *',
                                                                      hintStyle: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontFamily:
                                                                              'OpenSans',
                                                                          color:
                                                                              Color(0XFFA3A7B0)),
                                                                      border: InputBorder
                                                                          .none, // Hide default border
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 14,
                                                            ),
                                                            Row(
                                                              children: [
                                                                //floor
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // Container for Floor TextField
                                                                    Container(
                                                                      height:
                                                                          50,
                                                                      width:
                                                                          150,
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              20),
                                                                      child:
                                                                          DecoratedBox(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(7),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                const Color(0XFFE6E5FD),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 10),
                                                                          child:
                                                                              TextField(
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 12,
                                                                              fontFamily: 'OpenSans',
                                                                            ),
                                                                            controller:
                                                                                floorController,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              hintText: 'Floor',
                                                                              hintStyle: TextStyle(
                                                                                fontSize: 12,
                                                                                fontFamily: 'OpenSans',
                                                                                color: Color(0XFFA3A7B0),
                                                                              ),
                                                                              border: InputBorder.none, // Hide default border
                                                                            ),
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                // Reset error text when user edits the email field
                                                                                FLOOR = '';
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // Error Text for Floor TextField
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              20),
                                                                      child:
                                                                          Text(
                                                                        FLOOR.isNotEmpty
                                                                            ? FLOOR
                                                                            : '',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.red,
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),

                                                                //Flat No
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // Container for Floor TextField
                                                                    Container(
                                                                      height:
                                                                          50,
                                                                      width:
                                                                          150,
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              20),
                                                                      child:
                                                                          DecoratedBox(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(7),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                const Color(0XFFE6E5FD),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 10),
                                                                          child:
                                                                              TextField(
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 12,
                                                                              fontFamily: 'OpenSans',
                                                                            ),
                                                                            controller:
                                                                                flatNoController,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              hintText: 'Flat',
                                                                              hintStyle: TextStyle(
                                                                                fontSize: 12,
                                                                                fontFamily: 'OpenSans',
                                                                                color: Color(0XFFA3A7B0),
                                                                              ),
                                                                              border: InputBorder.none, // Hide default border
                                                                            ),
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                // Reset error text when user edits the email field
                                                                                FLAT = '';
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // Error Text for Floor TextField
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              20),
                                                                      child:
                                                                          Text(
                                                                        FLAT.isNotEmpty
                                                                            ? FLAT
                                                                            : '',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.red,
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 14,
                                                            ),

                                                            Container(
                                                              height: 50,
                                                              width: 500,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                              child:
                                                                  DecoratedBox(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  border: Border
                                                                      .all(
                                                                    color: const Color(
                                                                        0XFFE6E5FD),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                                  child:
                                                                      TextField(
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'OpenSans'),
                                                                    controller:
                                                                        helpController,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      hintText:
                                                                          'Help us find you faster (e.g. Ground floor, red door)',
                                                                      hintStyle:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'OpenSans',
                                                                        color: Color(
                                                                            0XFFA3A7B0),
                                                                      ),
                                                                      border: InputBorder
                                                                          .none, // Hide default border
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            const SizedBox(
                                                              height: 14,
                                                            ),
                                                            Divider(
                                                              indent: 25,
                                                              endIndent: 25,
                                                              thickness: 1,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.2),
                                                            ),
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          24,
                                                                      vertical:
                                                                          8),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  'Address Details',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          'OpenSans',
                                                                      color: Color(
                                                                          0XFF7E858E)),
                                                                ),
                                                              ),
                                                            ),

                                                            Container(
                                                              height: 50,
                                                              width: 500,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                              child:
                                                                  DecoratedBox(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  border: Border
                                                                      .all(
                                                                    color: const Color(
                                                                        0XFFE6E5FD),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                                  child:
                                                                      TextField(
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'OpenSans'),
                                                                    controller:
                                                                        addressNicknameController,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      hintText:
                                                                          'Address Nickname (e.g. Mother\'s Name)',
                                                                      hintStyle:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'OpenSans',
                                                                        color: Color(
                                                                            0XFFA3A7B0),
                                                                      ),
                                                                      border: InputBorder
                                                                          .none, // Hide default border
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            const SizedBox(
                                                              height: 25,
                                                            ),
                                                            SizedBox(
                                                              height: 58,
                                                              width: 335,
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      const Color(
                                                                          0XFF007AFF),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  String flat =
                                                                      flatNoController
                                                                          .text
                                                                          .trim();
                                                                  String floor =
                                                                      floorController
                                                                          .text
                                                                          .trim();

                                                                  setState(() {
                                                                    FLAT = '';
                                                                    FLOOR = '';
                                                                  });
                                                                  if (flat
                                                                      .isEmpty) {
                                                                    setState(
                                                                        () {
                                                                      FLAT =
                                                                          'Flat cannot be empty';
                                                                    });
                                                                  }

                                                                  if (floor
                                                                      .isEmpty) {
                                                                    setState(
                                                                        () {
                                                                      FLOOR =
                                                                          'Floor cannot be empty';
                                                                    });
                                                                  }

                                                                  // Check if both flat and floor are not empty and selectedPlace is not null
                                                                  if (flat.isNotEmpty &&
                                                                      floor
                                                                          .isNotEmpty &&
                                                                      selectedPlace !=
                                                                          null) {
                                                                    // Navigate to the next screen
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Booking_Screen(
                                                                          activityName:
                                                                              widget.activityName,
                                                                          activityDescription:
                                                                              widget.activityDescription,
                                                                          activityPrice:
                                                                              widget.activityPrice,
                                                                          activityImage:
                                                                              widget.activityImage,
                                                                          formattedAddress:
                                                                              formattedAddress,
                                                                          lastPart:
                                                                              lastPart,
                                                                          PendikIstanbul:
                                                                              PendikIstanbul,
                                                                          firstPart:
                                                                              firstPart,
                                                                          middlePartController:
                                                                              middlePartController.text,
                                                                          addressNicknameController:
                                                                              addressNicknameController.text,
                                                                          helpController:
                                                                              helpController.text,
                                                                          flatNoController:
                                                                              flatNoController.text,
                                                                          floorController:
                                                                              floorController.text,
                                                                          longitude:
                                                                              selectedPlace.geometry?.location?.lng ?? 0.0,
                                                                          latitude:
                                                                              selectedPlace.geometry?.location?.lat ?? 0.0,
                                                                        ),
                                                                      ),
                                                                    );
                                                                    print(
                                                                        formattedAddress);
                                                                  } else {
                                                                    print(
                                                                        "Error: selectedPlace is null or flat/floor is empty");
                                                                  }
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Save',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'OpenSans',
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ));
                                            },
                                          );
                                          // if (selectedPlace != null) {
                                          //   // Save data to Firebase when the button is pressed
                                          //   saveDataToFirebase(
                                          //     selectedPlace.formattedAddress ?? '',
                                          //     selectedPlace.geometry?.location?.lat ?? 0.0,
                                          //     selectedPlace.geometry?.location?.lng ?? 0.0,
                                          //   );
                                          //   print("Data saved to Firebase");
                                          // } else {
                                          //   print("Error: selectedPlace is null");
                                          // }
                                        },
                                        child: const Text(
                                          'Continue',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      // Add space below the button
                                    )
                                  ],
                                ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
