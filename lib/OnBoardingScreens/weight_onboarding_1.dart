import 'package:flutter/material.dart';

import 'package:water_reminder_app/widgets/appbutton.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 200, 235, 252),
              ),
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    AppButton(
                      formkey: _formkey,
                      weightcontroller: weightcontroller,
                      text: 'Next',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
