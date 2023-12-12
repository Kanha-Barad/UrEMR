import 'dart:convert';

import 'package:loading_indicator/loading_indicator.dart';

import './OrdersHistory.dart';
import './UserProfile.dart';

import 'TestBooking.dart';
import 'Widgets/BottomNavigation.dart';
import 'book_home_visit.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

import './PatientLogin.dart';
import './MyTrends.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Notification.dart';

class PatientHome extends StatefulWidget {
  const PatientHome({super.key});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  bool isLoading = true; // Step 1

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  _SaveOrderHIStroy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    globals.logindata1 = (prefs.getString('email') ?? '');
    globals.mobNO = (prefs.getString('Mobileno') ?? '');
    if (prefs.getString('data1') != null && prefs.getString('data1') != "") {
      Map<String, dynamic> resposne =
          (jsonDecode(prefs.getString('data1') ?? ''));
      globals.selectedLogin_Data = resposne;
    }
    if (globals.mobNO != "" && globals.mobNO != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => OredersHistory()));
    } else if (globals.mobNO == "") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PatientLogin("")));
    }
  }

  _SaveLoginDataTrends() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    globals.logindata1 = (prefs.getString('email') ?? '');
    globals.mobNO = (prefs.getString('Mobileno') ?? '');
    if (prefs.getString('data1') != null && prefs.getString('data1') != "") {
      Map<String, dynamic> resposne =
          (jsonDecode(prefs.getString('data1') ?? ''));
      globals.selectedLogin_Data = resposne;
    }

    if (globals.mobNO != "" && globals.mobNO != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyTrends()));
    } else if (globals.mobNO == "") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PatientLogin("T")));
    }
  }

  _SaveLoginDataBookATest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    globals.logindata1 = (prefs.getString('email') ?? '');
    globals.mobNO = (prefs.getString('Mobileno') ?? '');

    if (prefs.getString('data1') != null && prefs.getString('data1') != "") {
      Map<String, dynamic> resposne =
          (jsonDecode(prefs.getString('data1') ?? ''));
      globals.selectedLogin_Data = resposne;
    }
    if (globals.mobNO != "" && globals.mobNO != null) {
      // (globals.Session_ID != "0" &&
      //     globals.Session_ID != "" &&
      //     globals.Session_ID != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => bookATeSt("0")));
    } else if (globals.mobNO == "") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PatientLogin("B")));
    }
  }

  HomeVisitBook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    globals.logindata1 = (prefs.getString('email') ?? '');
    globals.mobNO = (prefs.getString('Mobileno') ?? '');
    if (prefs.getString('data1') != null && prefs.getString('data1') != "") {
      Map<String, dynamic> resposne =
          (jsonDecode(prefs.getString('data1') ?? ''));
      globals.selectedLogin_Data = resposne;
    }
    if (globals.mobNO != "" && globals.mobNO != null) {
      // (globals.Session_ID != "0" &&
      //     globals.Session_ID != "" &&
      //     globals.Session_ID != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Book_Home_Visit(0)));
    } else if (globals.mobNO == "") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PatientLogin("H")));
    }
  }

  InProgressNotofication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    globals.logindata1 = (prefs.getString('email') ?? '');
    globals.mobNO = (prefs.getString('Mobileno') ?? '');
    if (prefs.getString('data1') != null && prefs.getString('data1') != "") {
      Map<String, dynamic> resposne =
          (jsonDecode(prefs.getString('data1') ?? ''));
      globals.selectedLogin_Data = resposne;
    }
    if (globals.mobNO != "" && globals.mobNO != null) {
      // (globals.Session_ID != "0" &&
      //     globals.Session_ID != "" &&
      //     globals.Session_ID != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BookingINProgressNotification()));
    } else if (globals.mobNO == "") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PatientLogin("N")));
    }
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    Future<List<PreferredServices>> _fetchManagerDetails() async {
      Map data = {
        "IP_SESSION_ID": "0",
        "connection": globals.Patient_App_Connection_String,
        //  "employee_id": "",
        // "mobile": globals.mobNO,
        //  "session_id": globals.sesson_Id
        //"Server_Flag":""
      };
      final jobsListAPIUrl = Uri.parse(globals.Global_Patient_Api_URL +
          '/PatinetMobileApp/PreferedServices');

      var response = await http.post(jobsListAPIUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "Strict-Transport-Security": "max-age=31536000; includeSubDomains",
            "X-Content-Type-Options": "nosniff",
            "X-Frame-Options": "DENY",
            "X-XSS-Protection": "1; mode=block",
            "Content-Security-Policy":
                "default-src 'self'; script-src 'self' 'unsafe-inline';",
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        List jsonResponse = resposne["Data"];
        globals.Preferedsrvs = jsonDecode(response.body);

        return jsonResponse
            .map((managers) => PreferredServices.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget PreferredServicesDetails = Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<PreferredServices>>(
            future: _fetchManagerDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                return SizedBox(
                    child: PreferredServicesListView(data, context));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Container();
              // Center(
              //     child: const CircularProgressIndicator(
              //   strokeWidth: 4.0,
              // ));
            }));

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff123456),
          // backgroundColor: Color.fromARGB(179, 239, 243, 247),
          leading: Builder(
            builder: (context) => Card(color: Colors.white,
              child: IconButton(
                icon: Image(image: NetworkImage(globals.All_Client_Logo)),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: <Widget>[
            new Stack(
              children: <Widget>[
                new IconButton(
                    icon: Icon(
                      Icons.notifications,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      InProgressNotofication();
                      setState(() {
                        counter = 0;
                      });
                    }),
                counter != 0
                    ? new Positioned(
                        right: 11,
                        top: 11,
                        child: new Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '$counter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : new Container()
              ],
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xff123456),
                ),
                child: Container(
                  child: Column(
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: SizedBox(
                            height: 55.0,
                            width: 100.0,
                            child: Image(
                                image: NetworkImage(globals.All_Client_Logo))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    if (prefs.getString('Mobileno') == "" ||
                        prefs.getString('Mobileno') == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PatientLogin("")),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UsersProfile()),
                      );
                    }
                  },
                  leading: const Icon(Icons.person),
                  title: const Text("Profile")),
              ListTile(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    if (prefs.getString('Mobileno') == "" ||
                        prefs.getString('Mobileno') == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PatientLogin("")),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OredersHistory()),
                      );
                    }
                  },
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text("My Reports")),
              SizedBox(
                height: 380,
              ),
              ListTile(
                  onTap: () {},
                  // trailing: const Icon(Icons.phone),
                  title: Text("Powered by \u00a9 Suvarna TechnoSoft"))
            ],
          ),
        ),
        body: Stack(
          children: [
            // if (isLoading)
            //   Center(
            //     child: SizedBox(
            //       height: 100,
            //       width: 100,
            //       child: LoadingIndicator(
            //         indicatorType: Indicator.ballClipRotateMultiple,
            //         colors: [
            //           Color.fromARGB(255, 49, 114, 179),
            //         ],
            //         strokeWidth: 4.0,
            //       ),
            //     ),
            //   ),
            FutureBuilder<List<PreferredServices>>(
              future: _fetchManagerDetails(),
              builder: (context, snapshot) {
                if (!snapshot.hasData && !snapshot.hasError) {
                  // Loading indicator while waiting for data
                  return Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballClipRotateMultiple,
                        colors: [
                          Color.fromARGB(255, 49, 114, 179),
                        ],
                        strokeWidth: 4.0,
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  // Data has been fetched successfully, build UI using snapshot.data
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 180,
                          child: ListView(
                            children: [
                              CarouselSlider(
                                items: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Container(
                                      //  margin: EdgeInsets.all(0.0),

                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                            "assets/images/slider1.jpg",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // 2nd Image of Slider
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Container(
                                      //   margin: EdgeInsets.all(0.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                            "assets/images/slider2.jpg",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // 3rd Image of Slider
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Container(
                                      //   margin: EdgeInsets.all(0.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                            "assets/images/slider3.jpg",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Container(
                                      //   margin: EdgeInsets.all(0.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                            "assets/images/slider4.jpg",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Container(
                                      //   margin: EdgeInsets.all(0.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                            "assets/images/slider5.jpg",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                options: CarouselOptions(
                                  height: 180.0,
                                  enlargeCenterPage: true,
                                  autoPlay: true,
                                  // aspectRatio: 16 / 40,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enableInfiniteScroll: true,
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  viewportFraction: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Color.fromARGB(179, 168, 185, 202),
                          // height: 60,
                          // width: MediaQuery.of(context).size.width * 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      _SaveOrderHIStroy();
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            26, 14, 26, 14),
                                        child: Text(
                                          "My Reports",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                  child: SizedBox(
                                      height: 50.0,
                                      width: 80.0,
                                      child: Image(
                                          image: NetworkImage(
                                              globals.All_Client_Logo))),
                                ),
                                TextButton(
                                    onPressed: () {
                                      _SaveLoginDataTrends();
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            26, 14, 26, 14),
                                        child: Text(
                                          "My Trends",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: const [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Our Services",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 49, 114, 179),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                          child: Card(
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                    color: Color.fromARGB(255, 196, 218, 241))),
                            child: Column(
                              children: [
                                // GestureDetector(
                                //   onTap: (() {
                                //     globals.Location_BookedTest = "";
                                //     _SaveLoginDataBookATest();
                                //     // cartController.clear();
                                //     // productcontroller.resetAll();
                                //     globals.GlobalDiscountCoupons = '';
                                //   }),
                                //   child: ListTile(
                                //     leading: Container(
                                //         decoration: BoxDecoration(
                                //           border: Border.all(
                                //             color: Color(0xFFA18875),
                                //           ),
                                //           borderRadius: BorderRadius.all(
                                //             Radius.circular(5),
                                //           ),
                                //         ),
                                //         child: Icon(
                                //             Icons.account_circle_outlined,
                                //             size: 30,
                                //             color: Color(
                                //                 0xFFA18875))), // You can replace this with your own icon or image
                                //     title: Text(
                                //       'Test Enquiry',
                                //       style: TextStyle(
                                //           fontSize: 14,
                                //           fontWeight: FontWeight.w500),
                                //     ),
                                //     // subtitle: Text('Description of first content'),
                                //   ),
                                // ),
                                // Divider(), // Optional: add a divider between the two pieces of content
                                GestureDetector(
                                    onTap: (() {
                                      globals.selectDate = "";
                                      globals.SelectedlocationId = "";
                                      HomeVisitBook();
                                      globals.GlobalDiscountCoupons = '';

                                      // globals.Glb_PATIENT_APP_STATES_ID = null;
                                      // globals.Glb_PATIENT_APP_CITTY_ID = null;
                                    }),
                                    child: ListTile(
                                      leading: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0xFFEC407A),
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: Icon(Icons.home_outlined,
                                              size: 30,
                                              color: Color(
                                                  0xFFEC407A))), // You can replace this with your own icon or image
                                      title: Text(
                                        'Book a Home Visit',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      // subtitle: Text('Description of second content'),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 16),
                              child: Text('Health Packages',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 49, 114, 179),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18)),
                            )
                          ],
                        ),
                        //SizedBox(height: 8),
                        Container(
                          color: Color.fromARGB(179, 168, 185, 202),
                          height: MediaQuery.of(context).size.height * 0.19,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: PreferredServicesDetails,
                          ),
                        ),
                      ],
                    ),
                  ); // You can replace this with your UI components
                } else if (snapshot.hasError) {
                  // Error occurred while fetching data
                  return Text("${snapshot.error}");
                }
                return Container(); // Placeholder when none of the conditions are met
              },
            ),
          ],
        ),

        // Centered CircularProgressIndicator
        // if (isLoading) // Step 2
        //   Center(
        //     child: SizedBox(
        //       height: 100,
        //       width: 100,
        //       child: LoadingIndicator(
        //         indicatorType: Indicator.ballClipRotateMultiple,
        //         colors: [
        //           Color.fromARGB(255, 49, 114, 179),
        //         ],
        //         strokeWidth: 4.0,
        //       ),
        //     ),
        //   ),
        // FutureBuilder<List<PreferredServices>>(
        //   future: _fetchManagerDetails(),
        //   builder: (context, snapshot) {
        //     if (!snapshot.hasData && !snapshot.hasError) {
        //       return Center(
        //         child: SizedBox(
        //           height: 100,
        //           width: 100,
        //           child: LoadingIndicator(
        //             indicatorType: Indicator.ballClipRotateMultiple,
        //             colors: [
        //               // Color.fromARGB(255, 49, 213, 169),
        //               // Color.fromARGB(255, 246, 246, 246),
        //               Color.fromARGB(255, 49, 114, 179),
        //             ],
        //             strokeWidth: 4.0,
        //           ),
        //         ),
        //       );
        //     } else {
        //       // Return an empty container to avoid overlapping content
        //       return Container();
        //     }
        //   },
        // ),
        //   ],
        // ),
        bottomNavigationBar: AllBottOMNaviGAtionBar(),
      ),
    );
  }
}

ListView PreferredServicesListView(data, BuildContext context) {
  return ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index) {
      return _PreferredServicesDetails(data[index], context);
    },
    scrollDirection: Axis.horizontal,
  );
}

Widget _PreferredServicesDetails(var data, BuildContext context) {
  return GestureDetector(
      child: (data.SERVICE_TYPE_ID == '6' || data.SERVICE_TYPE_ID == '7')
          ? SizedBox(
              width: 135,
              // height: 130,
              child: Card(
                  color: Colors.white,
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 14, 0, 12),
                            child: Text(
                              data.srv_grp_name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            )),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                            child: Text(
                              '\u{20B9} ' + data.srv_price,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            )),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(6, 0, 2, 14),
                          child: Text(
                            data.srv_name,
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ])),
            )
          : Card());
}

class PreferredServices {
  final srv_name;
  final srv_grp_name;
  final srv_price;
  final srv_type;
  final SERVICE_TYPE_ID;
  PreferredServices({
    required this.srv_name,
    required this.srv_grp_name,
    required this.srv_price,
    required this.srv_type,
    required this.SERVICE_TYPE_ID,
  });
  factory PreferredServices.fromJson(Map<String, dynamic> json) {
    return PreferredServices(
      srv_name: json['SERVICE_NAME'].toString(),
      srv_grp_name: json['SERVICE_GROUP_NAME'].toString(),
      srv_price: json['PRICE'].toString(),
      srv_type: json['SERVICE_TYPE'].toString(),
      SERVICE_TYPE_ID: json['SERVICE_TYPE_ID'].toString(),
    );
  }
}
