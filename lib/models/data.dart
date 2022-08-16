class UserData {
  String weight;
  String gender;
  String waketime;
  String sleeptime;
  String waterintake;

  UserData({
    required this.weight,
    required this.gender,
    required this.sleeptime,
    required this.waketime,
    required this.waterintake,
  });

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'gender': gender,
      'waketime': waketime,
      'sleeptime': sleeptime,
      'waterintake': waterintake
    };
  }

  static UserData fromuserdata(Map<String, dynamic> json) => UserData(
      weight: json['weight'],
      gender: json['gender'],
      waketime: json['waketime'],
      sleeptime: json['sleeptime'],
      waterintake: json['waterintake']);

  static UserData getweight(Map<String, dynamic> json) => UserData(
      weight: json['weight'],
      gender: json['gender'],
      waketime: json['waketime'],
      sleeptime: json['sleeptime'],
      waterintake: json['waterintake']);
}
