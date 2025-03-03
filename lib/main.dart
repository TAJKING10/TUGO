import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';

// Import screens
import 'components/datepicker/booking.dart';
import 'Partner/OTP(Partner).dart';
import 'Partner/PartnerSignupScreen.dart';
import 'Partner/editProfileScreen(Partner).dart';
import 'Customer/editProfileScreen.dart';
import 'Customer/homeScreen.dart';
import 'Customer/navigationBar.dart';
import 'Partner/navigationbarPartnerSide.dart';
import 'Customer/CustomersettingProfileScreen.dart';
import 'Partner/settingsScreen(Partner).dart';
import 'Customer/Settings/settingsScreen.dart';
import 'Screens/welcomeScreen.dart';
import 'Screens/loginScreen.dart';
import 'Customer/CustomersignupScreen.dart';
import 'Customer/OTP.dart';
import 'Screens/forgetPassword.dart';
import 'Screens/choosingAccType.dart';
import 'Partner/dashboard(partner).dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  // Load environment variables
  await dotenv.load(fileName: ".env"); // Load the .env file

  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '', // Get the API key from .env
      appId: '1:380017587052:android:1d4e5baa808058b3743949', // Add other Firebase options as needed
      messagingSenderId: '380017587052',
      projectId: 'tugo-8adb2',
    ),
  );

  runApp(Tugo());
}


class Tugo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final prefs = snapshot.data;
            bool isCustomerLoggedIn = prefs?.getBool('isCustomerLoggedIn') ?? false;
            bool isPartnerLoggedIn = prefs?.getBool('isPartnerLoggedIn') ?? false;

            String initialRoute = isCustomerLoggedIn
                ? Navigation_Bar.id
                : isPartnerLoggedIn
                ? Navigation_Bar_Partner_Side.id
                : WelcomeScreen.id;

            return Navigator(
              initialRoute: initialRoute,
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case WelcomeScreen.id:
                    return MaterialPageRoute(builder: (_) => WelcomeScreen());
                  case LoginScreen.id:
                    return MaterialPageRoute(builder: (_) => LoginScreen());
                  case CustomerSignupScreen.id:
                    return MaterialPageRoute(builder: (_) => CustomerSignupScreen());
                  case Navigation_Bar.id:
                    return MaterialPageRoute(builder: (_) => Navigation_Bar());
                  case Navigation_Bar_Partner_Side.id:
                    return MaterialPageRoute(builder: (_) => Navigation_Bar_Partner_Side());
                  default:
                    return MaterialPageRoute(
                        builder: (_) => Scaffold(
                          body: Center(
                              child: Text('Invalid route: ${settings.name}')),
                        ));
                }
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
