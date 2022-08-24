class WaterLevel {
  double waterlavel;

  WaterLevel({required this.waterlavel});

  Map<String, dynamic> toMap() {
    return {
      'waterlavel': waterlavel,
    };
  }

  static WaterLevel getwaterlevel(Map<String, dynamic> map) => WaterLevel(
        waterlavel: map['waterlavel'],
      );
}
