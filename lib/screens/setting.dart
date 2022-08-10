import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:water_reminder_app/models/data.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<UserData>>(
            stream: readusers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text("Error in loading ${snapshot.error}"));
              } else if (snapshot.hasData) {
                final users = snapshot.data;
                return ListView(
                  children: users!.map(builduserdata).toList(),
                );
              }
              return const Text("Error");
            }));
  }

  Widget builduserdata(UserData data) => Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Weight'),
                    TextFormField(
                        initialValue: data.weight,
                        readOnly: true,
                        // controller: data.sleeptime,
                        style: const TextStyle(fontSize: 30),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.numbers)))),
                    TextFormField(
                        initialValue: data.gender,
                        readOnly: true,
                        // controller: data.sleeptime,
                        style: const TextStyle(fontSize: 30),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.person)))),
                    TextFormField(
                        initialValue: data.waketime,
                        readOnly: true,
                        // controller: data.sleeptime,
                        style: const TextStyle(fontSize: 30),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.timer)))),
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                        initialValue: data.sleeptime,
                        readOnly: true,
                        // controller: data.sleeptime,
                        style: const TextStyle(fontSize: 30),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.timer)))),
                  ],
                ),
              ),
            ]),
      );

  Stream<List<UserData>> readusers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => UserData.fromuserdata(doc.data()))
          .toList());
}
