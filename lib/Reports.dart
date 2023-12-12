import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uremr/Widgets/BottomNavigation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

class RepoRTSBillWise extends StatefulWidget {
  const RepoRTSBillWise({super.key});

  @override
  State<RepoRTSBillWise> createState() => _RepoRTSBillWiseState();
}

class _RepoRTSBillWiseState extends State<RepoRTSBillWise> {
  late Future<List<patientDetailsReport>> _futureReports;

  @override
  void initState() {
    super.initState();
    _futureReports = fetchReports();
  }

  Future<List<patientDetailsReport>> fetchReports() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mobileNumber = prefs.getString('Mobileno');
    // AuthProvider _authProvider = AuthProvider();

    // List<OTPValidationResponse> Useroptions =
    //     await _authProvider.getStoredOTPValidationResponses();

    if (mobileNumber!.isNotEmpty) {
      mobileNumber = prefs.getString('Mobileno');
    }

    Map<String, dynamic> data = {
      "bill_id": mobileNumber.toString() + "*B",
      "connection": globals.Patient_App_Connection_String
    };

    Uri jobsListAPIUrl = Uri.parse(
        globals.Global_Patient_Api_URL + '/PatinetMobileApp/BillServices');

    try {
      var response = await http.post(jobsListAPIUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> data = responseData["Data"]; // Extract the data list

        List<patientDetailsReport> fetchedReports = [];

        for (var reportData in data) {
          fetchedReports.add(patientDetailsReport.fromJson(reportData));
        }

        return fetchedReports;
      } else {
        throw Exception(
            'API request failed with status ${response.statusCode}');
      }
    } catch (error) {
      print('API request failed with error: $error');
      throw Exception('API request failed with error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff123456),
        centerTitle: true,
        //  backgroundColor: Color.fromARGB(179, 239, 243, 247),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<patientDetailsReport>>(
          future: _futureReports,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              // Display your fetched data in a ListView, for example
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Icon(
                              Icons.library_books,
                              color: Color.fromARGB(255, 103, 147, 190),
                              size: 30,
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(snapshot.data![index].billNo,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4)),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ExpandableText(
                                    text: snapshot.data![index].srvname
                                        .toString(),
                                    maxLength: 40,
                                  ),
                                ),
                                Text(snapshot.data![index].Bill_Dt.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                          trailing: snapshot.data![index].reportCd != "null"
                              // snapshot.data![index].REPORT_CD ==
                              //     "Dispatch"
                              ? InkWell(
                                  onTap: () async {
                                    List<String> individualCodes = snapshot
                                        .data![index].reportCd
                                        .split(', ');
                                    String firstReportCode = individualCodes[0];
                                    print(
                                        "First report code: $firstReportCode");
                                    // final downloadUrl =
                                    //     'https://portal1.nmmedical.com/His/public/HIMSReportViewer.aspx?uniuq_id=${firstReportCode}';
                                    final downloadUrl =
                                        snapshot.data![index].REpoRTPATH ;
                                            
                                    // http://115.112.254.129/NM_TESTING
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             WebViewExample(
                                    //               ReportURl: downloadUrl,
                                    //             )));
                                    //WebViewExample();
                                    // http://115.112.254.129/NM_TESTING/public/HIMSReportViewer.aspx?uniuq_id
                                    //'https://online1.nmmedical.com/link/slims/labreport?rptcd=824980-13231680111';

                                    try {
                                      await launch(downloadUrl);
                                    } catch (e) {
                                      print('Error launching URL: $e');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text("Could not lunch URL")));
                                    }
                                  },
                                  child: Icon(
                                    Icons.download_outlined,
                                    color: Color(0xff123456),
                                  ),
                                )
                              : null,
                        ),
                        if (index < snapshot.data!.length - 1)
                          Divider(indent: 14, endIndent: 14, thickness: 1),
                      ],
                    );
                    // Divider(indent: 14, endIndent: 14, thickness: 1);
                  });
            }
          }),
      bottomNavigationBar: AllBottOMNaviGAtionBar(),
    );
  }
}

class patientDetailsReport {
  final srvname;
  final srvstats1;
  final billNo;
  final displyName;
  final mobNo1;
  final age;
  final gendr;
  final reportCd;
  final Bill_Dt;
  final REpoRTPATH;

  patientDetailsReport({
    required this.srvname,
    required this.srvstats1,
    required this.billNo,
    required this.displyName,
    required this.mobNo1,
    required this.age,
    required this.gendr,
    required this.reportCd,
    required this.Bill_Dt,
    required this.REpoRTPATH,
  });

  factory patientDetailsReport.fromJson(Map<String, dynamic> json) {
    // var pdfdownloader =
    //     json['REPORT_CD'].toString() + json['BILL_NO'].toString();
    return patientDetailsReport(
        srvname: json['SERVICE_NAME'].toString(),
        srvstats1: json['SERVICE_STATUS1'].toString(),
        billNo: json['BILL_NO'].toString(),
        displyName: json['DISPLAY_NAME'].toString(),
        mobNo1: json['MOBILE_NO1'].toString(),
        age: json['AGE'].toString(),
        gendr: json['GENDER'].toString(),
        reportCd: json['REPORT_CD'].toString(),
        Bill_Dt: json['BILL_DT'].toString(),
        REpoRTPATH: json['REPORT_PATH'].toString());
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLength;

  const ExpandableText({
    required this.text,
    required this.maxLength,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool isLongText = widget.text.length > widget.maxLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isExpanded ? widget.text : _getDisplayText(),
          style: TextStyle(
            color: Colors.black,
            height: 1.4,
            letterSpacing: 0.4,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isLongText)
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? 'less' : 'more',
              style: TextStyle(
                color: Color(0xff123456),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  String _getDisplayText() {
    if (widget.text.length > widget.maxLength) {
      return isExpanded
          ? widget.text
          : '${widget.text.substring(0, widget.maxLength)}...';
    }
    return widget.text;
  }
}
