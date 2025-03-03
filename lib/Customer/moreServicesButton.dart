import 'package:flutter/material.dart';

import '../components/datepicker/booking.dart';
import 'Activities.dart';
import 'GOOGLEMAPSCUSTOMER.dart';

class All_Services extends StatelessWidget {
  static const String id = 'All_Services';

  ////IMPORTANT////
/*This is a function  i made to handle every service as u can see starting from
line 116 and i also made a on tap function to handle it */

  Widget _buildServiceRow(
    String imagePath,
    String title,
    String subtitle,
    BuildContext context,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 8),
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontFamily: 'poppins'),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 12,
                  color: Color(0XFF808083),
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Image.asset(
              'images/next_arrow.png',
              width: 21,
              height: 21,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 35),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
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
                      'All Services',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'ArchivoBlack',
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
              _buildServiceRow(
                'images/Plumber.jpeg',
                'Plumber & Pipes Control',
                'Include visiting charge',
                context,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePickerWithButton(
                        activityName: activities[5].name,
                        // Using index 6 for Plumber activity
                        activityDescription: activities[5].description,
                        activityPrice: activities[5].price,
                        activityImage: activities[5].image,
                      ),
                    ),
                  );
                },
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
              _buildServiceRow(
                'images/pest control.jpg',
                'Pest Control',
                'Include visiting charge',
                context,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePickerWithButton(
                        activityName: activities[2].name,
                        // Using index 6 for Plumber activity
                        activityDescription: activities[2].description,
                        activityPrice: activities[2].price,
                        activityImage: activities[2].image,
                      ),
                    ),
                  );
                },
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
              _buildServiceRow(
                'images/Electrician.jpeg',
                'Electrician ',
                'Include visiting charge',
                context,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePickerWithButton(
                        activityName: activities[4].name,
                        // Using index 6 for Plumber activity
                        activityDescription: activities[4].description,
                        activityPrice: activities[4].price,
                        activityImage: activities[4].image,
                      ),
                    ),
                  );
                },
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
              _buildServiceRow(
                'images/AC Services.jpeg',
                'AC & Heater services',
                'Include visiting charge',
                context,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePickerWithButton(
                        activityName: activities[8].name,
                        // Using index 6 for Plumber activity
                        activityDescription: activities[8].description,
                        activityPrice: activities[8].price,
                        activityImage: activities[8].image,
                      ),
                    ),
                  );
                },
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
              _buildServiceRow(
                'images/carcleaning.jpg',
                'Car Cleaning',
                'Include visiting charge',
                context,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePickerWithButton(
                        activityName: activities[1].name,
                        // Using index 6 for Plumber activity
                        activityDescription: activities[1].description,
                        activityPrice: activities[1].price,
                        activityImage: activities[1].image,
                      ),
                    ),
                  );
                },
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
              _buildServiceRow(
                'images/home cleanning.jpeg',
                'House Cleaning ',
                'Include visiting charge',
                context,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePickerWithButton(
                        activityName: activities[0].name,
                        // Using index 6 for Plumber activity
                        activityDescription: activities[0].description,
                        activityPrice: activities[0].price,
                        activityImage: activities[0].image,
                      ),
                    ),
                  );
                },
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
              _buildServiceRow(
                'images/barber.jpg',
                'Barber',
                'Include visiting charge',
                context,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePickerWithButton(
                        activityName: activities[3].name,
                        // Using index 6 for Plumber activity
                        activityDescription: activities[3].description,
                        activityPrice: activities[3].price,
                        activityImage: activities[3].image,
                      ),
                    ),
                  );
                },
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
              _buildServiceRow(
                'images/painting.jpeg',
                'House Painting',
                'Include visiting charge',
                context,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePickerWithButton(
                        activityName: activities[6].name,
                        // Using index 6 for Plumber activity
                        activityDescription: activities[6].description,
                        activityPrice: activities[6].price,
                        activityImage: activities[6].image,
                      ),
                    ),
                  );
                },
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
              _buildServiceRow(
                'images/Carpenter.jpeg',
                'Carpenter',
                'Include visiting charge',
                context,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePickerWithButton(
                        activityName: activities[7].name,
                        // Using index 6 for Plumber activity
                        activityDescription: activities[7].description,
                        activityPrice: activities[7].price,
                        activityImage: activities[7].image,
                      ),
                    ),
                  );
                },
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
              _buildServiceRow(
                'images/Appliancesmore.png',
                'Appliances',
                'Include visiting charge',
                context,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePickerWithButton(
                        activityName: activities[7].name,
                        // Using index 6 for Plumber activity
                        activityDescription: activities[7].description,
                        activityPrice: activities[7].price,
                        activityImage: activities[7].image,
                      ),
                    ),
                  );
                },
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
              _buildServiceRow(
                'images/homeassistmore.png',
                'Home Assist',
                'Include visiting charge',
                context,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePickerWithButton(
                        activityName: activities[7].name,
                        // Using index 6 for Plumber activity
                        activityDescription: activities[7].description,
                        activityPrice: activities[7].price,
                        activityImage: activities[7].image,
                      ),
                    ),
                  );
                },
              ),
              const Divider(
                color: Color(0XFFF1F1F1),
                thickness: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
