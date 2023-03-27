import 'package:flutter/material.dart';
import './PatientHome.dart';

class notifiCation extends StatefulWidget {
  const notifiCation({Key? key}) : super(key: key);

  @override
  State<notifiCation> createState() => _notifiCation();
}

class _notifiCation extends State<notifiCation> {
  // List of items in our dropdown menu

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Notifications',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_add_outlined,
                        color: Colors.purple,
                        size: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 250,
                              child: Text(
                                'You have got 500 loyalty point against order 100233112 order number.',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Insure now.',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.more_vert_rounded,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ],
                  ),
                )),
                Card(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_add_outlined,
                        color: Colors.purple,
                        size: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 250,
                              child: Text(
                                'New profiles has been added check it Now.',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Insure now.',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.more_vert_rounded,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ],
                  ),
                )),
                Card(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_add_outlined,
                        color: Colors.purple,
                        size: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 250,
                              child: Text(
                                'Your Creatinine value is normal against order 12100099 order number.',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Insure now.',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.more_vert_rounded,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ],
                  ),
                )),
                Card(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_add_outlined,
                        color: Colors.purple,
                        size: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 250,
                              child: Text(
                                'Your reports are ready against 123000042 order number.',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Insure now.',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.more_vert_rounded,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
