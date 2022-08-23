import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:water_reminder_app/Notifications/notification.dart';

import '../models/data.dart';

final _notifications = FlutterLocalNotificationsPlugin();
final onNotifications = BehaviorSubject<String?>();

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  int intake = 0;
  DateTime _selectedDateTime = DateTime.now();
  LocalNotificationService notificationService = LocalNotificationService();
  List<TimeOfDay> reminder = [];
  List<bool> switchValue = [];
  TimeOfDay setTime = TimeOfDay.now();

  @override
  void initState() {
    reminder = [];
    switchValue = [];
    getdata();
    LocalNotificationService.init(initScheduled: true);
    super.initState();
  }

  callback(varIntake) {
    setState(() {
      intake = varIntake;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Schedule'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: reminder.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    reminder[index].format(context),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textScaleFactor: 1.3,
                  ),
                  subtitle: const Text('Water Reminder'),
                  trailing: SizedBox(
                    width: 110,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 50.0,
                          width: 50,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: CupertinoSwitch(
                              activeColor: Colors.teal,
                              value: switchValue[index],
                              onChanged: (value) {
                                setState(() {
                                  switchValue[index] = value;
                                });
                                FirebaseFirestore.instance
                                    .collection('waterschedule')
                                    .doc('togglevalues')
                                    .set({"switchValue": switchValue});
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteTime(index);
                            setState(() {});
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'Add',
        backgroundColor: Colors.teal,
        onPressed: () {
          _selectTime(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _addItemToList(TimeOfDay setTime) {
    List<TimeOfDay> tempList = reminder;
    tempList.add(setTime);
    setState(() {
      reminder = tempList;
    });
  }

  Future<void> _selectTime(BuildContext context, [TimeOfDay? time]) async {
    TimeOfDay? picked = (time == null)
        ? await showTimePicker(
            context: context,
            initialTime: setTime,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: false),
                child: child!,
              );
            },
          )
        : time;

    if (picked != null && picked != setTime) {
      setState(
        () {
          setTime = picked;
          _addItemToList(setTime);

          switchValue.add(true);
          List<String> tempReminder = [];

          for (var item in reminder) {
            tempReminder.add(item.format(context));
          }

          FirebaseFirestore.instance
              .collection('waterschedule')
              .doc('user1')
              .set({"reminders": tempReminder});

          FirebaseFirestore.instance
              .collection('waterschedule')
              .doc('togglevalues')
              .set({"switchValue": switchValue});
        },
      );
      LocalNotificationService.showScheduledNotification(
        title: 'Water is life',
        body: 'Don\'t forget to drink water',
        payload: '',
        scheduledDate: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, setTime.hour, setTime.minute),
      );
    }
  }

  Future<void> _deleteTime(int index) async {
    reminder.removeAt(index);
    switchValue.removeAt(index);
    List<String> tempReminder = [];

    for (var item in reminder) {
      tempReminder.add(item.format(context));
    }
    FirebaseFirestore.instance
        .collection('waterschedule')
        .doc('user1')
        .set({"reminders": tempReminder});
    FirebaseFirestore.instance
        .collection('waterschedule')
        .doc('togglevalues')
        .set({"switchValue": switchValue});

    Fluttertoast.showToast(msg: "Deleted ");
  }

  getdata() async {
    final format = DateFormat.jm();
    var userdata = FirebaseFirestore.instance.collection("waterschedule");

    userdata.doc('user1').get().then((value) {
      setState(() {
        for (var element in List.from(value['reminders'])) {
          TimeOfDay data = TimeOfDay.fromDateTime(format.parse(element));
          reminder.add(data);
        }
      });
    });
    userdata.doc('togglevalues').get().then((value) {
      setState(() {
        for (var element in List.from(value['switchValue'])) {
          bool data1 = element;

          switchValue.add(data1);
        }
      });
    });
  }

  Stream<List<UserData>> readusers() =>
      FirebaseFirestore.instance.collection('waterschedule').snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => UserData.fromuserdata(doc.data()))
                .toList(),
          );
}
