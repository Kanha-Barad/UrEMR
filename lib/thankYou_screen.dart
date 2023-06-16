import 'package:flutter/material.dart';
import 'package:uremr/PatientHome.dart';
import 'package:uremr/Widgets/BottomNavigation.dart';

String Bill_NUMber = "";

class ThankYouScreenOFUploadPrescripTIOn extends StatefulWidget {
  ThankYouScreenOFUploadPrescripTIOn(billno) {
    Bill_NUMber = "";
    Bill_NUMber = billno;
  }

  @override
  State<ThankYouScreenOFUploadPrescripTIOn> createState() =>
      _ThankYouScreenOFUploadPrescripTIOnState();
}

class _ThankYouScreenOFUploadPrescripTIOnState
    extends State<ThankYouScreenOFUploadPrescripTIOn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
                    MaterialPageRoute(builder: ((context) => PatientHome())));
              },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text(
          'Prescription Orders',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 5),
            child: Icon(
              Icons.thumb_up_outlined,
              size: 65,
              color: Color.fromARGB(255, 21, 29, 118),
            ),
          ),
          const Text(
            'Thank You!\nYour Home Visit Slot Has Been Booked.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromARGB(255, 21, 29, 118),
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 70, 10, 4),
            child: Row(
              children: [Text('Order Number'), Spacer(), Text(Bill_NUMber)],
            ),
          ),
          const Divider(
            thickness: 1.8,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 10, 4),
            child: Row(
              children: const [
                Text('Enquiry Date'),
                Spacer(),
                Text('18 Jan 2023')
              ],
            ),
          ),
          const Divider(
            thickness: 1.8,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 10, 4),
            child: Row(
              children: const [
                Text('Enquiry Address'),
                Spacer(),
                SizedBox(
                    width: 140,
                    child:
                        Text('17, Vadsarvala Nivas Mulund West, Mumbai 400054'))
              ],
            ),
          ),
          const Divider(
            thickness: 1.8,
            indent: 10,
            endIndent: 10,
          ),
        ],
      )),
      bottomNavigationBar: AllBottOMNaviGAtionBar(),
    );
  }
}
