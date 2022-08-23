//import 'dart:developer';

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:water_reminder_app/models/reminder.dart';

import '../models/data.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

String waterintakegoal = '1';

class _HomeState extends State<Home> {
  DateTime _dateTime = DateTime.now();

  double lavel = 0.0;
  int intakelvl = 0;

  @override
  void initState() {
    getintake();
    //getlavelindicator();
    lavel = lavel / int.parse(waterintakegoal);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double indicatorlavel = lavel;
    //log("indiocatorlavel:${indicatorlavel.toString()}");
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Home",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                ),
                const Divider(
                  height: 5,
                  thickness: 1,
                  color: Colors.teal,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(children: const [
                  SizedBox(
                    height: 100,
                    child: Image(image: AssetImage('images/watericon.png')),
                  ),
                  Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Do not drink cold water immediately\nafter hot drinks',
                      ),
                    ),
                  ),
                ]),
                Card(
                  elevation: 5.00,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 60,
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: LinearPercentIndicator(
                            percent: indicatorlavel,
                            lineHeight: 60,
                            backgroundColor:
                                const Color.fromARGB(255, 224, 247, 253),
                            linearGradient: const LinearGradient(
                              colors: <Color>[
                                Color.fromARGB(255, 13, 77, 98),
                                Color.fromARGB(255, 20, 141, 155),
                                Color.fromARGB(255, 64, 175, 187),
                                Color.fromARGB(255, 117, 203, 212),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        children: [
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  intakelvl.toString(),
                                  style: const TextStyle(
                                      fontSize: 30,
                                      color: Color.fromARGB(255, 83, 207, 220)),
                                ),
                                const Text(
                                  "/",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.black),
                                ),
                                StreamBuilder<List<UserData>>(
                                  stream: readusers(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text("Error");
                                    } else if (snapshot.data == null) {
                                      const Text("Error");
                                    } else if (snapshot.hasData) {
                                      final users = snapshot.data;

                                      return SizedBox(
                                        height: 20,
                                        width: 65,
                                        child: ListView(
                                          children: users!
                                              .map(builduserdata)
                                              .toList(),
                                        ),
                                      );
                                    }
                                    return const Center(
                                      child: Center(child: Text('outer ')),
                                    );
                                  },
                                ),
                                const Text(
                                  "ml",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ]),
                          const Text(
                            'You have completed 30%\nof Daily Target',
                            maxLines: 2,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          ElevatedButton.icon(
                              onPressed: () {
                                builddialoag(
                                  context,
                                  child: buildDatePicker(),
                                  onclicked: () {
                                    setState(
                                      () {
                                        if (lavel >= 0 && lavel <= 1) {
                                          if (intakelvl == 0) {
                                            lavel = 250 /
                                                int.parse(waterintakegoal);
                                            intakelvl += 250;
                                            if (kDebugMode) {
                                              log("lavel : $lavel");
                                              log("intakelvl : $intakelvl");
                                              log("intakelvl : $waterintakegoal");
                                            }
                                            final data = Reminder(
                                              watergoal: DateFormat('kk-mm a')
                                                  .format(_dateTime)
                                                  .toString(),
                                              lavelindicator: lavel,
                                            );
                                            createdata(data);
                                          } else if (lavel <= 1.0 &&
                                              intakelvl > 0) {
                                            intakelvl += 250;
                                            lavel = intakelvl /
                                                int.parse(waterintakegoal);
                                            if (lavel > 1.0) {
                                              return;
                                            }
                                            if (kDebugMode) {
                                              log("lavel : $lavel");
                                              log("intakelvl : $intakelvl");
                                            }
                                          } else if (lavel > 1.0) {
                                            if (kDebugMode) {
                                              log("lavel : $lavel");
                                              log("intakelvl : $intakelvl");
                                            }
                                            snackbar('Goal Achived', context);
                                          }
                                        } else {
                                          snackbar('Goal Achived', context);
                                        }
                                      },
                                    );
                                    Navigator.pop(context);
                                  },
                                );
                                FirebaseFirestore.instance
                                    .collection('lavel')
                                    .doc('waterlavel')
                                    .set({'lavel': lavel});
                              },
                              icon: const Image(
                                image: AssetImage('images/glass.png'),
                              ),
                              label: const Text(
                                'Add 250ml',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 5.0,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: const Text("Today’s records"),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc('user1')
                      .collection(DateFormat('yyyy-MM-dd').format(_dateTime))
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasError ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text("No Data"),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data!.docs[index];
                          String watergoaltime = snapshot.data!.docs
                              .elementAt(index)
                              .get('watergoal');
                          return ListTile(
                            leading: const Icon(
                              Icons.water_drop,
                              color: Colors.blueAccent,
                            ),
                            title: const Text(
                              ('250ml'),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            subtitle: Text(
                              watergoaltime,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                            trailing: SizedBox(
                              width: 60,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  PopupMenuButton(
                                    itemBuilder: (BuildContext context) => [
                                      PopupMenuItem(
                                        child: TextButton(
                                          onPressed: () async {
                                            _delete(ds.id);
                                            setState(
                                              () {
                                                if (lavel < 0.0) {
                                                  lavel = 0.0;
                                                  if (intakelvl <= 0) {
                                                    intakelvl = 0;
                                                  } else {
                                                    intakelvl -= 250;
                                                  }
                                                } else {
                                                  if (intakelvl <= 0) {
                                                    intakelvl = 0;
                                                    lavel = lavel -
                                                        (intakelvl / 1000);
                                                  } else {
                                                    intakelvl -= 250;
                                                  }
                                                }
                                              },
                                            );
                                            //Navigator.of(context).pop();
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        semanticsLabel: 'Loading',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _delete(String docid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('user1')
        .collection(
          DateFormat('yyyy-MM-dd').format(_dateTime),
        )
        .doc(docid)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleted...!'),
      ),
    );
    Navigator.of(context).pop();
  }

  Widget builduserdata(UserData data) => Text(
        data.waterintake,
        style: const TextStyle(color: Colors.black, fontSize: 20),
      );

  Stream<List<UserData>> readusers() =>
      FirebaseFirestore.instance.collection('users').snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => UserData.fromuserdata(doc.data()))
                .toList(),
          );
  Future<void> createdata(Reminder data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('user1')
        .collection(DateFormat('yyyy-MM-dd').format(_dateTime))
        .doc(DateFormat('kk-mm').format(_dateTime))
        .set(data.toMap())
        .then((value) {
      Fluttertoast.showToast(msg: "Sccuess");
    });
  }

  void builddialoag(BuildContext context,
          {required Widget child, required VoidCallback onclicked}) =>
      showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
                actions: [child],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: onclicked,
                  child: const Text('Save'),
                ),
              ));

  Widget buildDatePicker() => SizedBox(
        height: 300,
        child: CupertinoDatePicker(
          initialDateTime: _dateTime,
          minimumYear: 2000,
          maximumYear: DateTime.now().year,
          mode: CupertinoDatePickerMode.time,
          onDateTimeChanged: (dateTime) {
            _dateTime = dateTime;
          },
        ),
      );

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbar(
      String msg, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 104, 176, 200),
        content: Text(
          msg,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          textScaleFactor: 1,
        ),
      ),
    );
  }

  String getintake() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    collectionReference.doc('user1').get().then(
      (value) {
        waterintakegoal = (value)['waterintake'];
        setState(
          () {},
        );
      },
    );
    return waterintakegoal;
  }

  // double getlavelindicator() {
  //   CollectionReference collectionReference = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc('user1')
  //       .collection(DateFormat('yyyy-MM-dd').format(_dateTime));
  //   collectionReference.doc(DateFormat('kk-mm').format(_dateTime)).get().then(
  //     (value) {
  //       setState(
  //         () {
  //           lavel = (value)['lavelindicator'];
  //           log("lavel from db:${lavel.toString()}");
  //         },
  //       );
  //     },
  //   );
  //   return lavel;
  // }
}
