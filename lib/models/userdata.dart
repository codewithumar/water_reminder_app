class UserData {
  String? weight;
  String? gender;
  String? waketime;
  String? sleeptime;
  String? waterintake;

  UserData({
    this.weight,
    this.gender,
    this.sleeptime,
    this.waketime,
    this.waterintake,
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
}
