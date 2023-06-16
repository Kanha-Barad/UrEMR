import 'package:shared_preferences/shared_preferences.dart';

var selectedpackages = null;
var mobNO = '';
var MsgId = '';
//var sesson_Id = '';
var flag_index = '0';
var selectedLogin_Data = null;
var selectedIcon = null;
var SelectedPatientDetails = null;
var logindata1 = null;
var Preferedsrvs = null;
String dis_name = '';
String umr_no = '';
String sharedlogindata1 = "";
String shredmobNO1 = "";
String sms_code = "";

// late final SharedPreferences logindata;
class ServerStatus {
  static int newestBinary = 0;
  static bool serverUp = false;
}

late SharedPreferences logindata;
void main() async {
  logindata = await SharedPreferences.getInstance();
  // runApp(new MyApp());
}

// String Connection_Flag = "3";
// String reporturl =
//     "http://115.112.254.129/jariwala_his/PUBLIC/HIMSREPORTVIEWER.ASPX?UNIUQ_ID=";
var addPackage = null;
String patient_id = '';
String Bill_No = '';
String Session_ID = '';
// String Booking_Test_Name = '';
// String Booking_Test_Amount = '';
var TestDetails = null;
String BillNo_For_Test_popup = '';
String Bill_amount_Test_popup = '';
String Login_Flag = '';
var Net_Amount_Coupon = null;
var Discount_Amount_Coupon = null;
var PackageTestInformation = null;
var PatientRepeatOrder = null;
String GlobalDiscountCoupons = '';
String Coupon_Policy_Id = '';
var SelectedlocationId = null;
String Global_All_Client_Api_URL = "https://mobileappjw.softmed.in";
String Global_Patient_Api_URL = "";
String Patient_App_Connection_String = "";
String All_Client_Logo = "";
String Patient_report_URL = "";
String Patient_OTP_URL = "";
var Client_App_Code = null;
var Is_search="";
String selectDate = "";
String SlotsBooked = "";
String Location_BookedTest = "";
String Slot_id = "";

String fromDate = "";
String ToDate = "";

String Booking_Status_Flag = "";
String PresCripTion_Image_Converter = "";


