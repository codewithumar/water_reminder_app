class UserData {
  String weight;
  String gender;
  String waketime;
  String sleeptime;

  UserData({
    required this.weight,
    required this.gender,
    required this.sleeptime,
    required this.waketime,
  });

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'gender': gender,
      'waketime': waketime,
      'sleeptime': sleeptime
    };
  }

  static UserData fromuserdata(Map<String, dynamic> json) => UserData(
      weight: json['weight'],
      gender: json['gender'],
      waketime: json['waketime'],
      sleeptime: json['sleeptime']);
}
