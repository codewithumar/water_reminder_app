import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:water_reminder_app/models/userdata.dart';
import 'package:water_reminder_app/screens/settingsbody.dart';

enum Stringnames { male, female }

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<UserData>(
        stream: readuser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error in loading "));
          } else if (snapshot.hasData) {
            final userData = snapshot.data;
            if (userData == null) return const SizedBox();
            return SettingBody(userData: userData);
          }
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          );
        },
      ),
    );
  }

  Stream<UserData> readuser() {
    final docref =
        FirebaseFirestore.instance.collection('users').doc('user1').snapshots();
    final userdata =
        docref.map((event) => UserData.fromuserdata(event.data()!));
    return userdata;
  }
}
