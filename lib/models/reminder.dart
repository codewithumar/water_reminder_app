class Reminder {
  String watergoal;
  double lavelindicator;

  Reminder({required this.watergoal, required this.lavelindicator});

  Map<String, dynamic> toMap() {
    return {
      'watergoal': watergoal,
      'lavelindicator': lavelindicator,
    };
  }

  static Reminder fromuserdata(Map<String, dynamic> map) => Reminder(
        watergoal: map['watergoal'],
        lavelindicator: map['lavelintake'],
      );
}
