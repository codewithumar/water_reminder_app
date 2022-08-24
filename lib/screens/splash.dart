import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_reminder_app/main.dart';
import 'package:water_reminder_app/screens/mainscreen.dart';
import 'package:water_reminder_app/OnBoardingScreens/weight_onboarding_1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    goToHome();
  }

  goToHome() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => pref.getInt('onBoard') != 0
            ? const WeightOnBoarding()
            : const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Image(
                  image: AssetImage('images/watericon.png'),
                ),
              ),
              Text(
                'Water Reminder App',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ]),
      ),
    );
  }
}
