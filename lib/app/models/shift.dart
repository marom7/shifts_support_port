class Shift {
  String hd1;
  String hd2;
  String it1;
  String it2;
  String? holiday;
  String? dateKey;

  Shift({
    required this.hd1,
    required this.hd2,
    required this.it1,
    required this.it2,
    this.holiday,
    this.dateKey,
  });

  factory Shift.fromJson(Map<String, dynamic> json, {String? key}) {
    return Shift(
      hd1: json['hd1'] ?? '',
      hd2: json['hd2'] ?? '',
      it1: json['it1'] ?? '',
      it2: json['it2'] ?? '',
      holiday: json['holiday'] ?? '',
      dateKey: key,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hd1': hd1,
      'hd2': hd2,
      'it1': it1,
      'it2': it2,
      'holiday': holiday ?? '',
    };
  }
}
