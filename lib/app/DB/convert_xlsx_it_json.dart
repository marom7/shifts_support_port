import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

// עזר: מבנה טווח משמרת
class _ShiftRange {
  final DateTime from;
  final DateTime to;
  final String? it1;
  final String? it2;
  _ShiftRange({required this.from, required this.to, this.it1, this.it2});
}

void main() async {
  // טען את ה-Excel
  // ignore: avoid_print
  print("current path: ${Directory.current.path}");
  const xlsFile = 'shifts-itQ03-2025.xlsx';
  final bytes = File(xlsFile).readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);
  final sheet = excel.tables.values.first;

  // חילוץ הטווחים השבועיים מהאקסל
  final shiftRanges = <_ShiftRange>[];
  String? currentIt1;
  String? currentIt2;
  DateTime? currentFrom;

  for (var row in sheet.rows) {
    var name = row.length > 1 ? row[1]?.value?.toString().trim() ?? '' : '';
    var dateRaw = row.length > 2 ? row[2]?.value?.toString().trim() ?? '' : '';
    var role = row.length > 3 ? row[3]?.value?.toString().trim() ?? '' : '';

    if (name.isNotEmpty && dateRaw.isNotEmpty && role == 'תורן תקלות') {
      if (currentFrom != null && (currentIt1 != null || currentIt2 != null)) {
        shiftRanges.add(_ShiftRange(
          from: currentFrom,
          to: DateTime.parse(dateRaw),
          it1: currentIt1,
          it2: currentIt2,
        ));
      }
      currentFrom = DateTime.parse(dateRaw);
      currentIt1 = name;
      currentIt2 = null;
    } else if (role == 'כונן' && name.isNotEmpty) {
      currentIt2 = name;
    }
  }
  // טווח אחרון: עד שבוע אחרי הסבב האחרון או סוף הטווח הרצוי
  if (currentFrom != null && (currentIt1 != null || currentIt2 != null)) {
    shiftRanges.add(_ShiftRange(
      from: currentFrom,
      to: currentFrom.add(const Duration(days: 7)),
      it1: currentIt1,
      it2: currentIt2,
    ));
  }

  // טען את קובץ ה-JSON הקיים
  final jsonFile = File('employee-shifts-rtdb-2025.json');
  final db = json.decode(await jsonFile.readAsString());
  final Map<String, dynamic> shifts = db['shifts'];

  // עדכן לכל תאריך רלוונטי (רק איפה שקיים כבר ברשימה)
  for (final range in shiftRanges) {
    for (var day = range.from;
        day.isBefore(range.to);
        day = day.add(const Duration(days: 1))) {
      // מפתח בפורמט dd-mm-yy:
      final key = "${day.day.toString().padLeft(2, '0')}-"
                  "${day.month.toString().padLeft(2, '0')}-"
                  "${day.year.toString().substring(2)}";
      if (shifts.containsKey(key)) {
        // עדכן רק את השדות הרלוונטיים, ושמור ערכים קיימים בשדות אחרים
        if (range.it1 != null) shifts[key]['it1'] = range.it1;
        if (range.it2 != null) shifts[key]['it2'] = range.it2;
      }
    }
  }

  // שמור חזרה את הקובץ המעודכן
  await jsonFile.writeAsString(const JsonEncoder.withIndent('  ').convert(db), encoding: utf8);
  if (kDebugMode) {
    print('הקובץ עודכן! ערכי IT1/IT2 מוזנים בהתאם למשמרות מ-shifts-it2025.xlsx');
  }
}
