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
import 'package:water_reminder_app/models/waterlevel.dart';

import '../models/userdata.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

String waterintakegoal = '1';

class _HomeState extends State<Home> {
  DateTime _dateTime = DateTime.now();
  DateTime _updateteddate = DateTime.now();

  double level = 0.0;
  int intakelvl = 0;
  double percent = 0;

  Future<void> getintake() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    collectionReference.doc('user1').get().then(
      (value) {
        setState(
          () {
            waterintakegoal = (value)['waterintake'];
            log('water goal $waterintakegoal');
          },
        );
      },
    );
  }

  void updatedallvalues() {
    setState(() {
      getintake();
    });
  }

  @override
  void initState() {
    super.initState();
    updatedallvalues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                            percent: percent,
                            lineHeight: 60,
                            backgroundColor:
                                const Color.fromARGB(255, 224, 247, 253),
                            linearGradient: const LinearGradient(
                              colors: <Color>[
                                Color.fromARGB(255, 13, 77, 98),
                                Color.fromARGB(255, 13, 77, 98),
                                Color.fromARGB(255, 13, 77, 98),
                                Color.fromARGB(255, 20, 141, 155),
                                Color.fromARGB(255, 64, 175, 187),
                                Color.fromARGB(255, 64, 175, 187),
                                Color.fromARGB(255, 117, 203, 212),
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
                                StreamBuilder<WaterLevel>(
                                  stream: readwaterintakelavel(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      //log(snapshot.error.toString());
                                      return const Text("Error");
                                    } else if (snapshot.data == null) {
                                      const Text("null");
                                    } else if (snapshot.hasData) {
                                      final data = snapshot.data;
                                      if (data == null) return const SizedBox();
                                      return SizedBox(
                                        height: 20,
                                        width: 65,
                                        child: Text(
                                          '${data.waterlavel}',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      );
                                    }
                                    return const CircularProgressIndicator();
                                  },
                                ),
                                const Text(
                                  "/",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.black),
                                ),
                                StreamBuilder<UserData>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc('user1')
                                      .snapshots()
                                      .map(
                                        (event) => UserData.fromuserdata(
                                            event.data()!),
                                      ),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text("Error");
                                    } else if (snapshot.data == null) {
                                      const Text("Error");
                                    } else if (snapshot.hasData) {
                                      final users = snapshot.data;
                                      waterintakegoal =
                                          users!.waterintake.toString();

                                      return SizedBox(
                                        height: 20,
                                        width: 65,
                                        child: Text(
                                          users.waterintake.toString(),
                                          style: const TextStyle(fontSize: 20),
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
                              onPressed: () async {
                                if (kDebugMode) {
                                  log("level : $level");
                                  log("waterintakegoal : $waterintakegoal");
                                  log("percent= $percent");
                                }
                                if (double.parse(waterintakegoal) == 1 ||
                                    (level + 250) <=
                                        double.parse(waterintakegoal)) {
                                  setState(
                                    () {
                                      level += 250;
                                      percent =
                                          level / double.parse(waterintakegoal);
                                    },
                                  );

                                  final data = Reminder(watergoal: '$level');
                                  createdata(data);
                                } else {
                                  snackbar("Water level completed", context);
                                }
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
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("No Data"),
                      );
                    } else if (snapshot.hasData) {
                      return Column(children: [
                        Card(
                          elevation: 5.0,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data!.docs[index];
                              return ListTile(
                                leading: const Icon(
                                  Icons.water_drop,
                                  color: Colors.blueAccent,
                                ),
                                title: const Text(
                                  ('250ml'),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                trailing: SizedBox(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      Text(
                                        ds.id,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      PopupMenuButton(
                                        itemBuilder: (BuildContext context) => [
                                          PopupMenuItem(
                                            child: TextButton(
                                              onPressed: () async {
                                                _delete(ds.id);

                                                await FirebaseFirestore.instance
                                                    .collection('lavel')
                                                    .doc('waterlavel')
                                                    .set(
                                                  {"waterlavel": level - 250},
                                                );
                                                setState(() {
                                                  percent = level /
                                                      double.parse(
                                                          waterintakegoal);
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: TextButton(
                                              onPressed: () {
                                                builddialoag(
                                                  context,
                                                  child: buildDatePicker(),
                                                  onclicked: () {
                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc('user1')
                                                        .collection(
                                                          DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(
                                                                  _dateTime),
                                                        )
                                                        .doc(ds.id)
                                                        .delete();
                                                    final data = Reminder(
                                                        watergoal: '$level');
                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc('user1')
                                                        .collection(DateFormat(
                                                                'yyyy-MM-dd')
                                                            .format(_dateTime))
                                                        .doc(DateFormat(
                                                                'kk-mm-ss')
                                                            .format(
                                                                _updateteddate))
                                                        .set(data.toMap())
                                                        .then(
                                                      (value) {
                                                        Fluttertoast.showToast(
                                                            msg: "Sccuess");
                                                      },
                                                    );
                                                    Navigator.of(context).pop();
                                                  },
                                                );
                                              },
                                              child: const Text('Edit'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10)
                      ]);
                    }
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2.0),
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
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleted...!'),
      ),
    );
  }

  Future<void> update(String docid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('user1')
        .collection(
          DateFormat('yyyy-MM-dd').format(_dateTime),
        )
        .doc(docid)
        .delete();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleted...!'),
      ),
    );
  }

  Stream<WaterLevel> readwaterintakelavel() {
    final docref = FirebaseFirestore.instance
        .collection('lavel')
        .doc('waterlavel')
        .snapshots();
    final waterlevelfromdb =
        docref.map((value) => WaterLevel.getwaterlevel(value.data()!));
    return waterlevelfromdb;
  }

  createdata(Reminder data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('user1')
        .collection(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .doc(DateFormat('kk-mm-ss').format(DateTime.now()))
        .set(data.toMap())
        .then(
      (value) {
        Fluttertoast.showToast(msg: "Sccuess");
      },
    );
    FirebaseFirestore.instance
        .collection('lavel')
        .doc('waterlavel')
        .set({"waterlavel": level});
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
        ),
      );

  Widget buildDatePicker() => SizedBox(
        height: 300,
        child: CupertinoDatePicker(
          initialDateTime: _dateTime,
          minimumYear: 2000,
          maximumYear: DateTime.now().year,
          mode: CupertinoDatePickerMode.time,
          onDateTimeChanged: (dateTime) {
            _updateteddate = dateTime;
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
