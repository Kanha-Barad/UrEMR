import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import './PatientHome.dart';
import 'ClientCodeLogin.dart';
import 'PatientLogin.dart';
import 'UserProfile.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

class notifiCation extends StatefulWidget {
  const notifiCation({Key? key}) : super(key: key);

  @override
  State<notifiCation> createState() => _notifiCation();
}

class _notifiCation extends State<notifiCation> {
  // List of items in our dropdown menu

  @override
  Widget build(BuildContext context) {
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
                  globals.SelectedlocationId = "";
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
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  if (prefs.getString('Mobileno') == "") {
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
                  globals.umr_no = "";
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

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccessClientCodeLogin()),
                  );
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

    Future<List<ProgressNotification>> _FetchProgressNotification() async {
      Map data = {
        "MobileNo": globals.mobNO,
        "Flag": "INP_N",
        "UMR_NO": globals.umr_no,
        "connection": globals.Patient_App_Connection_String

        //"Server_Flag":""
      };
      final jobsListAPIUrl =
          // Uri.parse(
          //     'http://115.112.254.129/MobileSalesApi/PatinetMobileApp/OrderList');
          Uri.parse(
              globals.Global_Patient_Api_URL + '/PatinetMobileApp/OrderList');
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
        return jsonResponse
            .map((managers) => ProgressNotification.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget ListProgressNotification = Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<ProgressNotification>>(
            future: _FetchProgressNotification(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                return SizedBox(
                    child: _ProgressNotiFicationListView(data, context));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const Center(
                  child: const CircularProgressIndicator(
                strokeWidth: 4.0,
              ));
            }));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Color(0xff123456),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PatientHome()));
              },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Row(
          children: [
            Text(
              'Notifications',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Spacer(),
            TextButton.icon(
                onPressed: () {
                  setState(() {});
                },
                label: Text("Refresh",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                icon: Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: 20,
                ))
            // Text("Refresh",
            //     style: TextStyle(color: Colors.white, fontSize: 14)),
            // InkWell(
            //     onTap: () {
            //       setState(() {});
            //     },
            //     child: Icon(Icons.refresh_rounded,size: 20,))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(child: ListProgressNotification),
      ),
      bottomNavigationBar: myBottomNavigationBar,
    );
  }
}

class ProgressNotification {
  final display_name;
  final bill_no;
  final bill_id;
  final bill_dt;
  final gender;
  final net_amt;
  final outstanding_due;
  final Assigned_DT;
  final Accepted_DT;
  final Started_DT;
  final Reached_DT;
  final Reject_DT;
  final Completed_DT;
  final Status;
  final Employee;
  final Employee_Mob_No;
  final Reject_Reason;
  ProgressNotification({
    required this.display_name,
    required this.bill_no,
    required this.bill_id,
    required this.bill_dt,
    required this.gender,
    required this.net_amt,
    required this.outstanding_due,
    required this.Assigned_DT,
    required this.Accepted_DT,
    required this.Started_DT,
    required this.Reached_DT,
    required this.Reject_DT,
    required this.Completed_DT,
    required this.Status,
    required this.Employee,
    required this.Employee_Mob_No,
    required this.Reject_Reason,
  });
  factory ProgressNotification.fromJson(Map<String, dynamic> json) {
    return ProgressNotification(
      display_name: json['DISPLAY_NAME'].toString(),
      bill_no: json['BILL_NO'].toString(),
      bill_id: json['BILL_ID'].toString(),
      bill_dt: json['BILL_DT'].toString(),
      gender: json['GENDER'].toString(),
      net_amt: json['NET_AMOUNT'].toString(),
      outstanding_due: json['OUTSTANDING_DUE'].toString(),
      Assigned_DT: json['ASSIGNED_DT'].toString(),
      Accepted_DT: json['ACCEPTED_DT'].toString(),
      Started_DT: json['START_DT'].toString(),
      Reached_DT: json['REACHED_DT'].toString(),
      Reject_DT: json['REJECT_DT'].toString(),
      Completed_DT: json['COMPLETED_DT'].toString(),
      Status: json['STATUS'].toString(),
      Employee: json['EMPLOYEE'].toString(),
      Employee_Mob_No: json['EMP_MOBILE'].toString(),
      Reject_Reason: json['REJECT_REASON'].toString(),
    );
  }
}

ListView _ProgressNotiFicationListView(data, BuildContext contex) {
  return ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index) {
      return _ProgressNotiFication(data[index], context);
    },
  );
}

String Number = "08456849320";
Widget _ProgressNotiFication(var data, BuildContext context) {
  Future<void> launchPhoneDialer(String contactNumber) async {
    final Uri _phoneUri = Uri(scheme: "tel", path: contactNumber);
    try {
      if (await canLaunch(_phoneUri.toString()))
        await launch(_phoneUri.toString());
    } catch (error) {
      throw ("Cannot dial");
    }
  }

  //bool _customTileExpanded = false;
  return GestureDetector(
      child: Column(
    children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey)),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 2, right: 8),
                          child: Icon(Icons.person,
                              color: Color.fromARGB(255, 153, 182, 209)),
                        ),
                        Text(data.display_name.toString(),
                            style: TextStyle(
                                color: Color(0xff123456),
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0)),
                        Spacer(),
                        Text('\u{20B9} ' + data.net_amt.toString(),
                            style: TextStyle(
                                color: Color.fromARGB(255, 218, 75, 65),
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, top: 6, bottom: 4),
                    child: Row(
                      children: [
                        Text(
                            data.bill_no.toString() +
                                '  |  ' +
                                data.bill_dt.toString(),
                            style: TextStyle(
                                color: Color.fromARGB(255, 90, 133, 173),
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (data.Status == "Assigned")
                          Card(
                              color: Color.fromARGB(255, 221, 180, 65),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
                                  child: Center(
                                    child: Text("Assigned",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.0)),
                                  )))
                        else if (data.Status == "Accepted")
                          Card(
                              color: Color.fromARGB(255, 25, 160, 66),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
                                  child: Center(
                                    child: Text("Accepted",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.0)),
                                  )))
                        else if (data.Status == "Started")
                          Card(
                              color: Color.fromARGB(255, 174, 178, 178),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
                                  child: Center(
                                    child: Text("Started",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.0)),
                                  )))
                        else if (data.Status == "Reached")
                          Card(
                              color: Color.fromARGB(255, 191, 76, 176),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
                                  child: Center(
                                    child: Text("Reached",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.0)),
                                  )))
                        else if (data.Status == "Completed")
                          Card(
                              color: Color.fromARGB(255, 108, 86, 214),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
                                  child: Center(
                                    child: Text("Completed",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.0)),
                                  )))
                        else if (data.Status == "Rejected")
                          Card(
                              color: Color.fromARGB(255, 235, 30, 26),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
                                  child: Center(
                                    child: Text("Rejected",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.0)),
                                  )))
                        else
                          Card(
                              color: Color.fromARGB(255, 233, 117, 28),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
                                  child: Center(
                                    child: Text("Pending",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.0)),
                                  ))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            data.Assigned_DT != null &&
                                    data.Assigned_DT != "null"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  )
                                : Container(
                                    height: 20,
                                    child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 33, 94, 150),
                                        radius: 9.0,
                                        child: ClipRRect(
                                          child: Text(
                                            "1",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                          ),
                                        ))),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(" Assigned :"),
                            ),
                            data.Assigned_DT != null &&
                                    data.Assigned_DT != "null"
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Text(data.Assigned_DT),
                                  )
                                : Text("")
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            data.Accepted_DT != null &&
                                    data.Accepted_DT != "null"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  )
                                : Container(
                                    height: 20,
                                    child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 33, 94, 150),
                                        radius: 9.0,
                                        child: ClipRRect(
                                          child: Text(
                                            "2",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                          ),
                                        ))),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(" Accepted :"),
                            ),
                            data.Accepted_DT != null &&
                                    data.Accepted_DT != "null"
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Text(data.Accepted_DT),
                                  )
                                : Text("")
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            data.Started_DT != null && data.Started_DT != "null"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  )
                                : Container(
                                    height: 20,
                                    child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 33, 94, 150),
                                        radius: 9.0,
                                        child: ClipRRect(
                                          child: Text(
                                            "3",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                          ),
                                        ))),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(" Started :"),
                            ),
                            data.Started_DT != null && data.Started_DT != "null"
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Text(data.Started_DT),
                                  )
                                : Text("")
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            data.Reached_DT != null && data.Reached_DT != "null"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  )
                                : Container(
                                    height: 20,
                                    child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 33, 94, 150),
                                        radius: 9.0,
                                        child: ClipRRect(
                                          child: Text(
                                            "4",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                          ),
                                        ))),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(" Reached :"),
                            ),
                            data.Reached_DT != null && data.Reached_DT != "null"
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Text(data.Reached_DT),
                                  )
                                : Text("")
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            data.Completed_DT != null &&
                                    data.Completed_DT != "null"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  )
                                : Container(
                                    height: 20,
                                    child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 33, 94, 150),
                                        radius: 9.0,
                                        child: ClipRRect(
                                          child: Text(
                                            "5",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                          ),
                                        ))),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(" Completed :"),
                            ),
                            data.Completed_DT != null &&
                                    data.Completed_DT != "null"
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Text(data.Completed_DT),
                                  )
                                : Text("")
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            data.Reject_DT != null && data.Reject_DT != "null"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  )
                                : Container(
                                    height: 20,
                                    child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 33, 94, 150),
                                        radius: 9.0,
                                        child: ClipRRect(
                                          child: Text(
                                            "6",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                          ),
                                        ))),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(" Rejected :"),
                            ),
                            data.Reject_DT != null && data.Reject_DT != "null"
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Text(data.Reject_DT),
                                  )
                                : Text("")
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey)),
            elevation: 4.0,
            child: Column(
              children: [
                Container(
                  height: 35,
                  // color: Color.fromARGB(255, 16, 59, 135),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 25, 60, 120),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0),
                    ),
                  ),
                  child: Center(
                      child: Text(
                    "Phlebostomist",
                    style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),
                  )),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                      child: Icon(Icons.person,
                          color: Color.fromARGB(255, 153, 182, 209)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(data.Employee.toString(),
                          style: TextStyle(
                              color: Color(0xff123456),
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0)),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
                        child: Text(
                          "Make a Phone Call",
                          style: TextStyle(
                              color: Color.fromARGB(255, 15, 103, 170),
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      InkWell(
                        child: Icon(
                          Icons.call,
                          size: 18,
                          color: Colors.green,
                        ),
                        onTap: () {
                          String Number = '08456849320';
                          launchPhoneDialer(Number);
                          // UrlLauncher.launch('tel:+ $Number');
                          //launchDialer(Number);
                          // callNumber();
                          // _launchPhoneURL("8456849320");
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ))
    ],
  ));
}

// launchDialer(String number) async {
//   String url = 'tel:' + number;
//   if (await launch('$url')) {
//     await launch(url);
//   } else {
//     throw 'Application unable to open dialer.';
//   }
// }
// callNumber() async{
//   const number = '08456849320'; //set the number here
//   bool? call = await FlutterPhoneDirectCaller.callNumber(number);
// }

// _launchPhoneURL(String phoneNumber) async {
//   String url = 'tel:' + phoneNumber;
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }

_callNumber(String phoneNumber) async {
  String number = phoneNumber;
  await FlutterPhoneDirectCaller.callNumber(number);
}

// Card(
//     child: Padding(
//   padding: const EdgeInsets.all(10.0),
//   child: Row(
//     children: [
//       Icon(
//         Icons.person_add_outlined,
//         color: Colors.purple,
//         size: 40,
//       ),
//       SizedBox(
//         width: 10,
//       ),
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//               width: 250,
//               child: Text(
//                 'You have got 500 loyalty point against order 100233112 order number.',
//                 style: TextStyle(
//                     fontSize: 12, color: Colors.black),
//               )),
//           SizedBox(
//             height: 5,
//           ),
//           Text(
//             'Insure now.',
//             style: TextStyle(fontSize: 11, color: Colors.grey),
//           )
//         ],
//       ),
//       SizedBox(
//         width: 5,
//       ),
//       Icon(
//         Icons.more_vert_rounded,
//         color: Colors.grey,
//         size: 25,
//       ),
//     ],
//   ),
// )),

// ExpansionTile(
//                 backgroundColor: Colors.white,
//                 title: SizedBox(
//                     child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 6.0),
//                       child: Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 2, right: 8),
//                             child: Icon(Icons.person,
//                                 color: Color.fromARGB(255, 153, 182, 209)),
//                           ),
//                           Text(data.display_name.toString(),
//                               style: TextStyle(
//                                   color: Color(0xff123456),
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 13.0)),
//                           Spacer(),
//                           Text('\u{20B9} ' + data.net_amt.toString(),
//                               style: TextStyle(
//                                   color: Color.fromARGB(255, 218, 75, 65),
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 13.0)),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(left: 35, top: 6, bottom: 4),
//                       child: Row(
//                         children: [
//                           Text(
//                               data.bill_no.toString() +
//                                   '  |  ' +
//                                   data.bill_dt.toString(),
//                               style: TextStyle(
//                                   color: Color.fromARGB(255, 90, 133, 173),
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 10.0)),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           if (data.Status == "Assigned")
//                             Card(
//                                 color: Color.fromARGB(255, 221, 180, 65),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8)),
//                                 child: Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
//                                     child: Center(
//                                       child: Text("Assigned",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 11.0)),
//                                     )))
//                           else if (data.Status == "Accepted")
//                             Card(
//                                 color: Color.fromARGB(255, 25, 160, 66),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8)),
//                                 child: Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
//                                     child: Center(
//                                       child: Text("Accepted",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 11.0)),
//                                     )))
//                           else if (data.Status == "Started")
//                             Card(
//                                 color: Color.fromARGB(255, 174, 178, 178),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8)),
//                                 child: Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
//                                     child: Center(
//                                       child: Text("Started",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 11.0)),
//                                     )))
//                           else if (data.Status == "Reached")
//                             Card(
//                                 color: Color.fromARGB(255, 191, 76, 176),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8)),
//                                 child: Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
//                                     child: Center(
//                                       child: Text("Reached",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 11.0)),
//                                     )))
//                           else if (data.Status == "Completed")
//                             Card(
//                                 color: Color.fromARGB(255, 108, 86, 214),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8)),
//                                 child: Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
//                                     child: Center(
//                                       child: Text("Completed",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 11.0)),
//                                     )))
//                           else if (data.Status == "Rejected")
//                             Card(
//                                 color: Color.fromARGB(255, 235, 30, 26),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8)),
//                                 child: Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
//                                     child: Center(
//                                       child: Text("Rejected",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 11.0)),
//                                     )))
//                           else
//                             Card(
//                                 color: Color.fromARGB(255, 233, 117, 28),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8)),
//                                 child: Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
//                                     child: Center(
//                                       child: Text("Pending",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 11.0)),
//                                     ))),
//                         ],
//                       ),
//                     ),
//                   ],
//                 )),
//                 children: [
//                   SingleChildScrollView(
//                     scrollDirection: Axis.vertical,
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               data.Assigned_DT != null &&
//                                       data.Assigned_DT != "null"
//                                   ? Icon(
//                                       Icons.check_circle,
//                                       color: Colors.green,
//                                       size: 20,
//                                     )
//                                   : Container(
//                                       height: 20,
//                                       child: CircleAvatar(
//                                           backgroundColor:
//                                               Color.fromARGB(255, 33, 94, 150),
//                                           radius: 9.0,
//                                           child: ClipRRect(
//                                             child: Text(
//                                               "1",
//                                               style: TextStyle(
//                                                   fontSize: 11,
//                                                   color: Colors.white),
//                                             ),
//                                           ))),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Text(" Assigned :"),
//                               ),
//                               data.Assigned_DT != null &&
//                                       data.Assigned_DT != "null"
//                                   ? Padding(
//                                       padding:
//                                           const EdgeInsets.only(left: 18.0),
//                                       child: Text(data.Assigned_DT),
//                                     )
//                                   : Text("")
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 2.0),
//                             child: SizedBox(
//                               height: 30,
//                               child: VerticalDivider(
//                                 color: Colors.black,
//                                 thickness: 1,
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               data.Accepted_DT != null &&
//                                       data.Accepted_DT != "null"
//                                   ? Icon(
//                                       Icons.check_circle,
//                                       color: Colors.green,
//                                       size: 20,
//                                     )
//                                   : Container(
//                                       height: 20,
//                                       child: CircleAvatar(
//                                           backgroundColor:
//                                               Color.fromARGB(255, 33, 94, 150),
//                                           radius: 9.0,
//                                           child: ClipRRect(
//                                             child: Text(
//                                               "2",
//                                               style: TextStyle(
//                                                   fontSize: 11,
//                                                   color: Colors.white),
//                                             ),
//                                           ))),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Text(" Accepted :"),
//                               ),
//                               data.Accepted_DT != null &&
//                                       data.Accepted_DT != "null"
//                                   ? Padding(
//                                       padding:
//                                           const EdgeInsets.only(left: 18.0),
//                                       child: Text(data.Accepted_DT),
//                                     )
//                                   : Text("")
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 2.0),
//                             child: SizedBox(
//                               height: 30,
//                               child: VerticalDivider(
//                                 color: Colors.black,
//                                 thickness: 1,
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               data.Started_DT != null &&
//                                       data.Started_DT != "null"
//                                   ? Icon(
//                                       Icons.check_circle,
//                                       color: Colors.green,
//                                       size: 20,
//                                     )
//                                   : Container(
//                                       height: 20,
//                                       child: CircleAvatar(
//                                           backgroundColor:
//                                               Color.fromARGB(255, 33, 94, 150),
//                                           radius: 9.0,
//                                           child: ClipRRect(
//                                             child: Text(
//                                               "3",
//                                               style: TextStyle(
//                                                   fontSize: 11,
//                                                   color: Colors.white),
//                                             ),
//                                           ))),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Text(" Started :"),
//                               ),
//                               data.Started_DT != null &&
//                                       data.Started_DT != "null"
//                                   ? Padding(
//                                       padding:
//                                           const EdgeInsets.only(left: 18.0),
//                                       child: Text(data.Started_DT),
//                                     )
//                                   : Text("")
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 2.0),
//                             child: SizedBox(
//                               height: 30,
//                               child: VerticalDivider(
//                                 color: Colors.black,
//                                 thickness: 1,
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               data.Reached_DT != null &&
//                                       data.Reached_DT != "null"
//                                   ? Icon(
//                                       Icons.check_circle,
//                                       color: Colors.green,
//                                       size: 20,
//                                     )
//                                   : Container(
//                                       height: 20,
//                                       child: CircleAvatar(
//                                           backgroundColor:
//                                               Color.fromARGB(255, 33, 94, 150),
//                                           radius: 9.0,
//                                           child: ClipRRect(
//                                             child: Text(
//                                               "4",
//                                               style: TextStyle(
//                                                   fontSize: 11,
//                                                   color: Colors.white),
//                                             ),
//                                           ))),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Text(" Reached :"),
//                               ),
//                               data.Reached_DT != null &&
//                                       data.Reached_DT != "null"
//                                   ? Padding(
//                                       padding:
//                                           const EdgeInsets.only(left: 18.0),
//                                       child: Text(data.Reached_DT),
//                                     )
//                                   : Text("")
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 2.0),
//                             child: SizedBox(
//                               height: 30,
//                               child: VerticalDivider(
//                                 color: Colors.black,
//                                 thickness: 1,
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               data.Completed_DT != null &&
//                                       data.Completed_DT != "null"
//                                   ? Icon(
//                                       Icons.check_circle,
//                                       color: Colors.green,
//                                       size: 20,
//                                     )
//                                   : Container(
//                                       height: 20,
//                                       child: CircleAvatar(
//                                           backgroundColor:
//                                               Color.fromARGB(255, 33, 94, 150),
//                                           radius: 9.0,
//                                           child: ClipRRect(
//                                             child: Text(
//                                               "5",
//                                               style: TextStyle(
//                                                   fontSize: 11,
//                                                   color: Colors.white),
//                                             ),
//                                           ))),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Text(" Completed :"),
//                               ),
//                               data.Completed_DT != null &&
//                                       data.Completed_DT != "null"
//                                   ? Padding(
//                                       padding:
//                                           const EdgeInsets.only(left: 18.0),
//                                       child: Text(data.Completed_DT),
//                                     )
//                                   : Text("")
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 2.0),
//                             child: SizedBox(
//                               height: 30,
//                               child: VerticalDivider(
//                                 color: Colors.black,
//                                 thickness: 1,
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               data.Reject_DT != null && data.Reject_DT != "null"
//                                   ? Icon(
//                                       Icons.check_circle,
//                                       color: Colors.green,
//                                       size: 20,
//                                     )
//                                   : Container(
//                                       height: 20,
//                                       child: CircleAvatar(
//                                           backgroundColor:
//                                               Color.fromARGB(255, 33, 94, 150),
//                                           radius: 9.0,
//                                           child: ClipRRect(
//                                             child: Text(
//                                               "6",
//                                               style: TextStyle(
//                                                   fontSize: 11,
//                                                   color: Colors.white),
//                                             ),
//                                           ))),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Text(" Rejected :"),
//                               ),
//                               data.Reject_DT != null && data.Reject_DT != "null"
//                                   ? Padding(
//                                       padding:
//                                           const EdgeInsets.only(left: 18.0),
//                                       child: Text(data.Reject_DT),
//                                     )
//                                   : Text("")
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ]),
