import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './PatientHome.dart';
import './ClientCodeLogin.dart';
import 'Cartprovider.dart';
import 'globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  // Handle the notification permission response
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // User granted permission to display notifications
    print('Notification permission granted');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    // User granted provisional permission to display notifications (iOS 15+)
    print('Provisional notification permission granted');
  } else {
    // User denied permission to display notifications
    print('Notification permission denied');
  }
  runApp(PatientApp());
}

class PatientApp extends StatefulWidget {
  const PatientApp({Key? key}) : super(key: key);
  @override
  State<PatientApp> createState() => _PatientAppState();
}

class _PatientAppState extends State<PatientApp> {
  @override
  Future<bool> setUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AppCODE') != "" &&
        prefs.getString('AppCODE') != null) {
      globals.Client_App_Code = (prefs.getString('AppCODE') ?? '');
      globals.Global_Patient_Api_URL =
          (prefs.getString('PatientAppApiURL') ?? '');
      globals.Patient_App_Connection_String =
          (prefs.getString('ConnectionString') ?? '');
      globals.All_Client_Logo = (prefs.getString('CompanyLogo') ?? '');
      globals.Patient_report_URL = (prefs.getString('ReportURL') ?? '');
      globals.Patient_OTP_URL = (prefs.getString('OTPURL') ?? '');
    }
    setState(() {});
    return true;
  }

  void initState() {
    setUserStatus();
  }

  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => CartProvider()), // Your CartProvider
          // Add more providers here if needed
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.grey,
            accentColor: Color(0xff123456),
            //  primaryColor: Color(0xff123456)
          ),
          home:
              (globals.Client_App_Code != "" && globals.Client_App_Code != null)
                  ? PatientHome()
                  : AccessClientCodeLogin(),
        ));
  }
}


// if (Platform.isIOS) {
//     await Firebase.initializeApp(
//         options: const FirebaseOptions(
//             apiKey: "AIzaSyBZEGRMcioR0I5QDERsJKKMWZk690MgFQA",
//             appId: "1:672492402457:ios:eecf5827b567ccb7acf788",
//             messagingSenderId: "672492402457",
//             projectId: "suvarna-crm")
//     );
//   }
//   else {
//     await Firebase.initializeApp(
//         options: const FirebaseOptions(
//             apiKey: "AIzaSyAhxDQpeF9G3a4BPWJ_8nYIF1B4E1h9KNM",
//             appId: "1:672492402457:android:02183fb219c6b912acf788",
//             messagingSenderId: "672492402457",
//             projectId: "suvarna-crm")
//     );
//   }