import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:water_reminder_app/models/data.dart';
import 'package:water_reminder_app/screens/reminder.dart';

enum Stringnames { male, female }

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
  TextEditingController waterintakecoltroller = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? gender = Stringnames.male.name;
  String genderselcted = Stringnames.male.name;

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
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ));
            }));
  }

  Widget builduserdata(UserData data) => Container(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Setting",
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
                            hintText: data.weight,
                            // label:const Text('Weight',
                            //style:  TextStyle(color: Colors.teal)),
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
                      const Text(
                        'Gender',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 15),
                      ),
                      ListTile(
                        title: const Text('Male'),
                        leading: Radio<String>(
                            value: Stringnames.male.name,
                            groupValue: gender,
                            activeColor: Colors.teal,
                            onChanged: (value) {
                              setState(() {
                                gender = value;
                                genderselcted = value.toString();
                              });
                            }),
                      ),
                      ListTile(
                        title: const Text('Female'),
                        leading: Radio<String>(
                            activeColor: Colors.teal,
                            value: 'female',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value;
                                genderselcted = value.toString();
                              });
                            }),
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
                            hintText: data.waketime,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            // label: //const Text('wakeup time',
                            //style: TextStyle(color: Colors.teal)),
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
                        height: 10,
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
                            hintText: data.sleeptime,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
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
                      const Text(
                        'Water Goal',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.teal,
                          style: const TextStyle(color: Colors.teal),
                          decoration: InputDecoration(
                            isDense: true,
                            enabled: true,
                            hintText: data.waterintake,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                  color: Colors.teal, width: 1.5),
                            ),
                            prefixText: '  ',
                          ),
                          controller: waterintakecoltroller,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Select bed time';
                            }
                            return null;
                          },
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ReminderScreen()),
                                (route) => true);
                          },
                          child: const Text(
                            'Reminder Schedule',
                            style: TextStyle(
                                color: Color.fromARGB(255, 117, 203, 212)),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              MaterialButton(
                height: 58,
                minWidth: 340,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onPressed: () async {
                  final doc = FirebaseFirestore.instance
                      .collection('users')
                      .doc('user1');

                  doc.update({
                    'weight': weightcoltroller.text,
                    'sleeptime': sleeptimecoltroller.text,
                    'waketime': waketimecoltroller.text,
                    'gender': genderselcted,
                    'waterintake': waterintakecoltroller.text
                  }).then((value) {
                    Fluttertoast.showToast(msg: "Sueess");
                  });

                  setState(() {});
                },
                color: Colors.teal,
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 24,
                    color: (Colors.white),
                  ),
                ),
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
      initialEntryMode: TimePickerEntryMode.dial,
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

  Stream<List<UserData>> readusers() =>
      FirebaseFirestore.instance.collection('users').snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => UserData.fromuserdata(doc.data()))
                .toList(),
          );
}
