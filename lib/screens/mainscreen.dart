import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:water_reminder_app/main.dart';
import 'package:water_reminder_app/screens/home.dart';
import 'package:water_reminder_app/screens/setting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<void> getinfo() async {
  int isViewed = 0;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('onBoard', isViewed);
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    getinfo();
  }

  @override
  Widget build(BuildContext context) {
    newuser = false;
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        iconSize: 20,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.water),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    SettingScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
