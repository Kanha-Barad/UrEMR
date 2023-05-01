import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Controllers/cart_controller.dart';
import '../Controllers/order_controller.dart';
import '../Coupons.dart';
import '../Notification.dart';
import '../OrdersHistory.dart';
import '../PatientHome.dart';
import 'package:badges/badges.dart' as badges;
import '../Widgets/cart_items.dart';
import 'dart:convert';
import '../globals.dart' as globals;
import 'package:http/http.dart' as http;

var functionCalls = "";
List data = [];

class CartScreen extends StatefulWidget {
  CartScreen() {}

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DateTime selectedDate = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        globals.selectDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  var _selectedItem;
  @override
  Widget build(BuildContext context) {
    late Map<String, dynamic> map;
    late Map<String, dynamic> params;
    functionCalls = "";

    getSWData() async {
      params = {
        "IP_SESSION_ID": globals.Session_ID,
        "connection": globals.Patient_App_Connection_String,
      };

      final response = await http.post(
          Uri.parse(globals.Global_Patient_Api_URL +
              '/PatinetMobileApp/Location_list'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: params,
          encoding: Encoding.getByName("utf-8"));

      print('im here');
      print(response.body);
      map = json.decode(response.body);
      print(response.body);
      if (response.statusCode == 200) {
        functionCalls = "true";
      } else {
        functionCalls == "false";
      }
      setState(() {
        data = map["Data"] as List;
      });

      return "Sucess";
    }

    final locationDropdwon = SizedBox(
        width: 340,
        height: 48,
        child: Card(
          elevation: 2.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isDense: true,
                isExpanded: true,
                value: _selectedItem,
                hint: Text('Select Location'),
                onChanged: (value) {
                  setState(() {
                    _selectedItem = value;
                    globals.SelectedlocationId = _selectedItem;
                  });
                },
                items: data.map((ldata) {
                  return DropdownMenuItem(
                    child: Text(
                      ldata['LOCATION_NAME'].toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                    value: ldata['LOC_ID'].toString(),
                  );
                }).toList(),
                // style: TextStyle(color: Colors.black, fontSize: 20,fontFamily: "Montserrat"),
              ),
            ),
          ),
        ));

    if (data == "" || data.length == 0) {
      getSWData();
    }

    var cartController = Get.put(CartController());
    var orderController = Get.put(OrderController());

    SingleUserOrderPayments() async {
      if (globals.SelectedlocationId == "" ||
          globals.SelectedlocationId == "0") {
        return Fluttertoast.showToast(
            msg: "Please Select the Location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 220, 91, 26),
            textColor: Colors.white,
            fontSize: 16.0);
      }
      var cartController = Get.put(CartController());
      var orderController = Get.put(OrderController());
      String test_ids = '';
      String test_amount = '';
      String test_concession = '';
      String Test_net = "";
      int i;
      // var cartController = Get.put(CartController());
      var dataset = null;
      cartController.items.forEach((key, cartItem) {
        test_ids += cartItem.Service_Id.toString() + ',';
        test_amount += cartItem.price.toString() + ',';
        if (globals.GlobalDiscountCoupons.toString() == "") {
          globals.GlobalDiscountCoupons = "0";
        }
        test_concession += globals.GlobalDiscountCoupons.toString() + ',';
        Test_net += (double.parse(cartItem.price.toString()) -
                    double.parse(globals.GlobalDiscountCoupons.toString()))
                .toString() +
            ',';
      });
      // dataset = cartController.items;
      // for (i = 0; i <= dataset.length; i++) {
      //   test_ids += dataset[i];
      // }
      if (globals.Discount_Amount_Coupon == "" ||
          globals.Discount_Amount_Coupon == null) {
        globals.Discount_Amount_Coupon = "0";
      }
      if (globals.Coupon_Policy_Id == "" || globals.Coupon_Policy_Id == null) {
        globals.Coupon_Policy_Id = "0";
      }
      Map data = {
        "PATIENT_ID": "1",
        "UMR_NO": globals.umr_no,
        "TEST_IDS": test_ids,
        "TEST_AMOUNTS": test_amount,
        "CONSESSION_AMOUNT": globals.Discount_Amount_Coupon.toString(),
        "BILL_AMOUNT": cartController.totalAmount.toStringAsFixed(0),
        "DUE_AMOUNT": cartController.totalAmount.toStringAsFixed(0),
        "MOBILE_NO": globals.mobNO,
        "MOBILE_REG_FLAG": "y",
        "SESSION_ID": globals.Session_ID,
        "PAYMENT_MODE_ID": "1",
        "IP_NET_AMOUNT": cartController.totalAmount.toStringAsFixed(0),
        "IP_TEST_CONCESSION": test_concession,
        "IP_TEST_NET_AMOUNTS": Test_net,
        "IP_POLICY_ID": globals.Coupon_Policy_Id,
        "IP_PAID_AMOUNT": "0",
        "IP_OUTSTANDING_DUE": cartController.totalAmount.toStringAsFixed(0),
        "connection": globals.Patient_App_Connection_String,
        "loc_id": globals.SelectedlocationId,
        "IP_SLOT": globals.Slot_id,
        "IP_DATE": "${selectedDate.toLocal()}".split(' ')[0],
        //"Server_Flag":""
      };

      final jobsListAPIUrl = Uri.parse(
          globals.Global_Patient_Api_URL + '/PatinetMobileApp/NewRegistration');

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
        globals.Bill_No = resposne["Data"][0]["BILL_NO"].toString();
        globals.SelectedlocationId = "";
        // globals.Preferedsrvs = jsonDecode(response.body);

        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Booked Successfully! ${globals.Bill_No}'),
          backgroundColor: Color.fromARGB(255, 26, 177, 122),
          action: SnackBarAction(
            label: "View",
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => notifiCation()));
              cartController.clear();
              productcontroller.resetAll();
              globals.GlobalDiscountCoupons = "";
            },
          ),
          duration: const Duration(seconds: 15),
          //width: 320.0, // Width of the SnackBar.
          padding: const EdgeInsets.symmetric(
            horizontal: 4.0, // Inner padding for SnackBar content.
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ));
        // return showDialog<String>(
        //     context: context,
        //     builder: (BuildContext context) =>
        //         // {
        //         //   Future.delayed(Duration(seconds: 10), () {
        //         //     Navigator.of(context).pop(true);
        //         //   });
        //         //   return
        //         WillPopScope(
        //           onWillPop: () async {
        //             return false;
        //           },
        //           child: AlertDialog(
        //             shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.all(Radius.circular(16.0))),
        //             //  title: const Text('Ordered Sucessfully'),
        //             content: Column(
        //               mainAxisSize: MainAxisSize.min,
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               children: <Widget>[
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                   children: [
        //                     Text(
        //                       'Booked Sucessfully',
        //                       style: TextStyle(
        //                         fontSize: 18,
        //                       ),
        //                     ),
        //                     Icon(Icons.verified_rounded,
        //                         color: Colors.green, size: 25),
        //                   ],
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.fromLTRB(16, 8, 0, 4),
        //                   child: Row(
        //                     children: [
        //                       Text("Your Booking Id : " + globals.Bill_No),
        //                     ],
        //                   ),
        //                 )
        //               ],
        //             ),
        //             actions: <Widget>[
        //               Padding(
        //                 padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        //                 child: Row(
        //                   children: [
        //                     InkWell(
        //                       onTap: () {
        //                         Navigator.push(
        //                             context,
        //                             MaterialPageRoute(
        //                                 builder: (context) => PatientHome()));
        //                         cartController.clear();
        //                         productcontroller.resetAll();
        //                         globals.GlobalDiscountCoupons = '';
        //                       },
        //                       // textColor: Theme.of(context).primaryColor,
        //                       child: Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Text('Home',
        //                             style: TextStyle(
        //                               color: Color.fromARGB(255, 30, 78, 122),
        //                               fontWeight: FontWeight.w500,
        //                               fontSize: 14,
        //                             )),
        //                       ),
        //                     ),
        //                     Spacer(),
        //                     InkWell(
        //                       onTap: () {
        //                         Navigator.push(
        //                             context,
        //                             MaterialPageRoute(
        //                                 builder: (context) =>
        //                                     OredersHistory()));
        //                         cartController.clear();
        //                         productcontroller.resetAll();
        //                         globals.GlobalDiscountCoupons = '';
        //                       },
        //                       // textColor: Theme.of(context).primaryColor,
        //                       child: Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Text('Go to Orders',
        //                             style: TextStyle(
        //                               color: Color.fromARGB(255, 30, 78, 122),
        //                               fontWeight: FontWeight.w500,
        //                               fontSize: 14,
        //                             )),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ));

        // return jsonResponse
        //     .map((managers) => PreferredServices.fromJson(managers))
        //     .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_rounded, color: Colors.white)),
          backgroundColor: Color(0xff123456),
          title: Text("Test Cart", style: TextStyle(color: Colors.white)),
          actions: [
            GetBuilder<CartController>(
                init: CartController(),
                builder: (contex) {
                  return badges.Badge(
                    position: BadgePosition.topStart(start: 1, top: 2),
                    child: IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Get.to(() => CartScreen());
                        }),
                    badgeContent: Text(
                      cartController.itemCount.toString(),
                    ),

                    // color: Color.fromARGB(255, 27, 165, 114),
                  );
                })
          ],
        ),
        body: GetBuilder<CartController>(
          init: CartController(),
          builder: (cont) => Container(
            color: Color.fromARGB(220, 241, 241, 241),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      itemCount: cartController.items.length,
                      itemBuilder: (context, index) => CartItem(
                          cartController.items.values.toList()[index].id,
                          cartController.items.values.toList()[index].price,
                          cartController.items.values.toList()[index].quantity,
                          cartController.items.values.toList()[index].title,
                          cartController.items.values
                              .toList()[index]
                              .Service_Id,
                          cartController.items.keys.toList()[index])),
                ),
                globals.Location_BookedTest == ""
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(17, 0, 0, 0),
                            child: Text(
                              'Offers & Benifits',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                globals.Location_BookedTest == ""
                    ? InkWell(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0.0, 9, 8.0),
                          child: Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Apply Coupon',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          globals.SelectedlocationId = "";
                          _CouponsBottomPicker(context);
                        })
                    : Container(),
                globals.Location_BookedTest == ""
                    ? locationDropdwon
                    : Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: 120,
                          width: 340,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 16.0, right: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 150,
                                        child: Text(
                                          "Slot Date And Time:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    globals.selectDate == ""
                                        ? Text(
                                            "${selectedDate.toLocal()}"
                                                .split(' ')[0],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            globals.selectDate,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                    Text("/"),
                                    Text(
                                      globals.SlotsBooked,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 16.0, right: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 150,
                                        child: Text("Location:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    Text(globals.Location_BookedTest,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                globals.Location_BookedTest == ""
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(17, 4, 0, 0),
                                child: Text(
                                  'Payments Instruction',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                              onTap: () {
                                // Navigator.push(
                                //     context, MaterialPageRoute(builder: (context) => CartScreen()));
                              },
                              child: GetBuilder<CartController>(
                                  init: CartController(),
                                  builder: (cont) => SizedBox(
                                        height: 120,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0.0, 8, 0.0),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            color: Colors.white,
                                            // margin: EdgeInsets.all(15),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Total Amount :',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Text(
                                                        '\u{20B9} ' +
                                                            '${cartController.totalAmount.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Discount Amount :',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      (globals.Discount_Amount_Coupon
                                                                      .toString() ==
                                                                  null ||
                                                              globals.Discount_Amount_Coupon
                                                                      .toString() ==
                                                                  "null")
                                                          ? Text(
                                                              '\u{20B9} ' + '0',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )
                                                          : Text(
                                                              '\u{20B9} ' +
                                                                  globals.Discount_Amount_Coupon
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Net. Amount :',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      (globals.Net_Amount_Coupon
                                                                      .toString() ==
                                                                  null ||
                                                              globals.Net_Amount_Coupon
                                                                      .toString() ==
                                                                  "null")
                                                          ? Text(
                                                              '\u{20B9} ' + '0',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )
                                                          : Text(
                                                              '\u{20B9} ' +
                                                                  globals.Net_Amount_Coupon
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        height: 40,
                                                        width: 120,
                                                        child: Card(
                                                          color: Color.fromARGB(
                                                              255,
                                                              27,
                                                              165,
                                                              114),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              //  OrderPayments();
                                                              //    _buildUserBookingPopup(context);
                                                              (globals.selectedLogin_Data["Data"].length >
                                                                      1)
                                                                  ? _UserListBookingsBottomPicker(
                                                                      context)
                                                                  : (globals.Booking_Status_Flag ==
                                                                          "0")
                                                                      ? Fluttertoast.showToast(
                                                                          msg:
                                                                              "Booking InProgress",
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,
                                                                          gravity: ToastGravity
                                                                              .CENTER,
                                                                          timeInSecForIosWeb:
                                                                              1,
                                                                          backgroundColor: Color.fromARGB(
                                                                              230,
                                                                              228,
                                                                              55,
                                                                              32),
                                                                          textColor: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16.0)
                                                                      : SingleUserOrderPayments();
                                                              // cartController.clear();
                                                              // productcontroller.resetAll();
                                                              // Navigator.pop(context, true);
                                                            },
                                                            child: Text(
                                                              'Pay Later',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 40,
                                                        width: 120,
                                                        child: Card(
                                                          color: Color.fromARGB(
                                                              255,
                                                              27,
                                                              165,
                                                              114),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              //  OrderPayments();
                                                              //    _buildUserBookingPopup(context);
                                                              // (globals
                                                              //             .selectedLogin_Data[
                                                              //                 "Data"]
                                                              //             .length >
                                                              //         1)
                                                              //     ? _UserListBookingsBottomPicker(
                                                              //         context)
                                                              //     : OrderPayments();
                                                              // cartController.clear();
                                                              // productcontroller.resetAll();
                                                              // Navigator.pop(context, true);
                                                            },
                                                            child: Text(
                                                              'Pay Now',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )))
                        ],
                      )
                    : Container(
                        color: Color(0xff123456),
                        width: 350,
                        child: TextButton(
                            onPressed: () {
                              //  OrderPayments();
                              //    _buildUserBookingPopup(context);
                              (globals.selectedLogin_Data["Data"].length > 1)
                                  ? _UserListBookingsBottomPicker(context)
                                  : (globals.Booking_Status_Flag == "0")
                                      ? Fluttertoast.showToast(
                                          msg: "Booking InProgress",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                              Color.fromARGB(230, 228, 55, 32),
                                          textColor: Colors.white,
                                          fontSize: 16.0)
                                      : SingleUserOrderPayments();
                              // cartController.clear();
                              // productcontroller.resetAll();
                              // Navigator.pop(context, true);
                            },
                            child: Center(
                                child: Text(
                              "OK",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                            ))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// GrossPaymentCard(BuildContext context) {
//   var cartController = Get.put(CartController());
//   var orderController = Get.put(OrderController());

//   return
// }

_UserListBookingsBottomPicker(BuildContext context) {
  var res = showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
          // color: Color.fromARGB(255, 236, 235, 235),
          height: MediaQuery.of(context).size.height * 0.4,
          child: UserlistBottomPopup()
          // UserListBookings(globals.selectedLogin_Data, context),
          ));
  print(res);
}

class UserlistBottomPopup extends StatefulWidget {
  const UserlistBottomPopup({Key? key}) : super(key: key);

  @override
  State<UserlistBottomPopup> createState() => _UserlistBottomPopupState();
}

class _UserlistBottomPopupState extends State<UserlistBottomPopup> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              )),
          // automaticallyImplyLeading: false,
          title: Text('User List', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xff123456),
        ),
        body: UserListBookings(globals.selectedLogin_Data, context),
      ),
    );
  }
}

ListView UserListBookings(var data, BuildContext contex) {
  var myData = data["Data"].length;
  return ListView.builder(
      itemCount: myData,
      scrollDirection: Axis.vertical,
      //  globals.selectedLogin_Data["Data"].length
      itemBuilder: (context, index) {
        return Container(
            //  color: Color.fromARGB(255, 236, 235, 235),
            // height: MediaQuery.of(context).size.height * 0.16,
            child: userBookings(data["Data"][index], index, context));
      });
}

Widget userBookings(
  data,
  index,
  context,
) {
  MultiUserOrderPayments() async {
    DateTime selectedDate = DateTime.now();
    if (globals.SelectedlocationId == "" || globals.SelectedlocationId == "0") {
      return Fluttertoast.showToast(
          msg: "Select the Location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 220, 91, 26),
          textColor: Colors.white,
          fontSize: 16.0);
    }
    var cartController = Get.put(CartController());
    var orderController = Get.put(OrderController());
    String test_ids = '';
    String test_amount = '';
    String test_concession = '';
    String Test_net = "";
    int i;
    var dataset = null;
    cartController.items.forEach((key, cartItem) {
      test_ids += cartItem.Service_Id.toString() + ',';
      test_amount += cartItem.price.toString() + ',';
      if (globals.GlobalDiscountCoupons.toString() == "") {
        globals.GlobalDiscountCoupons = "0";
      }
      test_concession += globals.GlobalDiscountCoupons.toString() + ',';
      Test_net += (double.parse(cartItem.price.toString()) -
                  double.parse(globals.GlobalDiscountCoupons.toString()))
              .toString() +
          ',';
    });

    if (globals.Discount_Amount_Coupon == "" ||
        globals.Discount_Amount_Coupon == null) {
      globals.Discount_Amount_Coupon = "0";
    }
    if (globals.Coupon_Policy_Id == "" || globals.Coupon_Policy_Id == null) {
      globals.Coupon_Policy_Id = "0";
    }

    Map data = {
      "PATIENT_ID": "1",
      "UMR_NO": globals.umr_no,
      "TEST_IDS": test_ids,
      "TEST_AMOUNTS": test_amount,
      "CONSESSION_AMOUNT": globals.Discount_Amount_Coupon.toString(),
      "BILL_AMOUNT": cartController.totalAmount.toStringAsFixed(0),
      "DUE_AMOUNT": cartController.totalAmount.toStringAsFixed(0),
      "MOBILE_NO": globals.mobNO,
      "MOBILE_REG_FLAG": "y",
      "SESSION_ID": globals.Session_ID,
      "PAYMENT_MODE_ID": "1",
      "IP_NET_AMOUNT": cartController.totalAmount.toStringAsFixed(0),
      "IP_TEST_CONCESSION": test_concession,
      "IP_TEST_NET_AMOUNTS": Test_net,
      "IP_POLICY_ID": globals.Coupon_Policy_Id,
      "IP_PAID_AMOUNT": "0",
      "IP_OUTSTANDING_DUE": cartController.totalAmount.toStringAsFixed(0),
      "loc_id": globals.SelectedlocationId,
      "IP_SLOT": globals.Slot_id,
      "IP_DATE": "${selectedDate.toLocal()}".split(' ')[0],
      "connection": globals.Patient_App_Connection_String,
    };

    final jobsListAPIUrl = Uri.parse(
        globals.Global_Patient_Api_URL + '/PatinetMobileApp/NewRegistration');

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
      globals.Bill_No = resposne["Data"][0]["BILL_NO"].toString();
      globals.Slot_id = "";
      globals.SelectedlocationId = "";

      globals.SelectedlocationId = "";
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Booked Successfully! ${globals.Bill_No}'),
        backgroundColor: Color.fromARGB(255, 26, 177, 122),
        action: SnackBarAction(
          label: "View",
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => notifiCation()));
            cartController.clear();
            productcontroller.resetAll();
            globals.GlobalDiscountCoupons = "";
          },
        ),
        duration: const Duration(seconds: 15),
        //width: 320.0, // Width of the SnackBar.
        padding: const EdgeInsets.symmetric(
          horizontal: 4.0, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ));
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  return InkWell(
    onTap: () {
      globals.umr_no = data["UMR_NO"].toString();
      if (globals.Booking_Status_Flag == "0") {
        Fluttertoast.showToast(
            msg: "Booking InProgress",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(230, 228, 55, 32),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        MultiUserOrderPayments();
        // _onLoading();
      }
    },
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
          child: Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            child: Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.account_circle_rounded,
                        color: Colors.indigoAccent,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 1, 0, 3),
                      child: Text(
                        data["DISPLAY_NAME"].toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 1, 0, 2),
                      child: Text(
                        data["UMR_NO"].toString(),
                        style: TextStyle(fontSize: 14, color: Colors.red[400]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

_CouponsBottomPicker(BuildContext context) {
  var res = showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
          // color: Color.fromARGB(255, 236, 235, 235),
          height: MediaQuery.of(context).size.height * 0.8,
          child: CouponsCardApply()
          // UserListBookings(globals.selectedLogin_Data, context),
          ));
  print(res);
}
