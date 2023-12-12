import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './PatientHome.dart';
import 'Cartprovider.dart';
import 'package:device_info/device_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

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
  bool isRooted = await isDeviceRooted();
  if (isRooted) {
    print('Rooted device detected. App functionality limited.');
    runApp(MyApp(
      isRooted: isRooted,
    ));
  } else {
    runApp(PatientApp());
  }
}

Future<bool> isDeviceRooted() async {
  bool isRooted = false;

  try {
    // Check for the existence of common root-related directories
    List<String> rootDirs = [
      '/sbin/',
      '/system/bin/',
      '/system/xbin/',
      '/data/local/xbin/',
      '/data/local/bin/',
      '/system/sd/xbin/'
    ];

    for (String dir in rootDirs) {
      Directory directory = Directory(dir);
      if (await directory.exists()) {
        isRooted = true;
        break;
      }
    }
  } catch (e) {
    print("Error checking root status: $e");
  }

  return isRooted;
}

class PatientApp extends StatefulWidget {
  const PatientApp({Key? key}) : super(key: key);
  @override
  State<PatientApp> createState() => _PatientAppState();
}

class _PatientAppState extends State<PatientApp> {
  // Future<bool> setUserStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getString('AppCODE') != "" &&
  //       prefs.getString('AppCODE') != null) {
  //     globals.Client_App_Code = (prefs.getString('AppCODE') ?? '');
  //     globals.Global_Patient_Api_URL =
  //         (prefs.getString('PatientAppApiURL') ?? '');
  //     globals.Patient_App_Connection_String =
  //         (prefs.getString('ConnectionString') ?? '');
  //     globals.All_Client_Logo = (prefs.getString('CompanyLogo') ?? '');
  //     globals.Patient_report_URL = (prefs.getString('ReportURL') ?? '');
  //     globals.Patient_OTP_URL = (prefs.getString('OTPURL') ?? '');
  //   }
  //   setState(() {});
  //   return true;
  // }

  // void initState() {
  //   setUserStatus();
  // }

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
            home: PatientHome()
            // (globals.Client_App_Code != "" && globals.Client_App_Code != null)
            //     ? PatientHome()
            //     : AccessClientCodeLogin(),
            ));
  }

  // Future<bool> performRootChecks() async {
  //   bool isRooted = false;

  //   // Perform different root detection methods here
  //   isRooted = await checkSystemProperties() ||
  //       await checkRootFiles() ||
  //       await checkSafetyNetAttestation();

  //   return isRooted;
  // }

  // Future<bool> checkSystemProperties() async {
  //   try {
  //     final String buildTags =
  //         await MethodChannel('device_info').invokeMethod('getBuildTags');
  //     if (buildTags != null && buildTags.contains("test-keys")) {
  //       // Device likely rooted
  //       return true;
  //     }
  //   } on PlatformException catch (e) {
  //     print("Error checking system properties: $e");
  //   }

  //   return false; // Not rooted or unable to check system properties
  // }

  // Future<bool> checkRootFiles() async {
  //   List<String> pathsToCheck = [
  //     "/sbin/su",
  //     "/system/bin/su",
  //     "/system/xbin/su",
  //     "/data/local/xbin/su",
  //     "/data/local/bin/su",
  //     "/system/sd/xbin/su",
  //     "/system/bin/failsafe/su",
  //     "/data/local/su",
  //     "/su/bin/su"
  //     // Add more paths to check for common root files or directories
  //   ];

  //   for (final path in pathsToCheck) {
  //     if (await File(path).exists()) {
  //       // Rooted files detected
  //       return true;
  //     }
  //   }

  //   return false; // Not rooted or no root files found
  // }

  // Future<bool> checkSafetyNetAttestation() async {
  //   try {
  //     final result =
  //         await MethodChannel('safetynet').invokeMethod('attestationCheck');
  //     // Process result from SafetyNet attestation
  //     // Determine if the device is rooted based on the attestation result
  //     return result['isDeviceRooted'] ?? false;
  //   } on PlatformException catch (e) {
  //     print("Error performing SafetyNet attestation: $e");
  //   }

  //   return false; // Unable to perform SafetyNet attestation or error occurred
  // }
}

class MyApp extends StatelessWidget {
  final bool isRooted;

  const MyApp({Key? key, required this.isRooted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          accentColor: Color(0xff123456),
        ),
        home: RootedDeviceDefaultScreen()
        //isRooted ? RootedDeviceScreen() : PatientApp(),
        );
  }
}

class RootedDeviceDefaultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(16.0),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/EMRAccessCodeLogo.png",
                  height: 60,
                  width: 70,
                ),
                //SizedBox(height: 16),
                // Text(
                //   'Rooted Device Detected',
                //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                // ),
                SizedBox(height: 16),
                Flexible(
                  child: Text(
                    'For security reasons, rooted devices are not supported. Please use a non-rooted device to access the app.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, color: Colors.red, height: 1.4),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Visit the Google Play Store for more information.',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(
                        255, 36, 108, 166), // Set the background color here
                  ),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white, // Set the text color here
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });

    // Return an empty container or any other widget as a placeholder for the build method.
    return Container();
  }
}



// Future<bool> isDeviceRooted() async {
//   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

//   try {
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

//     if (androidInfo.isPhysicalDevice) {
//       AndroidBuildVersion buildVersion = androidInfo.version;

//       if (buildVersion.sdkInt >= 20) {
//         return false;
//       }
//     }
//   } catch (e) {
//     print("Error checking root status: $e");
//   }

//   return true;
// }
//  "/sbin/su",
//         "/system/bin/su",
//         "/system/xbin/su",
//         "/data/local/xbin/su",
//         "/data/local/bin/su",
//         "/system/sd/xbin/su",
//         "/system/bin/failsafe/su",
//         "/data/local/su",
//         "/su/bin/su"
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