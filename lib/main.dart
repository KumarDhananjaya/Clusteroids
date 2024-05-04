import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "Clusteroids",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. debug provider
    // 2. safety net provider
    // 3. play integrity provider
    androidProvider: AndroidProvider.debug,
  );
  runApp(ClusteroidsApp());
}

class ClusteroidsApp extends StatelessWidget {
  final Color _primaryColor = HexColor('#DC54FE');
  final Color _accentColor = HexColor('#8A02AE');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clustroids ',
      theme: ThemeData.from(colorScheme: ColorScheme.light(
        primary: _primaryColor,
        secondary: _accentColor,
      )).copyWith(
        scaffoldBackgroundColor: Colors.grey.shade100,
        // Optionally, you can set other theme properties here.
      ),
      home: LoginPage(),
    );
  }
}
