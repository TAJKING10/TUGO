import 'package:applicationstugo/Screens/welcomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'editProfileScreen(Partner).dart';

class Settings_Screen_Partner extends StatefulWidget {
  static const String id = 'Settings_Screen_Partner';

  const Settings_Screen_Partner({Key? key}) : super(key: key);

  @override
  State<Settings_Screen_Partner> createState() =>
      _Settings_Screen_PartnerState();
}

class _Settings_Screen_PartnerState extends State<Settings_Screen_Partner> {
  late String _firstName = '';
  late String _lastName = '';
  late String _email = '';
  late String _imageUrl = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Call a function to load user data when the widget initializes
    loadUserData();
  }

  Future<void> loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;

      try {
        DocumentSnapshot userData =
            await _firestore.collection('TUGOPARTNERS').doc(uid).get();

        if (userData.exists) {
          Map<String, dynamic> userMap =
              userData.data() as Map<String, dynamic>;
          setState(() {
            _firstName = userMap['firstName'] ?? '';
            _lastName = userMap['lastName'] ?? '';
            _email = userMap['email'] ?? '';
            _imageUrl = userMap['profileImageUrl'] ?? null;
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Column(
                  children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _imageUrl.isNotEmpty
                            ? Image.network(
                          _imageUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              // Image is fully loaded
                              return child;
                            } else {
                              // Show a loading indicator while the image is loading
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        )
                            : Image.asset(
                          'images/default avatar.png',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 15),
                    Text(
                      '$_firstName $_lastName',
                      style: const TextStyle(
                        fontFamily: 'ArchivoBlack',
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$_email',
                      style: const TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Edit_Profile_Partner(),
                          ),
                        );
                        ;
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(174, 35),
                        // Set the width and height of the button

                        foregroundColor: const Color(0XFF007AFF),
                        backgroundColor: Colors.white,
                        // Text color of the button
                        side: const BorderSide(
                            color: Color(0XFF007AFF), width: 2),
                        // Border color and width
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14.0), // Border radius
                        ),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'poppins',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 13.0),
              child: Text(
                'Profile',
                style: TextStyle(
                    fontFamily: 'poppins', fontSize: 14, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 32.0, // set your desired width
                      height: 32.0, // set your desired height
                      child: Image.asset('images/help center.png'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Help Center',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    // This widget will take up any available space
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0XFF777777),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              indent: 15,
              endIndent: 9,
              thickness: 0.8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 32.0, // set your desired width
                      height: 32.0, // set your desired height
                      child: Image.asset('images/share and earn.png'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Share & Earn',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    // This widget will take up any available space
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0XFF777777),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              indent: 15,
              endIndent: 9,
              thickness: 0.8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 32.0, // set your desired width
                      height: 32.0, // set your desired height
                      child: Image.asset('images/rate us.png'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Rate Us',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    // This widget will take up any available space
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0XFF777777),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              indent: 15,
              endIndent: 9,
              thickness: 0.8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 32.0, // set your desired width
                      height: 32.0, // set your desired height
                      child: Image.asset('images/FAQ\'S.png'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'FAQ\'s',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    // This widget will take up any available space
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0XFF777777),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              indent: 15,
              endIndent: 9,
              thickness: 0.8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 32.0, // set your desired width
                      height: 32.0, // set your desired height
                      child: Image.asset('images/privacy policy.png'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    // This widget will take up any available space
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0XFF777777),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              indent: 15,
              endIndent: 9,
              thickness: 0.8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: InkWell(
                onTap: () {
                  // Show a bottom sheet when Logout is tapped
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Container(
                          height: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Divider(
                                endIndent: 180,
                                indent: 180,
                                thickness: 4,
                                color: Color(0XFFD6D6D6),
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                'Log out',
                                style: TextStyle(
                                    fontFamily: 'ArchivoBlack', fontSize: 24),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Are you sure you want to logout?',
                                style: TextStyle(
                                    color: Color(0XFF8B8B8D),
                                    fontSize: 18,
                                    fontFamily: 'poppins'),
                              ),
                              const SizedBox(height: 30),
                              Center(
                                child: SizedBox(
                                  width: 335,
                                  height: 58,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0XFF007AFF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                    ),
                                    onPressed: () async {
                                      // Clear shared preferences on logout
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      sharedPreferences.clear();

                                      // Navigate to WelcomeScreen
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WelcomeScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Yes, Logout',
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: SizedBox(
                                  width: 335,
                                  height: 58,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0XFFF1F1F1),
                                      // Set the background color to grey
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        color: Color(0XFF8C8C8E),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 32.0, // set your desired width
                      height: 32.0, // set your desired height
                      child: Image.asset('images/Logout.png'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    // This widget will take up any available space
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0XFF777777),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              indent: 15,
              endIndent: 9,
              thickness: 0.8,
            ),
          ],
        ),
      )),
    );
  }
}
