import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:water_reminder_app/models/data.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController weightcoltroller = TextEditingController();
  TextEditingController gendercoltroller = TextEditingController();
  TextEditingController waketimecoltroller = TextEditingController();
  TextEditingController sleeptimecoltroller = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  readUserData() async {
    setState(() {
      weightcoltroller.text;
      waketimecoltroller.text;
      sleeptimecoltroller.text;
    });
  }

  @override
  void initState() {
    readUserData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    weightcoltroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<UserData>>(
            stream: readusers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Error in loading "));
              } else if (snapshot.hasData) {
                final users = snapshot.data;
                return ListView(
                  children: users!.map(builduserdata).toList(),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }

  Widget builduserdata(UserData data) => Container(
        margin: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Setting",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              Card(
                elevation: 2.0,
                margin: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 30.0, bottom: 5.0),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        'Weight',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: TextFormField(
                          cursorColor: Colors.teal,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.teal),
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'Enter your weight',
                            label: Text(data.weight.toString(),
                                style: const TextStyle(color: Colors.teal)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(width: 1.5),
                            ),
                            prefixText: '  ',
                            suffixText: 'Kg',
                            suffixStyle: const TextStyle(color: Colors.teal),
                          ),
                          controller: weightcoltroller,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter weight';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        'Gender',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 15),
                      ),
                      TextFormField(
                          initialValue: data.gender,
                          readOnly: true,
                          // controller: gendercoltroller,
                          style: const TextStyle(fontSize: 30),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.person)))),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        'WakeUp Time',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: TextFormField(
                          cursorColor: Colors.teal,
                          keyboardType: TextInputType.none,
                          style: const TextStyle(color: Colors.teal),
                          decoration: InputDecoration(
                            isDense: true,
                            enabled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            label: Text(data.waketime.toString(),
                                style: const TextStyle(color: Colors.teal)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                  color: Colors.teal, width: 1.5),
                            ),
                            prefixText: '  ',
                            suffixIcon: IconButton(
                              onPressed: () {
                                _getwakeTimeFromUser(isWakeTime: false);
                              },
                              icon: const Icon(Icons.access_time,
                                  color: Colors.teal),
                            ),
                            suffixStyle: const TextStyle(color: Colors.teal),
                          ),
                          controller: waketimecoltroller,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Select bed time';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        'Sleep Time',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: TextFormField(
                          cursorColor: Colors.teal,
                          keyboardType: TextInputType.none,
                          style: const TextStyle(color: Colors.teal),
                          decoration: InputDecoration(
                            isDense: true,
                            enabled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            label: Text(data.sleeptime.toString(),
                                style: const TextStyle(color: Colors.teal)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                  color: Colors.teal, width: 1.5),
                            ),
                            prefixText: '  ',
                            suffixIcon: IconButton(
                              onPressed: () {
                                _getTimeFromUser(isWakeTime: false);
                              },
                              icon: const Icon(Icons.access_time,
                                  color: Colors.teal),
                            ),
                            suffixStyle: const TextStyle(color: Colors.teal),
                          ),
                          controller: sleeptimecoltroller,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Select bed time';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              MaterialButton(
                height: 58,
                minWidth: 340,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final doc = FirebaseFirestore.instance
                        .collection('users')
                        .doc('user1');

                    doc.update({
                      'weight': weightcoltroller.text,
                      'sleeptime': sleeptimecoltroller.text,
                      'waketime': waketimecoltroller.text
                    });
                    Fluttertoast.showToast(msg: "Sueess");
                    setState(() {});
                  }
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                color: (Colors.teal),
              ),
            ],
          ),
        ),
      );

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (time != null && time != selectedTime) {
      setState(() {
        selectedTime = time;
        waketimecoltroller.text =
            "${selectedTime.hour}:${selectedTime.minute} ";
        final doc = FirebaseFirestore.instance.collection('users').doc('user1');

        doc.update({
          'waketime': waketimecoltroller.text,
        });

        setState(() {});
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return child!;
      },
    );
  }

  _getwakeTimeFromUser({required bool isWakeTime}) async {
    var pickedTime = await _showTimePicker();
    String formatTime = pickedTime.format(context);
    if (pickedTime == null) {
    } else if (isWakeTime == true) {
      setState(() {
        waketimecoltroller.text = formatTime;
      });
    } else if (isWakeTime == false) {
      setState(() {
        waketimecoltroller.text = formatTime;
      });
    }
  }

  _getTimeFromUser({required bool isWakeTime}) async {
    var pickedTime = await _showTimePicker();
    String formatTime = pickedTime.format(context);
    if (pickedTime == null) {
    } else if (isWakeTime == true) {
      setState(() {
        sleeptimecoltroller.text = formatTime;
      });
    } else if (isWakeTime == false) {
      setState(() {
        sleeptimecoltroller.text = formatTime;
      });
    }
  }

  Future<void> updateWeight(UserData data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data.weight),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: weightcoltroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Weight',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Update'),
                onPressed: () {
                  {
                    final doc = FirebaseFirestore.instance
                        .collection('users')
                        .doc('user1');

                    doc.update({
                      'weight': weightcoltroller.text,
                    });
                    setState(() {});
                    Navigator.of(context).pop();
                  }
                }),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

Stream<List<UserData>> readusers() =>
    FirebaseFirestore.instance.collection('users').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => UserData.fromuserdata(doc.data()))
              .toList(),
        );
