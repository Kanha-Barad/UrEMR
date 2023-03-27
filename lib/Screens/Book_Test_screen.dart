import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/cart_controller.dart';
import '../Controllers/product_controller.dart';
import 'Test_Cart_screen.dart';
import '../Widgets/BookTestDrawer.dart';

import '../Widgets/Book_Test.dart';
import '../Widgets/Test_Search.dart';
import '../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../PatientHome.dart';
import '../PatientLogin.dart';
import '../UserProfile.dart';

enum FilterOptions {
  FAVOURITES,
  ALL,
}

class ProductOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _showOnlyFavourites = false;
    //  bookCart();

    final controller = Get.put(ProductController());
    final cartController = Get.put(CartController());

    Widget myBottomNavigationBar = Container(
        // height: 150,
        width: MediaQuery.of(context).size.width,
        height: 48,
        color: Color(0xff123456),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PatientHome()));
                },
                child: Column(children: [
                  Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Home",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UsersProfile()),
                  );
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 30, 0),
              child: InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
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
                  if (prefs.getString('Mobileno') != "") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PatientLogin("")),
                    );
                  }
                },
                child: Column(children: [
                  Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Log Out",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )
                ]),
              ),
            )
          ],
        ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff123456),
        title: Text('Book A Test', style: TextStyle(color: Colors.white)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: (!_showOnlyFavourites)
          ? ProductsGrid(_showOnlyFavourites)
          : Text('Done'),
      bottomNavigationBar: myBottomNavigationBar,
    );
  }
}
