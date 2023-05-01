import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './PatientHome.dart';
import './ClientCodeLogin.dart';
import 'globals.dart' as globals;

void main() async {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        accentColor: Color(0xff123456),
        //  primaryColor: Color(0xff123456)
      ),
      home: (globals.Client_App_Code != "" && globals.Client_App_Code != null)
          ? PatientHome()
          : AccessClientCodeLogin(),
    );
  }
}
