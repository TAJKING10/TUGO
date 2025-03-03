import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Edit_ProfilePartner extends StatefulWidget {
  static const String id = 'Edit_Profile';

  @override
  State<Edit_ProfilePartner> createState() => _Edit_ProfilePartnerState();
}

class _Edit_ProfilePartnerState extends State<Edit_ProfilePartner> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final emailController = TextEditingController();

  final firstName = TextEditingController();

  final lastName = TextEditingController();

  final Bio = TextEditingController();
  String? _imageUrl;
  Uint8List? _image;
  @override
  void initState() {
    super.initState();
    loadUserData();
  }
  Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    }

    print('No Images Selected');
    return null;
  }

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<void> uploadImage() async {
    User? user = _auth.currentUser;
    if (user != null && _image != null) {
      try {
        String uid = user.uid;

        TaskSnapshot snapshot = await _storage
            .ref()
            .child('profile_images/$uid.jpg')
            .putData(_image!);

        _imageUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }



  void loadUserData() async {
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
            firstName.text = userMap['firstName'] ?? '';
            lastName.text = userMap['lastName'] ?? '';
            emailController.text = userMap['email'] ?? '';
            Bio.text = userMap['bio'] ?? '';
            _imageUrl = userMap['profileImageUrl'] ?? null;

            // Add retrieval for other fields here
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  Future<void> saveUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;

      // Upload the image to Firebase Storage
      await uploadImage();

      String firstNameValue = firstName.text.trim();
      String lastNameValue = lastName.text.trim();
      String emailValue = emailController.text.trim();
      String bioValue = Bio.text.trim();

      Map<String, dynamic> updatedData = {
        'firstName': firstNameValue.isEmpty ? null : firstNameValue,
        'lastName': lastNameValue.isEmpty ? null : lastNameValue,
        'email': emailValue.isEmpty ? null : emailValue,
        'bio': bioValue.isEmpty ? null : bioValue,
      };

      if (_imageUrl != null) {
        updatedData['profileImageUrl'] = _imageUrl;
      }

      try {
        await _firestore.collection('TUGOPARTNERS').doc(uid).update(updatedData);
        print('User data updated successfully!');
      } catch (e) {
        print('Error updating user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            color: Color(0XFF808083),
                            fontFamily: 'poppins',
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Archivoblack',
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          saveUserData();

                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Color(0XFF248DFE),
                            fontFamily: 'poppins',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: selectImage,
                          child: Stack(
                            children: [
                              _image != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.memory(
                                  _image!,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : (_imageUrl != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  _imageUrl!,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'images/default avatar.png',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              )),
                              Positioned(
                                bottom: -120,
                                right: 1,
                                left: 1,
                                top: 1,
                                child: Image.asset('images/cameraicon.png'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'First Name',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0XFF808083),
                          ),
                        ),
                        TextField(
                          style:
                          const TextStyle(fontSize: 18, fontFamily: 'Archivoblack'),
                          controller: firstName,
                          decoration: InputDecoration(
                            hintText: 'Enter your First Name',
                            hintStyle: const TextStyle(
                                fontFamily: 'poppins',
                                color: Color(0XFFBFBFBF),
                                fontSize: 13),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.white),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                firstName.clear();
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Color(0XFFBFBFBF),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Last Name',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0XFF808083),
                          ),
                        ),
                        TextField(
                          style:
                          const TextStyle(fontSize: 18, fontFamily: 'Archivoblack'),
                          controller: lastName,
                          decoration: InputDecoration(
                            hintText: 'Enter your Last Name',
                            hintStyle: const TextStyle(
                                fontFamily: 'poppins',
                                color: Color(0XFFBFBFBF),
                                fontSize: 13),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.white),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                lastName.clear();
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Color(0XFFBFBFBF),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'E-mail',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0XFF808083),
                          ),
                        ),
                        TextField(
                          style:
                          const TextStyle(fontSize: 18, fontFamily: 'Archivoblack'),
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: const TextStyle(
                                fontFamily: 'poppins',
                                color: Color(0XFFBFBFBF),
                                fontSize: 13),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.white),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                emailController.clear();
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Color(0XFFBFBFBF),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Mobile Number',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0XFFBFBFBF),
                          ),
                        ),
                        IntlPhoneField(
                          style:
                          const TextStyle(fontSize: 18, fontFamily: 'Archivoblack'),
                          decoration: const InputDecoration(
                            hintText: 'Enter your Number',
                            hintStyle: TextStyle(
                                fontFamily: 'poppins',
                                color: Color(0XFFBFBFBF),
                                fontSize: 13),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.white),
                            ),
                          ),
                          initialCountryCode: 'TR',
                          onChanged: (phone) {},
                        ),
                        const Text(
                          'Bio',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0XFF808083),
                          ),
                        ),
                        TextField(
                          style:
                          const TextStyle(fontSize: 18, fontFamily: 'Archivoblack'),
                          controller: Bio,
                          decoration: InputDecoration(
                            hintText: 'Enter your Bio',
                            hintStyle: const TextStyle(
                                fontFamily: 'poppins',
                                color: Color(0XFFBFBFBF),
                                fontSize: 13),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.white),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                Bio.clear();
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Color(0XFFBFBFBF),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: SizedBox(
                            width: 335,
                            height: 58,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0XFF007AFF), // Set the background color to grey
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17),
                                ),
                              ),
                              onPressed: () {
                                saveUserData();

                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'poppins',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}