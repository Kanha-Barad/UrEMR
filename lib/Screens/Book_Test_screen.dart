import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uremr/Widgets/BottomNavigation.dart';
import '../ClientCodeLogin.dart';
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

    Get.put(ProductController());
    Get.put(CartController());

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xff123456),
          title: Text('Book A Test', style: TextStyle(color: Colors.white)),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ))

          // Builder(
          //   builder: (context) => IconButton(
          //     icon: Icon(Icons.menu_rounded, color: Colors.white),
          //     onPressed: () => Scaffold.of(context).openDrawer(),
          //   ),
          // ),
          ),
      endDrawer: AppDrawer(),
      body: (!_showOnlyFavourites)
          ? ProductsGrid(_showOnlyFavourites)
          : Text('Done'),
      bottomNavigationBar: AllBottOMNaviGAtionBar(),
    );
  }
}
