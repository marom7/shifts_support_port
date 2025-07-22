// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

void main() {
  // עדכן את הנתיב לקובץ האקסל וה-JSON שלך
  const excelFile = 'shifts-tech2025.xlsx';
  const jsonFile = 'employee-shifts-rtdb-2025.json';

  // הגדר את רשימת החגים (תוכל להרחיב כרצונך)
  final holidays = [
    'שבת', 'פסח', 'סוכות', 'עצמאות', 'ראש השנה', 'יום כיפור', 'שבועות',
    'ע.שבועות', 'ע.סוכות', 'ע.כיפור', 'ע.פסח'
  ];

  // טען את ה-Excel
  final excel = Excel.decodeBytes(File(excelFile).readAsBytesSync());
  final sheet = excel.tables.values.first;

  // הנח: עמודה 0 = תאריך, עמודה 1 = בוקר/שם/חג
  int dayOfWeek=1; // עמודה 1 היא היום בשבוע (1-7, 1=ראשון, 7=שבת)
  //int defDay = DateTime.sunday; // שם ברירת מחדל אם לא נמצא בתאריך

  var shifts = <String, Map<String, String>>{};
  var defaultShift = <int, String>{
    7: "מארק", // שם ברירת מחדל ליום ראשון
    1: "גיא", // שם ברירת מחדל ליום שני
    2: "ניר", // שם ברירת מחדל ליום שלישי
    3: "מרום",  // שם ברירת מחדל ליום רביעי
    4: "דב" , // שם ברירת מחדל ליום חמישי
  };
  for (int row = 1; row < sheet.rows.length; row++)
  {
    for (int col = 0; col < sheet.rows[col].length; col++)
    {
      var cells = sheet.rows[row];
      final dataCell = cells[col]?.value?.toString().trim() ?? "";
      
      final parse = convertToDateFormat(dataCell);// parseDateCell(dataCell);
      var date = parse;//parse['date'] ?? "";
      var nameFromCell = 'מרום';// parse['extra'];
      //defaultShift.values.contains(nameFromCell) ? nameFromCell= parse['extra'].toString().trim()  : nameFromCell = "";
      // אם אין שם אחרי התאריך בעמודת התאריך – ננסה לקחת מהתא הסמוך
      //if (dataCell.isNotEmpty) continue;
     
        if (DateTime.tryParse(dataCell) != null)//date.replaceAll('-', '/')
            dayOfWeek= DateTime.parse(dataCell).weekday;
        else
            date = formatDateTo2025(date); // ננסה לפרמט את התאריך
     
      // זיהוי חג או שם רגיל
      final isHoliday = holidays.any((h) => dataCell.contains(h));
      if (!isHoliday)
      {
        // אם לא חג, ננסה לקחת את השם מהעמודה הבאה
       //final nameFromCell = sheet.rows[row][nameCol]?.value?.toString().trim() ?? "";
        if (nameFromCell.isEmpty) {
          // אם אין שם, נשתמש בשם ברירת מחדל לפי היום בשבוע
          shifts[date] = {
            "hd1": defaultShift[dayOfWeek] ?? "מארק",
            "hd2": "",
            "holiday": "",
            "it1": "",
            "it2": ""
          };
        } else {
          shifts[date] = {
            "hd1": nameFromCell,
            "hd2": "",
            "holiday": "",
            "it1": "",
            "it2": ""
          };
        }
      }
      else
      {
        // אם חג, נשתמש בשם החג
        final nameFromCell = dataCell.split(' ')[0]; // שם החג
      shifts[date] = {
        "hd1": isHoliday ? "" : nameFromCell,
        "hd2": "",
        "holiday": isHoliday ? nameFromCell : "",
        "it1": "",
        "it2": ""
      };
    }
    }
  }
    

  // טען JSON קיים אם יש, ואתחול אם לא
  Map<String, dynamic> jsonDb = {};
  final outFile = File(jsonFile);
  if (outFile.existsSync()) {
    jsonDb = json.decode(outFile.readAsStringSync());
  } else {
    jsonDb = {"shifts": {}, "employyes": {}};
  }

  jsonDb["shifts"] = shifts;
  outFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(jsonDb), encoding: utf8);

  if (kDebugMode) {
    print("ההמרה הושלמה! shifts עודכן.");
  }
}

Map<String, String> parseDateCell(String val) {
  // מחפש תאריך + שם (או חג) - תומך בdd/mm/yy, dd-mm-yy וגם dd-mm yy
  final re = RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-]?(\d{2,4})?\s*[-\s]*(.*)$');
  String date = "";
  String extra = "";
  if (re.hasMatch(val)) {
    var m = re.firstMatch(val)!;
    String d = m.group(1)!.padLeft(2, '0');
    String mth = m.group(2)!.padLeft(2, '0');
    String y = m.group(3) ?? "2025"; // אם השנה לא קיימת, נשתמש ב-2025 כברירת מחדל
    if (y.length == 4) y = y.substring(2, 4);
    date = "$d-$mth-$y";
    extra = m.group(4)?.trim() ?? "";
  } else {
    if (val.contains(' ')) {
      date = val.split(' ')[0]; // אם יש רווח, ניקח רק את התאריך
      extra = val.split(' ')[1]; // השאר זה ה-extra (שם או חג)
    } 
    else {
      date = "";
      extra = "";
    } 
  }
  return {"date": date, "extra": extra};
}

String formatDateTo2025(String inputDate) {
  final re = RegExp(r'^(\d{1,2})/(\d{1,2})$|^(\d{2})/(\d{2})$');
  if (re.hasMatch(inputDate)) {
    final match = re.firstMatch(inputDate)!;
    final day = (match.group(1) ?? match.group(3))!.padLeft(2, '0');
    final month = (match.group(2) ?? match.group(4))!.padLeft(2, '0');
    return '$day-$month-2025';
  } else {
    throw const FormatException('Invalid date format. Expected d/mm, dd/m, or dd/mm.');
  }
}

String convertToDateFormat(String inputDate) {
  final re = RegExp(r'^(\d{1,2})/(\d{1,2})$|^(\d{2})/(\d{2})$');

  if (inputDate.contains(' ')) {
    inputDate = inputDate.split(' ')[0]; // ניקח רק את התאריך
  }

  if (re.hasMatch(inputDate)) {
    final match = re.firstMatch(inputDate)!;
    final day = (match.group(1) ?? match.group(3))!.padLeft(2, '0');
    final month = (match.group(2) ?? match.group(4))!.padLeft(2, '0');
    return "$day-$month-25"; // Default year to 2025
  }

  try {
    // Parse the input date in ISO 8601 format
    DateTime date = DateTime.parse(inputDate);

    // Format the date to dd-mm-yy
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().substring(2)}";
  } catch (e) {
    throw const FormatException('Invalid date format. Expected ISO 8601 or d/mm, dd/m, dd/mm.');
  }
}

