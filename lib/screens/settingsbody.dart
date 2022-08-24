import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:water_reminder_app/screens/reminder.dart';

import '../models/userdata.dart';
import '../OnBoardingScreens/gender_onboarding_2.dart';

class SettingBody extends StatefulWidget {
  const SettingBody({Key? key, required this.userData}) : super(key: key);
  final UserData userData;
  @override
  State<SettingBody> createState() => _SettingBodyState();
}

class _SettingBodyState extends State<SettingBody> {
  final TextEditingController _weightcoltroller = TextEditingController();
  final TextEditingController _gendercoltroller = TextEditingController();
  final TextEditingController _waketimecoltroller = TextEditingController();
  final TextEditingController _sleeptimecoltroller = TextEditingController();
  final TextEditingController _waterintakecoltroller = TextEditingController();
  final TimeOfDay selectedTime = TimeOfDay.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? gender = Stringnames.male.name;
  String genderselcted = Stringnames.male.name;

  @override
  void initState() {
    super.initState();
    _weightcoltroller.text = widget.userData.weight ?? "";
    _waketimecoltroller.text = widget.userData.waketime ?? "";
    _sleeptimecoltroller.text = widget.userData.sleeptime ?? "";
    _gendercoltroller.text = widget.userData.gender ?? "";
    _waterintakecoltroller.text = widget.userData.waterintake ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                              hintText: widget.userData.weight,
                              label: const Text('Weight',
                                  style: TextStyle(color: Colors.teal)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(width: 1.5),
                              ),
                              prefixText: '  ',
                              suffixText: 'Kg',
                              suffixStyle: const TextStyle(color: Colors.teal),
                            ),
                            controller: _weightcoltroller,
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
                              hintText: widget.userData.waketime,
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
                            controller: _waketimecoltroller,
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
                              hintText: widget.userData.sleeptime,
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
                            controller: _sleeptimecoltroller,
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
                              hintText: widget.userData.waterintake,
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
                            controller: _waterintakecoltroller,
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
                    if (_waketimecoltroller.text == _sleeptimecoltroller.text) {
                      Fluttertoast.showToast(
                          msg: 'Bed Time and Wake time cant be same');
                      return;
                    } else {
                      final doc = FirebaseFirestore.instance
                          .collection('users')
                          .doc('user1');
                      doc.update({
                        'weight': _weightcoltroller.text,
                        'sleeptime': _sleeptimecoltroller.text,
                        'waketime': _waketimecoltroller.text,
                        'gender': genderselcted,
                        'waterintake': _waterintakecoltroller.text
                      }).then((value) {
                        Fluttertoast.showToast(msg: "Sueess");
                      });

                      setState(() {});
                    }
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
        ),
      ),
    );
  }

  _getwakeTimeFromUser({required bool isWakeTime}) async {
    var pickedTime = await _showTimePicker();
    String formatTime = pickedTime.format(context);
    if (pickedTime == null) {
    } else if (isWakeTime == true) {
      setState(() {
        _waketimecoltroller.text = formatTime;
      });
    } else if (isWakeTime == false) {
      setState(() {
        _waketimecoltroller.text = formatTime;
      });
    }
  }

  _getTimeFromUser({required bool isWakeTime}) async {
    var pickedTime = await _showTimePicker();
    String formatTime = pickedTime.format(context);
    if (pickedTime == null) {
    } else if (isWakeTime == true) {
      setState(() {
        _sleeptimecoltroller.text = formatTime;
      });
    } else if (isWakeTime == false) {
      setState(() {
        _sleeptimecoltroller.text = formatTime;
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
}
