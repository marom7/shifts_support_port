class DayShift {
  String hd1; // טכנאי בוקר
  String it1; // מנהל רשת בוקר
  String hd2; // טכנאי ערב
  String it2; // מנהל רשת ערב
  String hd3; // טכנאי לילה  ← חדש
  String it3; // מנהל רשת לילה ← חדש
  String? holiday; //  ← חג
  String? dateKey; // ← מפתח התאריך (פורמט dd-MM-yy)

  DayShift({
    this.hd1 = '',
    this.it1 = '',
    this.hd2 = '',
    this.it2 = '',
    this.hd3 = '', // חדש
    this.it3 = '', // חדש
    this.holiday,
    this.dateKey,
  });

  factory DayShift.fromJson(Map<String, dynamic> j,{String? key}) => DayShift(
    hd1: (j['hd1'] ?? '').toString(),
    it1: (j['it1'] ?? '').toString(),
    hd2: (j['hd2'] ?? '').toString(),
    it2: (j['it2'] ?? '').toString(),
    hd3: (j['hd3'] ?? '').toString(), // חדש
    it3: (j['it3'] ?? '').toString(), // חדש
      holiday: j['holiday'] ?? '',
      dateKey: key,
  );

  Map<String, dynamic> toJson() => {
    'hd1': hd1,
    'it1': it1,
    'hd2': hd2,
    'it2': it2,
    'hd3': hd3, // חדש
    'it3': it3, // חדש
    'holiday': holiday,
  };
}
