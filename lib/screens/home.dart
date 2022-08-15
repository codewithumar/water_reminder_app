import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:water_reminder_app/models/reminder.dart';
import 'package:water_reminder_app/screens/setting.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    weight;
    setState(() {});
    super.initState();
  }

  DateTime _dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
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
                              percent: 0.7,
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
                              )),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        children: [
                          Row(children: [
                            const Text(
                              "000",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 83, 207, 220)),
                            ),
                            const Text(
                              "/",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.black),
                            ),
                            Text(
                              '${((int.parse(weight) * 0.0333) * 1000).round()}',
                              style: const TextStyle(
                                  fontSize: 30, color: Colors.black),
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
                                builddialoag(context, child: buildDatePicker(),
                                    onclicked: () {
                                  final data = Reminder(
                                      watergoal: DateFormat('kk-mm a')
                                          .format(_dateTime)
                                          .toString());
                                  createdata(data);
                                  Navigator.pop(context);
                                });
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
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc('user1')
                      .collection(DateFormat('yyyy-MM-dd').format(_dateTime))
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasError || snapshot.data == null) {
                      return const Center(child: Text("Error in loading "));
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
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
                                  // IconButton(
                                  //   icon: const Icon(Icons.more_vert),
                                  //   onPressed: getPopUp(context),
                                  // ),
                                  PopupMenuButton(
                                      itemBuilder: (BuildContext context) => [
                                            PopupMenuItem(
                                              child: TextButton(
                                                  onPressed: () {
                                                    final doc = FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc('user1')
                                                        .collection(DateFormat(
                                                                'yyyy-MM-dd')
                                                            .format(_dateTime))
                                                        .doc(DateFormat('kk-mm')
                                                            .format(_dateTime));
                                                    doc.delete();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Delete')),
                                            ),
                                            const PopupMenuItem(
                                              child: TextButton(
                                                  onPressed: null,
                                                  child: Text('Edit')),
                                            )
                                          ])
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
              setState(() {
                _dateTime = dateTime;
              });
            }),
      );
}
