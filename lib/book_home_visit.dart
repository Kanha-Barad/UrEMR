import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'PatientHome.dart';
import 'Screens/Book_Test_screen.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:badges/badges.dart' as badges;

var functionCalls = "";
var GridViewList = [];

class Book_Home_Visit extends StatefulWidget {
  int selectedIndex;
  Book_Home_Visit(this.selectedIndex) {}
  @override
  State<Book_Home_Visit> createState() =>
      _Book_Home_VisitState(this.selectedIndex);
}

class _Book_Home_VisitState extends State<Book_Home_Visit> {
  @override
  late int selectedIndex;
  var selecteFromdt = '';
  var selecteTodt = '';
  String empID = "0";
  _Book_Home_VisitState(this.selectedIndex) {}

  String date = "";
  DateTime selectedDate = DateTime.now();

//Date Selection...........................................
  Widget _buildDatesCard(data, index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextButton(
        child: Text(
          data["Frequency"],
          style: const TextStyle(fontSize: 12.0),
        ),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              // side: BorderSide(color: Colors.red)
            )),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.red),
            backgroundColor: selectedIndex == index && globals.fromDate == ''
                ? MaterialStateColor.resolveWith((states) => Colors.pink)
                : MaterialStateColor.resolveWith((states) => Colors.blueGrey),
            shadowColor:
                MaterialStateColor.resolveWith((states) => Colors.blueGrey),
            foregroundColor:
                MaterialStateColor.resolveWith((states) => Colors.white)),
        onPressed: () {
          print(index.toString());
          _onLoading();
          setState(() {
            // globals.selectDate = '';
            globals.fromDate = '';
            globals.ToDate = '';
            selectedIndex = index;
            final DateFormat formatter = DateFormat('dd-MMM-yyyy');
            var now = DateTime.now();
            var yesterday = now.subtract(const Duration(days: -1));
            //   var lastweek = now.subtract(const Duration(days: 7));

            var thisweek = now.subtract(const Duration(days: -2));
            var lastWeek1stDay = now.subtract(const Duration(days: -3));
            var lastWeekLastDay = now.subtract(const Duration(days: -4));
            var thismonth = now.subtract(const Duration(days: -5));

            var prevMonth1stday = now.subtract(const Duration(days: -6));
            var prevMonthLastday = now.subtract(const Duration(days: -7));

            if (selectedIndex == 0) {
              // Today
              selecteFromdt = formatter.format(now);
              selecteTodt = formatter.format(now);
            } else if (selectedIndex == 1) {
              // yesterday
              selecteFromdt = formatter.format(yesterday);
              selecteTodt = formatter.format(yesterday);
            } else if (selectedIndex == 2) {
              // LastWeek
              selecteFromdt = formatter.format(thisweek);
              selecteTodt = formatter.format(thisweek);
            } else if (selectedIndex == 3) {
              selecteFromdt = formatter.format(lastWeek1stDay);
              selecteTodt = formatter.format(now);
            } else if (selectedIndex == 4) {
              selecteFromdt = formatter.format(lastWeekLastDay);
              selecteTodt = formatter.format(now);
            } else if (selectedIndex == 5) {
              // Last Month
              selecteFromdt = formatter.format(thismonth);
              selecteTodt = formatter.format(prevMonth1stday);
            } else if (selectedIndex == 6) {
              selecteFromdt = formatter.format(prevMonthLastday);
              selecteTodt = formatter.format(now);
            }

            print("From Date " + selecteFromdt);
            print("To Date " + selecteTodt);
            globals.selectDate = selecteFromdt;
            print(selectedIndex);
            GridViewList.length = 0;
          });
        },
        onLongPress: () {
          print('Long press');
        },
      ),
    );
  }

  ListView datesListView() {
    var myData = [
      {
        "FrequencyId": "1",
        "Frequency": DateTime.now().toString().split(' ')[0],
      },
      {
        "FrequencyId": "2",
        "Frequency": DateTime.now()
            .subtract(Duration(days: -1))
            .toString()
            .split(' ')[0],
      },
      {
        "FrequencyId": "3",
        "Frequency": DateTime.now()
            .subtract(Duration(days: -2))
            .toString()
            .split(' ')[0],
      },
      {
        "FrequencyId": "4",
        "Frequency": DateTime.now()
            .subtract(Duration(days: -3))
            .toString()
            .split(' ')[0],
      },
      {
        "FrequencyId": "5",
        "Frequency": DateTime.now()
            .subtract(Duration(days: -4))
            .toString()
            .split(' ')[0],
      },
      {
        "FrequencyId": "6",
        "Frequency": DateTime.now()
            .subtract(Duration(days: -5))
            .toString()
            .split(' ')[0],
      }
    ];

    return ListView.builder(
        itemCount: myData.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return _buildDatesCard(myData[index], index);
        });
  }

  void _onLoading() {
    // SizedBox(
    //   height: 100,
    //   width: 100,
    //   child: Center(
    //     child: LoadingIndicator(
    //       indicatorType: Indicator.ballClipRotateMultiple,
    //       colors: Colors.primaries,
    //       strokeWidth: 4.0,
    //       //   pathBackgroundColor:ColorSwatch(Action[])
    //     ),
    //   ),
    // );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: LoadingIndicator(
              indicatorType: Indicator.ballClipRotateMultiple,
              colors: Colors.primaries,
              strokeWidth: 4.0,
              //   pathBackgroundColor:ColorSwatch(Action[])
            ),
          ),
        );
      },
    );
     Future.delayed(new Duration(seconds: 1), () {
      Navigator.pop(context); //pop dialog
    });
  }

  Widget DateSelection() {
    return Container(child: datesListView());
  }

//Date Selection...........................................
  Widget Application_Widget(var data, BuildContext context, index) {
    return Container(
        height: 800,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: GridViewList.length,
            itemBuilder: (BuildContext ctx, index) {
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Text(GridViewList[index]["SLOT_TIME"]),
                  ],
                ),
              );
            }));
  }

  ListView Application_ListView(data, BuildContext context) {
    if (data != null) {
      return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Application_Widget(data[index], context, index);
          });
    }
    return ListView();
  }

  Future<List<Data_Model>> _fetchSaleTransaction() async {
    var jobsListAPIUrl = null;
    var dsetName = '';
    List listresponse = [];

    // GridViewList = [];
    Map data = {
      "IP_AGENCY_ID": "11",
      "IP_AREA_ID": "43",
      "IP_FROM_DT": selecteFromdt == ""
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : selecteFromdt,
      "IP_TO_DT": selecteFromdt == ""
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : selecteFromdt,
      "IP_SESSION_ID": "119023",
      "IP_FLAG": "D",
      "IP_SUB_FLAG": "NULL",
      "IP_LOC_ID": globals.SelectedlocationId,
      "connection": globals.Patient_App_Connection_String,
    };

    dsetName = 'result';
    jobsListAPIUrl = Uri.parse(globals.Global_Patient_Api_URL +
        '/PatinetMobileApp/GET_SLOTS_PATIENT_APP');

    var response = await http.post(jobsListAPIUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200 || response.statusCode == 500) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      // resposne["Data"] == null ? GridViewList = [] : Container();
      List jsonResponse = resposne["Data"];

      //globals.SelectedlocationId = "";
      GridViewList = [];
      var SLOT_TIME = "";
      for (int i = 0; i <= resposne['Data'].length - 1; i++) {
        GridViewList.add({
          'SLOT_TIME': resposne['Data'][i]["SLOT_TIME"],
          'SLOT_COUNT': resposne['Data'][i]["SLOT_COUNT"],
          'SLOT_ID': resposne['Data'][i]["SLOT_ID"],
          'LOC_NAME': resposne['Data'][i]["LOC_NAME"],
          'IND_BOOK_SLOTS': resposne['Data'][i]["IND_BOOK_SLOTS"],
        });
      }
      setState(() {
        //   // function_widet();
      });
      // setState() {
      //   Book_Home_Visit();
      // }

      return jsonResponse.map((strans) => Data_Model.fromJson(strans)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<List<Data_Model>> _Add_Test_fetchSaleTransaction1() async {
    var jobsListAPIUrl = null;

    Map data = {};

    jobsListAPIUrl = Uri.parse(globals.Global_Patient_Api_URL +
        '/PatinetMobileApp/GET_SLOTS_PATIENT_APP');

    var response = await http.post(jobsListAPIUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200 || response.statusCode == 500) {
      Map<String, dynamic> resposne = jsonDecode(response.body);

      List jsonResponse = resposne["Data"];

      return jsonResponse.map((strans) => Data_Model.fromJson(strans)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  var _selectedItem;
  late Map<String, dynamic> params;
  late Map<String, dynamic> map;
  List data = []; //edi

  Widget build(BuildContext context) {
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
                    //  GridViewList.length = 0;
                    GridViewList = [];
                    _onLoading();
                    Book_Home_Visit(this.selectedIndex);
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
    // _Add_Test_fetchSaleTransaction1() {}

    Widget verticalList3 = Container(
      child: FutureBuilder<List<Data_Model>>(
          future:
              (globals.SelectedlocationId != null && GridViewList.length == 0)
                  ? _fetchSaleTransaction()
                  : _Add_Test_fetchSaleTransaction1(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty == true) {
                return NoContent3();
              }
              var data = snapshot.data;
              return SizedBox(child: Application_ListView(data, context));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return SizedBox(
              height: 100,
              width: 100,
              child: Center(
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotateMultiple,
                  colors: Colors.primaries,
                  strokeWidth: 4.0,
                  //   pathBackgroundColor:ColorSwatch(Action[])
                ),
              ),
            );
            ;
          }),
    );

    All_Test_Widget(var data, BuildContext context) {
      return Column(
        children: [
          Card(
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            "Booking Slots:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )),
                Container(
                    height: MediaQuery.of(context).size.height * 0.64,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 100,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 20),
                        itemCount: GridViewList.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return InkWell(
                            onTap: () {
                              globals.Location_BookedTest =
                                  GridViewList[index]["LOC_NAME"].toString();
                              globals.SlotsBooked =
                                  GridViewList[index]["SLOT_TIME"].toString();
                              globals.Slot_id =
                                  GridViewList[index]["SLOT_ID"].toString();

                              GridViewList[index]["SLOT_COUNT"] <= 0
                                  ? print("Slots finished")
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductOverviewPage()));
                            },
                            child: Card(
                              elevation: 5,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      GridViewList[index]["SLOT_TIME"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: GridViewList[index]
                                                    ["SLOT_COUNT"] >
                                                5
                                            ? Colors.green
                                            : GridViewList[index]
                                                            ["SLOT_COUNT"] <=
                                                        5 &&
                                                    GridViewList[index]
                                                            ["SLOT_COUNT"] >
                                                        0
                                                ? Colors.orange
                                                : GridViewList[index]
                                                            ["SLOT_COUNT"] <=
                                                        0
                                                    ? Colors.grey
                                                    : Colors.white,
                                      ),
                                    ),
                                    // Padding(
                                    //   padding:
                                    //       const EdgeInsets.only(left: 12.0, right: 12.0),
                                    //   child: Row(
                                    //     children: [
                                    //       Text(
                                    //         GridViewList[index]["IND_BOOK_SLOTS"]
                                    //             .toString(),
                                    //         style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //         ),
                                    //       ),
                                    //       Spacer(),
                                    //       Text(
                                    //         GridViewList[index]["SLOT_COUNT"].toString(),
                                    //         style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // )
                                    //..................................................
                                    // badges.Badge(
                                    //     badgeColor: Colors.blue,
                                    //     position: BadgePosition.topEnd(top: -18),
                                    //     child: Column(
                                    //       children: [
                                    // Text(
                                    // GridViewList[index]["SLOT_TIME"],
                                    // style:
                                    //     TextStyle(fontWeight: FontWeight.bold),
                                    // ),
                                    //         GridViewList[index]["IND_BOOK_SLOTS"] != 0
                                    //             ? Container(
                                    //                 width: 15.0,
                                    //                 height: 15.0,
                                    //                 decoration: const BoxDecoration(
                                    //                   color: Colors.red,
                                    //                   shape: BoxShape.circle,
                                    //                 ),
                                    //                 child: Center(
                                    //                   child: Text(
                                    //                     GridViewList[index]
                                    //                             ["IND_BOOK_SLOTS"]
                                    //                         .toString(),
                                    //                     style: TextStyle(
                                    //                       fontWeight: FontWeight.bold,
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //               )
                                    //             : Text(
                                    //                 "".toString(),
                                    //                 style: TextStyle(
                                    //                     fontWeight: FontWeight.bold),
                                    //               )
                                    //       ],
                                    //     ),
                                    //     badgeContent: Text(
                                    //         GridViewList[index]["SLOT_COUNT"].toString())

                                    //     // color: Color.fromARGB(255, 27, 165, 114),
                                    //     )
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
              ],
            ),
          ),
        ],
      );
    }

    function_widet() {
      return All_Test_Widget(GridViewList, context);
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xff123456),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    GridViewList = [];
                    globals.SelectedlocationId = "";
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PatientHome()));
                  },
                );
              },
            ),
            title: Row(
              children: [
                Text(
                  "Book A Home Visit",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Spacer(),
                selecteFromdt == ""
                    ? Text("${selectedDate.toLocal()}".split(' ')[0],
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                    : Text(
                        selecteFromdt,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                // IconButton(
                //     onPressed: () {
                //       // _selectDate(context);
                //     },
                //     icon: Icon(Icons.calendar_month_outlined),
                //     color: Colors.white),
              ],
            ),
          ),
          body: Container(
            color: Colors.blue[50],
            child: Column(
              children: [
                SizedBox(height: 48, child: DateSelection()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: locationDropdwon,
                ),
                // verticalList3,
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: globals.SelectedlocationId == null ||
                            globals.SelectedlocationId == "" ||
                            GridViewList.length == 0
                        ? Container(
                            child: Padding(
                            padding: const EdgeInsets.only(top: 200.0),
                            child: globals.SelectedlocationId == ""
                                ? Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  )
                                : Text(
                                    "Slots Not Available",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                          ))
                        : Container(child: function_widet())),
              ],
            ),
          )),
    );
  }
}

class Data_Model {
  final SLOT_TIME;

  Data_Model({
    required this.SLOT_TIME,
  });

  factory Data_Model.fromJson(Map<String, dynamic> json) {
    return Data_Model(
      SLOT_TIME: json['SLOT_TIME'],
    );
  }
}

class NoContent3 extends StatelessWidget {
  const NoContent3();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.verified_rounded,
              color: Colors.red,
              size: 50,
            ),
            const Text('No Data Found'),
          ],
        ),
      ),
    );
  }
}
