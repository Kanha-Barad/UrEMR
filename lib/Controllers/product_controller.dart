import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/product.dart';
import '../globals.dart' as globals;
import 'package:http/http.dart' as http;

List<Product> _items = [];
var values = [];

class ProductController extends GetxController {
  TextEditingController searchController = TextEditingController();

  var productList = <Product>[].obs;
  var productTempList = <Product>[];
  var totalAmount = RxDouble(0);

  RxBool isAdded = RxBool(false);
  setIsAdded(bool value) => isAdded.value = value;

  RxBool isFavourite = RxBool(false);
  setIsFavourite(bool value) => isFavourite.value = value;
  @override
  void onInit() {
    super.onInit();

    var values = [];
    if (globals.Preferedsrvs != null) {
      for (int i = 0; i <= globals.Preferedsrvs["Data"].length - 1; i++) {
        _items.add(Product(
            id: i + 1,
            title: globals.Preferedsrvs["Data"][i]["SERVICE_NAME"].toString(),
            //    description: "",
            //  quantity: Product.quantity + 1,
            price: globals.Preferedsrvs["Data"][i]["PRICE"],
            Service_Id: globals.Preferedsrvs["Data"][i]["SERVICE_ID"],
            Service_Type_Id: globals.Preferedsrvs["Data"][i]
                ["SERVICE_TYPE_ID"]));
      }
    }

    var productData = _items;
    //Store data
    productList.value = productData;
    productTempList = productData;
  }

  productNameSearch(String name) {
    if (name.isEmpty) {
      productList.value = productTempList;
      //update();
    } else {
      productList.value = productTempList
          .where((element) =>
              element.title.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
  }

  List<Product> get items {
    return [..._items];
  }

  void resetAll() {
    for (int i = 0; i < items.length; i++) {
      items[i + 1].isAdded.value = false;
    }
  }

  List<Product> get favouriteItems {
    return _items
        .where((productItem) => productItem.isFavourite.value)
        .toList();
  }

  Product findProductById(int id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addProduct() {
    update();
  }

  void toggleFavouriteStatus(int id) {
    items[id].isFavourite.value = !items[id].isFavourite.value;
  }

  void toggleAddRemove(int id) {
    items[id].isAdded.value = !items[id].isAdded.value;
    // items[id].isRemoved.value = !items[id].isRemoved.value;
  }
}

bookCart() async {
  Map data = {
    "connection": globals.Patient_App_Connection_String
    //  "employee_id": "",
    // "mobile": globals.mobNO,
    //  "session_id": globals.sesson_Id
    //"Server_Flag":""
  };

  final jobsListAPIUrl = Uri.parse(
      globals.Global_Patient_Api_URL + '/PatinetMobileApp/PreferedServices');

  var response = await http.post(jobsListAPIUrl,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    Map<String, dynamic> resposne = jsonDecode(response.body);
    List jsonResponse = resposne["Data"];
    globals.Preferedsrvs = jsonDecode(response.body);

    // return jsonResponse
    //     .map((managers) => PreferredServices.fromJson(managers))
    //     .toList();
  } else {
    throw Exception('Failed to load jobs from API');
  }
}
