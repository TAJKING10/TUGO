import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'navigationbarPartnerSide.dart';

class PartnerSettingProfile extends StatefulWidget {
  static const String id = 'PartnerSettingProfile';

  PartnerSettingProfile({super.key});

  @override
  State<PartnerSettingProfile> createState() => _PartnerSettingProfileState();
}

class _PartnerSettingProfileState extends State<PartnerSettingProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool signUpPressed = false;
  bool isLastNameError = false;
  bool isFirstNameError = false;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  Country? _selectedCountry;
  DateTime selectedDate = DateTime.now();
  bool isDateError = false;

  bool _isDateValid(DateTime selectedDate) {
    // Check if the selected date is not null or empty
    return selectedDate != null;
  }

  bool isGenderError =
      false; // State variable to manage gender error visibility
  bool isCountryError = false;
  int? selectedGenderIndex; //
  String? selectedGender; // Variable to store the selected gender name
  bool isGenderSelected() {
    return selectedGenderIndex != null;
  }

  @override
  void initState() {
    super.initState();
    firstName.addListener(() {
      setState(() {
        isFirstNameError = false;
      });
    });
    lastName.addListener(() {
      setState(() {
        isLastNameError = false;
      });
    });
  }

  void _saveProfile() async {
    String firstNameValue = firstName.text.trim();
    String lastNameValue = lastName.text.trim();

    bool hasError = false;

    setState(() {
      isFirstNameError = firstNameValue.isEmpty;
      isLastNameError = lastNameValue.isEmpty;
      isGenderError = selectedGender == null;
      isCountryError = _selectedCountry == null;

      // Check for age validity
      isDateError = !_isAgeValid(selectedDate);
    });

    hasError = isFirstNameError ||
        isLastNameError ||
        isGenderError ||
        isCountryError ||
        isDateError;

    if (!hasError) {
      // Reset all errors when no validation errors occur
      setState(() {
        isFirstNameError = false;
        isLastNameError = false;
        isGenderError = false;
        isCountryError = false; // Reset country error
        isDateError = false; // Reset date error
      });

      User? user = _auth.currentUser;

      if (user != null) {
        String uid = user.uid;

        // Calculate age from selected date
        DateTime currentDate = DateTime.now();
        int age = currentDate.year - selectedDate.year;

        Map<String, dynamic> profileData = {
          'firstName': firstNameValue,
          'lastName': lastNameValue,
          'gender': selectedGender,
          'country': _selectedCountry!.name,
          'dateOfBirth': selectedDate
              .toIso8601String(), // Save date of birth as ISO string
          'age': age, // Save calculated age
          // ... Add other profile data fields here
        };

        try {
          await _firestore
              .collection('TUGOPARTNERS')
              .doc(uid)
              .update(profileData);
          print('Profile data saved successfully!');
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  const Navigation_Bar_Partner_Side(),
            ),
          );
          // Navigate to the next screen upon successful save
          // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
        } catch (e) {
          print('Error saving profile data: $e');
          // Handle the error in an appropriate way (e.g., display a message to the user)
        }
      } else {
        print('User is not authenticated');
      }
    }
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    super.dispose();
  }

  ///// Date picker
  void _showDatePicker(BuildContext context) async {
    final DateTime picked = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builderContext) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
              ),
              CupertinoButton(
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onPressed: () {
                  if (_isAgeValid(selectedDate)) {
                    Navigator.of(builderContext).pop();
                    // Do something with the selected date, if needed.
                  } else {
                    _showAgeAlert(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _isAgeValid(selectedDate); // Check age validity when a date is selected
      });
    } else {
      setState(() {
        isDateError = true; // Set date error if no date is selected
      });
    }
  }

  bool _isAgeValid(DateTime selectedDate) {
    // Calculate age from selected date
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - selectedDate.year;

    // Check if the age is 18 or older
    bool isValidAge = age >= 18;

    // If age is less than 18, set the date error
    setState(() {
      isDateError = !isValidAge;
    });

    return isValidAge;
  }

  void _showAgeAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Image.asset(
                'images/close.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Error',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Archivoblack',
                  color: Color(0XFFE04F5F),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                  child: Text(
                textAlign: TextAlign.center,
                'The minimum age required is 18 years.',
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 16,
                  color: Colors.grey,
                ),
              )),
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0XFFE04F5F),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Create a TextEditingController
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'images/Fixing AC.jpg',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Scrollbar(
            thickness: 4,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 35),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/logo.png",
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Tugo',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'ArchivoBlack'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                    ),
                    height: 900,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Complete Your Profile',
                                style: TextStyle(
                                    fontFamily: 'ArchivoBlack', fontSize: 24),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
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
                                controller: firstName,
                                decoration: InputDecoration(
                                  hintText: 'Enter your First Name',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'poppins',
                                    color: Color(0XFFBFBFBF),
                                    fontSize: 13,
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.white),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.white),
                                  ),
                                  errorText: isFirstNameError
                                      ? 'First name cannot be empty'
                                      : null,
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
                                onChanged: (value) {
                                  setState(() {
                                    isFirstNameError = value.trim().isEmpty;
                                  });
                                },
                              ),

                              const SizedBox(
                                height: 10,
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
                                controller: lastName,
                                decoration: InputDecoration(
                                  hintText: 'Enter your Last Name',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'poppins',
                                    color: Color(0XFFBFBFBF),
                                    fontSize: 13,
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.white),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.white),
                                  ),
                                  errorText: isLastNameError
                                      ? 'Last name cannot be empty'
                                      : null,
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
                                onChanged: (value) {
                                  setState(() {
                                    isLastNameError = value.trim().isEmpty;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'What service you will be offering',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0XFF808083),
                                ),
                              ),
                               TextField(
                                  controller: TextEditingController(text: 'Everything'),
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: 'Everything',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color(0XFFBFBFBF),
                                      fontSize: 13,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                               ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Choose Your Date of birth',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 16,
                                  color: Color(0XFF808083),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: GestureDetector(
                                  child: Container(
                                    width: 350,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFA9A9A9),
                                      ),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'images/calendar-7-48.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              selectedDate != null
                                                  ? DateFormat('dd-MM-yyyy')
                                                      .format(selectedDate)
                                                  : 'Select Date Of Birth',
                                              style: const TextStyle(
                                                color: Color(0xFF808083),
                                                fontFamily: 'poppins',
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    _showDatePicker(context);
                                  },
                                ),
                              ),

                              if (isDateError)
                                const Text(
                                  'Please select your Age',
                                  style: TextStyle(
                                    color: Color(
                                        0XFFD33131), // Set the error text color
                                  ),
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Choose Your Country',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 16,
                                  color: Color(0XFF808083),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: GestureDetector(
                                  child: Container(
                                    width: 350,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFA9A9A9),
                                      ),
                                      color: Colors.white, // Background color
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'images/loicon.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _selectedCountry != null
                                                ? '${_selectedCountry!.name} ${_selectedCountry!.flagEmoji}'
                                                : 'Select Country',
                                            style: const TextStyle(
                                              color: Color(0xFF808083),
                                              fontFamily: 'poppins',
                                              fontSize: 16,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    showCountryPicker(
                                      context: context,
                                      onSelect: (Country country) {
                                        setState(() {
                                          _selectedCountry = country;
                                          isCountryError =
                                              false; // Reset the country error on selection
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                              if (isCountryError)
                                const Text(
                                  'Please select your country',
                                  style: TextStyle(
                                    color: Color(
                                        0XFFD33131), // Set the error text color
                                  ),
                                ),
                              const SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedGender = 'Male';
                                        selectedGenderIndex =
                                            selectedGenderIndex == 0 ? null : 0;
                                      });
                                      // Reset gender error
                                      setState(() {
                                        isGenderError = false;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0XFFF7F6F4),
                                        border: Border.all(
                                          color: selectedGenderIndex == 0
                                              ? Colors.blue
                                              : Colors.transparent,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      width: 150,
                                      height: 100,
                                      child: Stack(
                                        children: [
                                          const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Center(
                                                child: Text(
                                                  'Male',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'poppins',
                                                    fontSize: 20,
                                                    color: Color(0XFF808083),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (selectedGenderIndex == 0)
                                            const Positioned(
                                              top: 5,
                                              right: 5,
                                              child: Icon(
                                                Icons.check_circle,
                                                color: Colors.blue,
                                                size: 20,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedGender = 'Female';
                                        selectedGenderIndex =
                                            selectedGenderIndex == 1 ? null : 1;
                                      });
                                      // Reset gender error
                                      setState(() {
                                        isGenderError = false;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0XFFF7F6F4),
                                        border: Border.all(
                                          color: selectedGenderIndex == 1
                                              ? Colors.pinkAccent
                                              : Colors.transparent,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      width: 150,
                                      height: 100,
                                      child: Stack(
                                        children: [
                                          const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Center(
                                                child: Text(
                                                  'Female',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'poppins',
                                                    fontSize: 20,
                                                    color: Color(0XFF808083),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (selectedGenderIndex == 1)
                                            const Positioned(
                                              top: 5,
                                              right: 5,
                                              child: Icon(
                                                Icons.check_circle,
                                                color: Colors.pinkAccent,
                                                size: 20,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              if (signUpPressed && !isGenderSelected())
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Please choose your gender',
                                      style: TextStyle(
                                        color: Color(
                                            0XFFD33131), // Set the error text color
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(
                                height: 15,
                              ),
                              Center(
                                child: SizedBox(
                                  width: 335,
                                  height: 58,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0XFF007AFF),
                                      // Set the background color to grey
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        signUpPressed =
                                            true; // Set the sign-up button as pressed
                                      });
                                      _saveProfile(); // Call the save profile method
                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
