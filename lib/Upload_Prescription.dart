import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uremr/PatientHome.dart';
import 'package:uremr/Widgets/BottomNavigation.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

String base64Image = "";

class UpLoadPrescrIPtioN extends StatefulWidget {
  const UpLoadPrescrIPtioN({Key? key}) : super(key: key);

  @override
  _UpLoadPrescrIPtioNState createState() => _UpLoadPrescrIPtioNState();
}

class _UpLoadPrescrIPtioNState extends State<UpLoadPrescrIPtioN> {
  final ImagePicker _picker = ImagePicker();
  File? file;
  List<File?> files = [];

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    SingleUserTestBookings() async {
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

      Map data = {
        "PATIENT_ID": "1",
        "UMR_NO": globals.umr_no,
        "TEST_IDS": "",
        "TEST_AMOUNTS": "",
        "CONSESSION_AMOUNT": "",
        "BILL_AMOUNT": "",
        "DUE_AMOUNT": "",
        "MOBILE_NO": globals.mobNO,
        "MOBILE_REG_FLAG": "y",
        "SESSION_ID": globals.Session_ID,
        "PAYMENT_MODE_ID": "1",
        "IP_NET_AMOUNT": "",
        "IP_TEST_CONCESSION": "",
        "IP_TEST_NET_AMOUNTS": "",
        "IP_POLICY_ID": "",
        "IP_PAID_AMOUNT": "0",
        "IP_OUTSTANDING_DUE": "",
        "connection": globals.Patient_App_Connection_String,
        "loc_id": globals.SelectedlocationId,
        "IP_SLOT": globals.Slot_id,
        "IP_DATE": "${selectedDate.toLocal()}".split(' ')[0],
        "IP_UPLOAD_IMG": globals.PresCripTion_Image_Converter,
        "IP_PRESCRIPTION": "",
        "IP_REMARKS": "",
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
        // globals.Bill_No = resposne["Data"][0]["BILL_NO"].toString();
        globals.SelectedlocationId = "";
        globals.Slot_id = "";

        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Booked Successfully!'),
          backgroundColor: Color.fromARGB(255, 26, 177, 122),
          action: SnackBarAction(
            label: "View",
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PatientHome()));
            },
          ),
          // duration: const Duration(seconds: 15),
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
                Navigator.of(context).pop();
              },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text(
          "Upload Prescription",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                XFile? photo = await _picker.pickImage(
                    source: ImageSource.camera,
                    maxHeight: 480,
                    maxWidth: 640,
                    imageQuality: 100,
                    preferredCameraDevice: CameraDevice.rear);

                if (photo == null) {
                } else {
                  setState(() {
                    file = File(photo.path);
                    files.add(File(photo.path));
                    final bytes = File(photo.path).readAsBytesSync();
                    base64Image = base64Encode(bytes);
                  });
                }
              },
              icon: Icon(Icons.camera)),
          // IconButton(
          //     onPressed: () async {
          //       XFile? photo =
          //           await _picker.pickImage(source: ImageSource.gallery);

          //       if (photo == null) {
          //       } else {
          //         setState(() {
          //           file = File(photo.path);
          //           files.add(File(photo.path));
          //           final bytes = File(photo.path).readAsBytesSync();
          //           base64Image = base64Encode(bytes);
          //         });
          //       }
          //     },
          //     icon: Icon(Icons.image))
        ],
      ),
      body: ListView.builder(
          itemCount: files.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return files[index] == null
                ? const Text("No Image Selected")
                : Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 2),
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 83, 115, 148))),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(children: <Widget>[
                          Image.file(
                            files[index]!,
                            fit: BoxFit.cover,
                            height: 480,
                          ),
                        ])),
                  );
          }),
      floatingActionButton: InkWell(
        onTap: () {
          // for (var element in files) {
          //   //  Uint8List? bytes = element.path
          //   final bytes = File(element!.path).readAsBytesSync();
          //   base64Image = base64Encode(bytes);
          // //  globals.TRFImgPath = base64Image + "," + globals.TRFImgPath;
          // }
          // Navigator.pop(context, true);
          globals.PresCripTion_Image_Converter = base64Image;
          (globals.selectedLogin_Data["Data"].length > 1)
              ? _MultiUserListBookingsBottomPicker(context)
              // :
              // (globals.Booking_Status_Flag == "0")
              //     ? Fluttertoast.showToast(
              //         msg: "Booking InProgress",
              //         toastLength: Toast.LENGTH_SHORT,
              //         gravity: ToastGravity.CENTER,
              //         timeInSecForIosWeb: 1,
              //         backgroundColor: Color.fromARGB(230, 228, 55, 32),
              //         textColor: Colors.white,
              //         fontSize: 16.0)
              : SingleUserTestBookings();
        },
        child: const SizedBox(
            height: 40,
            width: 80,
            child: Card(
                color: Color(0xff123456),
                child: Center(
                    child: Text("Upload",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold))))),
      ),
      bottomNavigationBar: AllBottOMNaviGAtionBar(),
    );
  }
}

_MultiUserListBookingsBottomPicker(BuildContext context) {
  var res = showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
          // color: Color.fromARGB(255, 236, 235, 235),
          height: MediaQuery.of(context).size.height * 0.4,
          child: MultiUserBookingsPopup()
          // UserListBookings(globals.selectedLogin_Data, context),
          ));
  print(res);
}

class MultiUserBookingsPopup extends StatefulWidget {
  const MultiUserBookingsPopup({Key? key}) : super(key: key);

  @override
  State<MultiUserBookingsPopup> createState() => _MultiUserBookingsPopupState();
}

class _MultiUserBookingsPopupState extends State<MultiUserBookingsPopup> {
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
        body: MultiUserListBookings(globals.selectedLogin_Data, context),
      ),
    );
  }
}

ListView MultiUserListBookings(var data, BuildContext contex) {
  var myData = data["Data"].length;
  return ListView.builder(
      itemCount: myData,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Container(
            child: MultiUserBookings(data["Data"][index], context, index));
      });
}

Widget MultiUserBookings(data, BuildContext context, index) {
  DateTime selectedDate = DateTime.now();

  MultiUserTestBooking() async {
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

    Map data = {
      "PATIENT_ID": "1",
      "UMR_NO": globals.umr_no,
      "TEST_IDS": "",
      "TEST_AMOUNTS": "",
      "CONSESSION_AMOUNT": "",
      "BILL_AMOUNT": "",
      "DUE_AMOUNT": "",
      "MOBILE_NO": globals.mobNO,
      "MOBILE_REG_FLAG": "y",
      "SESSION_ID": globals.Session_ID,
      "PAYMENT_MODE_ID": "1",
      "IP_NET_AMOUNT": "",
      "IP_TEST_CONCESSION": "",
      "IP_TEST_NET_AMOUNTS": "",
      "IP_POLICY_ID": "",
      "IP_PAID_AMOUNT": "0",
      "IP_OUTSTANDING_DUE": "",
      "loc_id": globals.SelectedlocationId,
      "IP_SLOT": globals.Slot_id,
      "IP_DATE": "${selectedDate.toLocal()}".split(' ')[0],
      "connection": globals.Patient_App_Connection_String,
      "IP_UPLOAD_IMG": globals.PresCripTion_Image_Converter,
      "IP_PRESCRIPTION": "",
      "IP_REMARKS": "",
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
      // globals.Bill_No = resposne["Data"][0]["BILL_NO"].toString();
      globals.Slot_id = "";
      globals.SelectedlocationId = "";

      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Booked Successfully!"),
        backgroundColor: Color.fromARGB(255, 26, 177, 122),
        action: SnackBarAction(
          label: "Go",
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PatientHome()));
          },
        ),
        // duration: const Duration(seconds: 5),
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
      // globals.umr_no = data["UMR_NO"].toString();
      // if (globals.Booking_Status_Flag == "0") {
      //   Fluttertoast.showToast(
      //       msg: "Booking InProgress",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.CENTER,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: Color.fromARGB(230, 228, 55, 32),
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      // } else {
      MultiUserTestBooking();
      // _onLoading();
      //  }
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
