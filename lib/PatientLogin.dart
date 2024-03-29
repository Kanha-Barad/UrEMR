import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'PatientHome.dart';
import 'PatientRegistration.dart';
import 'ValidateOTP.dart';
import 'globals.dart' as globals;

var isvalidmob = [];
TextEditingController MobileNocontroller = TextEditingController();

var Login_flag = '';

class PatientLogin extends StatefulWidget {
  PatientLogin(flag) {
    Login_flag = '';
    if (flag.length == 10) {
      MobileNocontroller.text = flag.toString();
    }
    Login_flag = flag;
  }

  //String flg = flag1.toString();
  @override
  State<PatientLogin> createState() => _PatientLoginState();
}

class _PatientLoginState extends State<PatientLogin> {
  var myFocusNode = FocusNode();
  bool isLoading = false;

  get Math => null;
  @override
  void initState() {
    myFocusNode.addListener(() {
      print(myFocusNode.hasFocus);
    });
    super.initState();
  }

  SendingOTP(mobno, BuildContext context) async {
    if (MobileNocontroller.text.length != 10) {
      return false;
    }
    Random random = new Random();
    int randomNumber = random.nextInt(9999);
    var url = "http://api.pinnacle.in/index.php/sms/send/DRJLAB/" +
        mobno +
        "/Dear customer, your OTP is " +
        randomNumber.toString() +
        " to use our new Dr. Jariwala Lab app  ./TXT?apikey=aad947-f9f8e9-af03de-ef2604-9ae037&dltentityid=1501641410000037214&dlttempid=1507165573354184822";
    await http.get(Uri.parse(url));

    Fluttertoast.showToast(
        msg: "OTP sent sucessfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(189, 59, 227, 180),
        textColor: Colors.white,
        fontSize: 16.0);
    EnterMobNo(MobileNocontroller.text.toString(), randomNumber.toString());
  }

  EnterMobNo(mobno, RandomOTP) async {
    var isLoading = true;
    if (mobno.length != 10) {
      mobileError();
      return false;
    }

    Map data = {
      "mobile": mobno,
      "session_Id": RandomOTP.toString(),
      "connection": globals.Patient_App_Connection_String
      //"Server_Flag":""
    };
    print(data.toString());

    final response = await http.post(
        Uri.parse(globals.Global_Patient_Api_URL + '/PatinetMobileApp/Login'),
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
      globals.mobNO = MobileNocontroller.text.toString();

      globals.selectedLogin_Data = jsonDecode(response.body);
      globals.umr_no = resposne["Data"][0]['UMR_NO'].toString();
      globals.MsgId =
          resposne["Data"][0]["MSG_ID"].toString().split('.')[0].toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("Msg_id", globals.MsgId);
      prefs
          .setString('Mobileno', MobileNocontroller.text.toString())
          .toString();

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ValidateOTP(Login_flag.toString())));
      MobileNocontroller.text = "";
    } else {}
  }

  bool isButtonDisabled = false;

  Future<void> SendOTPtoMobileNUmber() async {
    if (!isButtonDisabled) {
      setState(() {
        isButtonDisabled = true; // Disable the button
        isLoading = true; // Start loading
      });

      await EnterMobNo1(MobileNocontroller.text, "");

      // No need for the delay here

      // Enable the button and stop loading
      setState(() {
        isButtonDisabled = false;
        isLoading = false;
      });
    }
  }

  EnterMobNo1(mobno, RandomOTP) async {
    isvalidmob = [];

    var isLoading = true;
    if (mobno.length != 10) {
      mobileError();
      return false;
    }

    Map data = {
      "mobile": mobno,
      "session_Id": "",
      "connection": globals.Patient_App_Connection_String
      //"Server_Flag":""
    };
    print(data.toString());

    final response = await http.post(
        Uri.parse(globals.Global_Patient_Api_URL + '/PatinetMobileApp/Login'),
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
      if (resposne["Data"][0]["MOBILE_NO"].toString() == "null") {
        //isvalidmob = resposne["Data"][0]["MOBILE_NO"];
        Fluttertoast.showToast(
          msg: "Please Register Your Mobile Number",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 235, 103, 93),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        SendingOTP(MobileNocontroller.text, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: ListView(
              // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 80, 0, 45),
                  child: SizedBox(
                      height: 150.0,
                      width: 150.0,
                      child:
                          Image(image: NetworkImage(globals.All_Client_Logo))),
                ),

                Center(
                  child: Text(
                    'Please Login to Continue your Profile',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a mobile number';
                        } else if (value.length != 10) {
                          return 'Mobile number must be 10 digits long';
                        }
                        return null; // Return null if the input is valid
                      },
                      focusNode: myFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      // obscureText: true,
                      controller: MobileNocontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        prefixIcon: Icon(Icons.phone_android),
                        focusColor: Color(0xff123456),
                        hintText: 'Enter 10 digit mobile number',
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          SendOTPtoMobileNUmber();
                        },
                        child: Card(
                            color: Color(0xff123456),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(18, 12, 18, 12),
                              child: Text('Send OTP',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PatientHome()));
                        },
                        child: Card(
                            color: Color.fromARGB(255, 177, 199, 234),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(25, 11, 25, 11),
                              child: Text('Cancel',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a User? ', style: TextStyle(fontSize: 15)),
                    InkWell(
                        child: Text('Register',
                            style: TextStyle(
                                color: Color(0xff123579),
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                        onTap: () {
                          NameController.text = '';
                          MobNoController.text = '';
                          AgeController.text = '';
                          MailIdController.text = '';
                          AddressController.text = '';
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PatientRegister()));
                        }),
                  ],
                ),

                TextButton(
                  child: Text(
                    'By Clicking above to login, you\'r agreeing to our',
                    style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                  onPressed: () {},
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Terms & Conditions ',
                              style: TextStyle(color: Color(0xff123456))),
                          TextSpan(
                              text: '& ',
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(color: Color(0xff123456)))
                        ],
                      ),
                    ),
                  ),
                ),
                // UserProfileverticalLists
              ]),
        ),
        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotateMultiple,
                  colors: [
                    // Color.fromARGB(255, 49, 213, 169),
                    // Color.fromARGB(255, 246, 246, 246),
                    Color.fromARGB(255, 49, 114, 179),
                  ],
                  strokeWidth: 4.0,
                ),
              ),
            ),
          ),
      ]),
    );
  }
}

mobileError() {
  return Fluttertoast.showToast(
      msg: "Enter 10 Digit Mobile Number",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 235, 103, 93),
      textColor: Colors.white,
      fontSize: 16.0);
}

Validatemobno() {
  return Fluttertoast.showToast(
      msg: "Not registered",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 235, 103, 93),
      textColor: Colors.white,
      fontSize: 16.0);
}

OTPError() {
  return Fluttertoast.showToast(
      msg: "please Enter OTP",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 235, 103, 93),
      textColor: Colors.white,
      fontSize: 16.0);
}

class PatientDataICon {
  final mob_no;
  final session_ID;
  final display_name;
  final gender;
  final email_id;
  final address;
  final date_of_birth;
  final umr_no;
  PatientDataICon({
    required this.mob_no,
    required this.session_ID,
    required this.display_name,
    required this.gender,
    required this.email_id,
    required this.address,
    required this.date_of_birth,
    required this.umr_no,
  });
  factory PatientDataICon.fromJson(Map<String, dynamic> json) {
    if (json['EMAIL_ID'] == null || json['EMAIL_ID'] == "") {
      json['EMAIL_ID'] = 'Not Specified.';
    }
    if (json['ADDRESS1'] == null || json['EMAIL_ID'] == "") {
      json['ADDRESS1'] = 'Not Specified.';
    }
    return PatientDataICon(
      mob_no: json['MOBILE_NO1'].toString(),
      session_ID: json['SESSION_ID'].toString(),
      display_name: json['DISPLAY_NAME'].toString(),
      gender: json['GENDER'].toString(),
      email_id: json['EMAIL_ID'].toString(),
      address: json['ADDRESS1'].toString(),
      date_of_birth: json['DOB'].toString(),
      umr_no: json['UMR_NO'].toString(),
    );
  }
}

/*-------------------------------------For patient Icon--------------------------------------*/
loginerror() {
  return Fluttertoast.showToast(
      msg: "Failed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 235, 103, 93),
      textColor: Colors.white,
      fontSize: 16.0);
}
