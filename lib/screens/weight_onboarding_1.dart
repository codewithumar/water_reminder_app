import 'package:flutter/material.dart';

import 'package:water_reminder_app/screens/gender_onboarding_2.dart';

class WeightOnBoarding extends StatefulWidget {
  const WeightOnBoarding({Key? key}) : super(key: key);
  @override
  State<WeightOnBoarding> createState() => _WeightOnBoardingState();
}

class _WeightOnBoardingState extends State<WeightOnBoarding> {
  TextEditingController weightcontroller = TextEditingController();
  String weight = '';
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 200, 235, 252),
          ),
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 200),
                const Text(
                  'Weight',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                const SizedBox(height: 100),
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some Weight';
                      } else if (int.parse(value) == 0) {
                        return 'Please enter a valid Weight';
                      }

                      return null;
                    },
                    controller: weightcontroller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        suffixText: 'kG',
                        suffixStyle: TextStyle(color: Colors.black))),
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
                      weight = weightcontroller.text.toString();
                      if (_formkey.currentState!.validate()) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (contaxt) =>
                                    GenderOnBoarding(weight: weight)),
                            (route) => false);
                      }
                    },
                    child: const Text('Next'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
