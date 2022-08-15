class Reminder {
  String watergoal;

  Reminder({required this.watergoal});

  Map<String, dynamic> toMap() {
    return {'watergoal': watergoal};
  }

  static Reminder fromuserdata(Map<String, dynamic> map) =>
      Reminder(watergoal: map['watergoal']);
}
