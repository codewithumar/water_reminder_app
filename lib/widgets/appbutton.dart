import 'package:flutter/material.dart';

import '../screens/gender_onboarding_2.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required GlobalKey<FormState> formkey,
    required this.weightcontroller,
    required this.text,
  })  : _formkey = formkey,
        super(key: key);

  final GlobalKey<FormState> _formkey;
  final TextEditingController weightcontroller;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (contaxt) => GenderOnBoarding(
                    weight: weightcontroller.text,
                  ),
                ),
                (route) => false);
          }
        },
        child: Text(text));
  }
}
