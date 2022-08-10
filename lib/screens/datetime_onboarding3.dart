import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:water_reminder_app/models/data.dart';
import "package:cloud_firestore/cloud_firestore.dart";

import 'package:water_reminder_app/screens/mainscreen.dart';

class DateTimeOnBoarding extends StatefulWidget {
  final String gender;
  final String weight;
  const DateTimeOnBoarding(
      {Key? key, required this.weight, required this.gender})
      : super(key: key);

  @override
  State<DateTimeOnBoarding> createState() => _DateTimeOnBoardingState();
}

class _DateTimeOnBoardingState extends State<DateTimeOnBoarding> {
  TextEditingController waketime = TextEditingController();
  TextEditingController sleeptime = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 200, 235, 252),
        ),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Please Select your Wakeup Time',
                textAlign: TextAlign.start,
              ),
              TextField(
                  readOnly: true,
                  controller: waketime,
                  style: const TextStyle(fontSize: 30),
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            _selectTime(context);
                            setState(() {
                              waketime.text =
                                  "${selectedTime.hour}:${selectedTime.minute} ";
                            });
                          },
                          icon: const Icon(Icons.watch)))),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Please Select your Sleep Time',
                textAlign: TextAlign.start,
              ),
              TextField(
                  readOnly: true,
                  controller: sleeptime,
                  style: const TextStyle(fontSize: 30),
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            _selectTime2(context);
                            setState(() {
                              sleeptime.text =
                                  "${selectedTime.hour}:${selectedTime.minute} ";
                            });
                          },
                          icon: const Icon(Icons.watch)))),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    final data = UserData(
                      weight: widget.weight,
                      gender: widget.gender,
                      waketime: waketime.text,
                      sleeptime: sleeptime.text,
                    );
                    createdata(data);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (contaxt) => const HomeScreen()),
                        (route) => false);
                  },
                  child: const Text('Next'))
            ],
          ),
        ),
      ),
    );
  }

  Future createdata(UserData data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('user1')
        .set(data.toMap());
    Fluttertoast.showToast(msg: "Sccuess", toastLength: Toast.LENGTH_LONG);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (time != null && time != selectedTime) {
      setState(() {
        selectedTime = time;
        waketime.text = "${selectedTime.hour}:${selectedTime.minute} ";
      });
    }
  }

  Future<void> _selectTime2(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (time != null && time != selectedTime) {
      setState(() {
        selectedTime = time;
        sleeptime.text = "${selectedTime.hour}:${selectedTime.minute} ";
      });
    }
  }
}
