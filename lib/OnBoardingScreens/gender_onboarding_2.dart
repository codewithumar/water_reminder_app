import 'package:flutter/material.dart';

import 'package:water_reminder_app/OnBoardingScreens/datetime_onboarding3.dart';

enum Stringnames { male, female }

class GenderOnBoarding extends StatefulWidget {
  final String weight;
  const GenderOnBoarding({Key? key, required this.weight}) : super(key: key);

  @override
  State<GenderOnBoarding> createState() => _GenderOnBoardingState();
}

class _GenderOnBoardingState extends State<GenderOnBoarding> {
  String? gender = Stringnames.male.name;
  String genderselcted = Stringnames.male.name;

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
                'Please Select your Gender',
                textAlign: TextAlign.start,
              ),
              ListTile(
                title: const Text('Male'),
                leading: Radio<String>(
                    value: 'Male',
                    groupValue: gender,
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
                  value: 'Female',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(
                      () {
                        gender = value;
                        genderselcted = value.toString();
                      },
                    );
                  },
                ),
              ),
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
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (contaxt) => DateTimeOnBoarding(
                                  gender: genderselcted,
                                  weight: widget.weight,
                                )),
                        (route) => false);
                  },
                  child: const Text('Next'))
            ],
          ),
        ),
      ),
    );
  }
}
