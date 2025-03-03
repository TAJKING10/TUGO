import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:latlong2/latlong.dart';

import '../components/datepicker/booking.dart';
import '../components/locationService.dart';
import 'Activities.dart';
import 'GOOGLEMAPSCUSTOMER.dart';
import 'moreServicesButton.dart';

final user = FirebaseAuth.instance.currentUser;
final uid = user?.uid;

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late String global_lat;
late String global_long;
late String global_country;
late String global_adminArea;
late String global_postalcode;
late String global_adress;
late String global_district;
late String global_currentUser;

class Home_Page extends StatefulWidget {
  static const String id = 'Home_Page';

  const Home_Page({Key? key}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  int activeIndex = 0;
  final assetImages = [
    'images/pest control.jpg',
    'images/AC Services.jpeg',
    'images/carcleaning.jpg',
  ];

  // String? lat,
  //     long,
  //     country,
  //     adminArea,
  //     postalcode,
  //     adress,
  //     district,
  //     currentUser;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    final service = LocationService();
    final locationData = await service.getLocation();
    if (locationData != null) {
      final placeMark = await service.getPlaceMark(locationData: locationData);
      setState(() {
        global_lat = locationData.latitude!.toStringAsFixed(2);
        global_long = locationData.longitude!.toStringAsFixed(2);
        global_country = placeMark?.country ?? ' could not get country';
        global_adminArea =
            placeMark?.administrativeArea ?? ' could not get admin area';
        global_district = placeMark?.subAdministrativeArea ?? 'no';
        global_adress = placeMark?.street ?? 'could not find street';
        global_postalcode =
            placeMark?.postalCode ?? 'could not get admin postal code ';
      });

      saveLocationDataToFirestore(uid); // Pass the UID
    }
  }

  void saveLocationDataToFirestore(String? uid) async {
    try {
      if (uid != null) {
        final userDocRef = _firestore.collection('TUGOCUSTOMERS').doc(uid);

        // Check if the document exists
        final userDocSnapshot = await userDocRef.get();

        if (userDocSnapshot.exists) {
          // Update the existing document
          await userDocRef.update({
            'latitude': global_lat,
            'longitude': global_long,
            'country': global_country,
            'adminArea': global_adminArea,
            'district': global_district,
            'address': global_adress,
            'postalCode': global_postalcode,
            'timestamp': FieldValue.serverTimestamp(),
          });

          print('Location data updated in Firestore.');
        } else {
          print('Error: Document does not exist for UID: $uid');
        }
      } else {
        print('Error: UID is null');
      }
    } catch (e) {
      print('Error saving location data: $e');
    }
  }

  //Images

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: assetImages.length,
        effect: const ScrollingDotsEffect(
          dotHeight: 6,
          dotWidth: 6,
          activeDotColor: Color(
            0XFF007AFF,
          ),
          dotColor: Color(
            0XFFBFBFBF,
          ),
        ),
      );

  Widget buildCircularButton(String imagePath, VoidCallback onTap) {
    return TableCell(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(imagePath, width: 56.0, height: 60.0),
        ),
      ),
    );
  }
  String addressText = 'Loading...'; // Default constant value

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(children: [
                  Image.asset('images/loicon.png', height: 19.3, width: 14.68),
                  const SizedBox(
                    width: 13,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Location',
                        style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 12,
                            color: Color(0XFF808083)),
                      ),
                      Row(
                        children: [
                          Text(
                            " Turkey, Istanbul",
                            // '${global_country}, ${global_adminArea}, ${global_district}',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'poppins',
                                color: Color(0XFF1F1F1F)),
                          ),
                          const SizedBox(
                            width: 13,
                          ),
                          Image.asset('images/down arrow.png',
                              height: 6, width: 8),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Coming Soon',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'Poppins'),
                            ),
                            content: Text(
                              'This feature is coming soon.',
                              style: TextStyle(
                                  fontSize: 12, fontFamily: 'Poppins'),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Image.asset(
                      'images/notifications icon.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                ]),
              ),
              Container(
                margin: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0XFFF1F1F1),
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                        fontFamily: 'poppins',
                        color: Color(0XFF808083),
                        fontSize: 14),
                    prefixIcon: Container(
                      width: 30.0, // Set your desired width
                      height: 30.0, // Set your desired height
                      padding: const EdgeInsets.all(13.0),
                      child: Image.asset(
                        'images/searchbar.png',
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 160,
                      viewportFraction: 1,
                      autoPlay: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      autoPlayInterval: const Duration(seconds: 7),
                      onPageChanged: (index, reason) =>
                          setState(() => activeIndex = index),
                    ),
                    itemCount: assetImages.length,
                    itemBuilder: (context, index, realIndex) {
                      return GestureDetector(
                        onTap: () {
                          // Handle button click for Pest Control image
                          if (index == 0) {
                            // Add your logic here
                            print("Button tapped for Pest Control");
                          }
                        },
                        child: Stack(children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.asset(
                                assetImages[index],
                                // Access the specific image based on the index
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 23),
                          ),
                          if (index ==
                              0) // Show button only for Pest Control image
                            Positioned(
                                bottom: 20.0,
                                left: 50.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Add your button logic here
                                    print("Button tapped for Pest Control");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text(
                                    "Book Now",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'poppins',
                                      color: Colors.black,
                                    ),
                                  ),
                                ))
                        ]),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  buildIndicator(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder.all(
                    color: const Color(0XFFF1F1F1),
                    width: 1,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  children: [
                    TableRow(
                      children: [
                        buildCircularButton('images/appliances.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[1].name,
                                activityDescription: activities[1].description,
                                activityPrice: activities[1].price,
                                activityImage: activities[1].image,
                              ),
                            ),
                          );

                          // Handle button tap for appliances
                        }),
                        buildCircularButton('images/painint.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[6].name,
                                activityDescription: activities[6].description,
                                activityPrice: activities[6].price,
                                activityImage: activities[6].image,
                              ),
                            ),
                          );
                          // Handle button tap for painting
                        }),
                        buildCircularButton('images/electrical.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[4].name,
                                activityDescription: activities[4].description,
                                activityPrice: activities[4].price,
                                activityImage: activities[4].image,
                              ),
                            ),
                          );
                          // Handle button tap for electrical
                        }),
                        buildCircularButton('images/cleaning.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[0].name,
                                activityDescription: activities[0].description,
                                activityPrice: activities[0].price,
                                activityImage: activities[0].image,
                              ),
                            ),
                          );
                          // Handle button tap for cleaning
                        }),
                      ],
                    ),
                    TableRow(
                      children: [
                        buildCircularButton('images/Ac services.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[8].name,
                                activityDescription: activities[8].description,
                                activityPrice: activities[8].price,
                                activityImage: activities[8].image,
                              ),
                            ),
                          );
                          // Handle button tap for AC services
                        }),
                        buildCircularButton('images/home assist.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[1].name,
                                activityDescription: activities[1].description,
                                activityPrice: activities[1].price,
                                activityImage: activities[1].image,
                              ),
                            ),
                          );
                          // Handle button tap for home assistance
                        }),
                        buildCircularButton('images/pest control icon.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[2].name,
                                activityDescription: activities[2].description,
                                activityPrice: activities[2].price,
                                activityImage: activities[2].image,
                              ),
                            ),
                          );
                          // Handle button tap for pest control
                        }),
                        buildCircularButton('images/More.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => All_Services(),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Cleaning &\nPest control',
                      style:
                          TextStyle(fontSize: 18, fontFamily: 'Archivoblack'),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[0].name,
                                activityDescription: activities[0].description,
                                activityPrice: activities[0].price,
                                activityImage: activities[0].image,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'images/home cleanning.jpeg',
                                  width: 163.0,
                                  height: 105.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'House Cleaning',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'poppins',
                                ),
                              ),
                              Text(
                                'Service at Home',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'poppins',
                                  color: Color(0XFF808083),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Start at',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'poppins',
                                      color: Color(0XFFBFBFBF),
                                    ),
                                  ),
                                  Text(
                                    '  \$49',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'poppins',
                                      color: Color(0XFF34A853),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[1].name,
                                activityDescription: activities[1].description,
                                activityPrice: activities[1].price,
                                activityImage: activities[1].image,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'images/carcleaning.jpg',
                                  width: 163.0,
                                  height: 105.0,
                                  fit: BoxFit
                                      .cover, // You may want to adjust the fit based on your needs
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              const Text(
                                'Car Cleaning',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'poppins',
                                ),
                              ),
                              const Text(
                                'Service at Home',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'poppins',
                                    color: Color(0XFF808083)),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'Start at',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFFBFBFBF)),
                                  ),
                                  Text(
                                    '  \$149',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFF34A853)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[2].name,
                                activityDescription: activities[2].description,
                                activityPrice: activities[2].price,
                                activityImage: activities[2].image,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'images/pest control.jpg',
                                  width: 163.0,
                                  height: 105.0,
                                  fit: BoxFit
                                      .cover, // You may want to adjust the fit based on your needs
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              const Text(
                                'Pest Control',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'poppins',
                                ),
                              ),
                              const Text(
                                'Service at Home',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'poppins',
                                    color: Color(0XFF808083)),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'Start at',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFFBFBFBF)),
                                  ),
                                  Text(
                                    '  \$70',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFF34A853)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Add more containers as needed
                  ],
                ),
              ),
              const SizedBox(
                height: 11,
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Our Best Services',
                      style:
                          TextStyle(fontSize: 18, fontFamily: 'Archivoblack'),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[3].name,
                                activityDescription: activities[3].description,
                                activityPrice: activities[3].price,
                                activityImage: activities[3].image,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'images/barber.jpg',
                                  width: 163.0,
                                  height: 105.0,
                                  fit: BoxFit
                                      .cover, // You may want to adjust the fit based on your needs
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              const Text(
                                'Barber',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'poppins',
                                ),
                              ),
                              const Text(
                                'Free Waxing',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'poppins',
                                    color: Color(0XFF808083)),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'Start at',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFFBFBFBF)),
                                  ),
                                  Text(
                                    '  \$69',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFF34A853)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[5].name,
                                activityDescription: activities[5].description,
                                activityPrice: activities[5].price,
                                activityImage: activities[5].image,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'images/Plumber.jpeg',
                                  width: 163.0,
                                  height: 105.0,
                                  fit: BoxFit
                                      .cover, // You may want to adjust the fit based on your needs
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              const Text(
                                'Plumber',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'poppins',
                                ),
                              ),
                              const Text(
                                'Service at Home',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'poppins',
                                    color: Color(0XFF808083)),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'Start at',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFFBFBFBF)),
                                  ),
                                  Text(
                                    '  \$79',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFF34A853)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[0].name,
                                activityDescription: activities[0].description,
                                activityPrice: activities[0].price,
                                activityImage: activities[0].image,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'images/home cleanning.jpeg',
                                  width: 163.0,
                                  height: 105.0,
                                  fit: BoxFit
                                      .cover, // You may want to adjust the fit based on your needs
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              const Text(
                                'Home Cleaning',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'poppins',
                                ),
                              ),
                              const Text(
                                'Service at Home',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'poppins',
                                    color: Color(0XFF808083)),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'Start at',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFFBFBFBF)),
                                  ),
                                  Text(
                                    '  \$70',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFF34A853)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Add more containers as needed
                  ],
                ),
              ),
              const SizedBox(
                height: 11,
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Next Thing\nOn Your Mind',
                      style:
                          TextStyle(fontSize: 18, fontFamily: 'Archivoblack'),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'images/comingsoon.png',
                                width: 122.0,
                                height: 174.0,
                                // fit: BoxFit.cover,
                              ),
                            ),
                            // Overlay Container for Transparent White Top
                          ]),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'images/comingsoon.png',
                                width: 122.0,
                                height: 174.0,
                                // fit: BoxFit.cover,
                              ),
                            ),
                            // Overlay Container for Transparent White Top

                          ]),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'images/comingsoon.png',
                                width: 122.0,
                                height: 174.0,
                                // fit: BoxFit.cover,
                              ),
                            ),
                            // Overlay Container for Transparent White Top

                          ]),
                        ],
                      ),
                    ),

                    // Add more containers as needed
                  ],
                ),
              ),
              const SizedBox(
                height: 11,
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Offers',
                      style:
                          TextStyle(fontSize: 18, fontFamily: 'Archivoblack'),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[1].name,
                                activityDescription: activities[1].description,
                                activityPrice: activities[1].price,
                                activityImage: activities[1].image,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'images/painting.jpeg',
                                  width: 290.0,
                                  height: 202.0,
                                  fit: BoxFit
                                      .cover, // You may want to adjust the fit based on your needs
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              const Text(
                                'Painting',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'poppins',
                                ),
                              ),
                              const Text(
                                'Service at Home',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'poppins',
                                    color: Color(0XFF808083)),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'Start at',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFFBFBFBF)),
                                  ),
                                  Text(
                                    '  \$69',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFF34A853)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[7].name,
                                activityDescription: activities[7].description,
                                activityPrice: activities[7].price,
                                activityImage: activities[7].image,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'images/Carpenter.jpeg',
                                  width: 290.0,
                                  height: 202.0,
                                  fit: BoxFit
                                      .cover, // You may want to adjust the fit based on your needs
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              const Text(
                                'Carpenter',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'poppins',
                                ),
                              ),
                              const Text(
                                'Service at Home',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'poppins',
                                    color: Color(0XFF808083)),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'Start at',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFFBFBFBF)),
                                  ),
                                  Text(
                                    '  \$79',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFF34A853)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerWithButton(
                                activityName: activities[8].name,
                                activityDescription: activities[8].description,
                                activityPrice: activities[8].price,
                                activityImage: activities[8].image,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'images/AC Services.jpeg',
                                  width: 290.0,
                                  height: 202.0,
                                  fit: BoxFit
                                      .cover, // You may want to adjust the fit based on your needs
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              const Text(
                                'AC Services',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'poppins',
                                ),
                              ),
                              const Text(
                                'Service at Home',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'poppins',
                                    color: Color(0XFF808083)),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'Start at',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFFBFBFBF)),
                                  ),
                                  Text(
                                    '  \$70',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins',
                                        color: Color(0XFF34A853)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Add more containers as needed
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
