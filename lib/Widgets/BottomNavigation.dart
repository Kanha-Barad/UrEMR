import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uremr/ClientCodeLogin.dart';

import '../Cartprovider.dart';
import '../PatientHome.dart';
import '../PatientLogin.dart';
import '../Reports.dart';
import '../TestBooking.dart';
import '../UserProfile.dart';
import '../globals.dart' as globals;

class AllBottOMNaviGAtionBar extends StatefulWidget {
  const AllBottOMNaviGAtionBar({super.key});

  @override
  State<AllBottOMNaviGAtionBar> createState() => _AllBottOMNaviGAtionBarState();
}

class _AllBottOMNaviGAtionBarState extends State<AllBottOMNaviGAtionBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 150,
        width: MediaQuery.of(context).size.width,
        height: 63,
        color: Color(0xff123456),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: InkWell(
                  onTap: () {
                    globals.SelectedlocationId = "";
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PatientHome()));
                    searchController.clear();
                    // Trigger a UI update by rebuilding the widget tree
                    context.read<CartProvider>().notifyListeners();
                  },
                  child: Column(children: [
                    Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(
                      "Home",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ]),
                ),
              ),
              InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  globals.selectedLogin_Data = (prefs.getString('data1') != "")
                      ? (jsonDecode(prefs.getString('data1') ?? ''))
                      : "";
                  if (prefs.getString('Mobileno') == "" ||
                      prefs.getString('Mobileno') == null ||
                      globals.selectedLogin_Data == null ||
                      globals.selectedLogin_Data == "") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PatientLogin("RF")),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RepoRTSBillWise()),
                    );
                  }
                  searchController.clear();
                  // Trigger a UI update by rebuilding the widget tree
                  context.read<CartProvider>().notifyListeners();
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      color: Colors.white,
                      size: 19,
                    ),
                    Text(
                      "Report",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  globals.selectedLogin_Data = (prefs.getString('data1') != "")
                      ? (jsonDecode(prefs.getString('data1') ?? ''))
                      : "";
                  if (prefs.getString('Mobileno') == "" ||
                      prefs.getString('Mobileno') == null ||
                      globals.selectedLogin_Data == null ||
                      globals.selectedLogin_Data == "") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PatientLogin("")),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UsersProfile()),
                    );
                  }
                  searchController.clear();
                  // Trigger a UI update by rebuilding the widget tree
                  context.read<CartProvider>().notifyListeners();
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 19,
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: InkWell(
                  onTap: () async {
                    // globals.umr_no = "";
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();
                    prefs.setString("Msg_id", "");
                    prefs.setString('Mobileno', "");

                    prefs.setString('email', "");
                    //     prefs.setString('Mobileno', MobNocontroller.text.toString()).toString();
                    prefs.setString("Otp", "");
                    // prefs.getStringList('data1') ?? [];
                    (prefs.setString('data1', ""));
                    (prefs.setString('AppCODE', ''));
                    (prefs.setString('CompanyLogo', ''));
                    (prefs.setString('ReportURL', ''));
                    (prefs.setString('OTPURL', ''));
                    (prefs.setString('PatientAppApiURL', ''));
                    (prefs.setString('ConnectionString', ''));
                    // (prefs.setString('Status_FLag', ''));
                    (prefs.setString('SeSSion_ID', ''));
                    (prefs.setString('singleUMr_No', ''));
                    (prefs.setString('data1', ''));
                    searchController.clear();
                    prefs.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PatientLogin("")),
                    );
                    // Trigger a UI update by rebuilding the widget tree
                    context.read<CartProvider>().notifyListeners();
                  },
                  child: Column(children: [
                    Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(
                      "Log Out",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ]),
                ),
              )
            ],
          ),
        ));
  }
}
