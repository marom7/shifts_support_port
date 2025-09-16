//import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../models/shift.dart';

class ShiftsController extends GetxController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('shifts');

  var allShifts = <String, DayShift>{};
  var shifts = <String, DayShift>{}.obs;

  /// תאריך החודש הנבחר
  var selectedMonth = DateTime.now().obs;
  late double scrollPosition=-1;
  //RxBool isSaturday = false.obs; 
  final currentRoute = ''.obs;

  @override
  void onInit() {
    //isSaturday.value = DateTime.now().weekday == DateTime.saturday;
    fetchShifts();
   // עדכון הנתיב הנוכחי בכל שינוי
    ever(Get.routing.obs, (Routing? routing) {
      currentRoute.value = routing?.current ?? '';
    });
    // אתחול הנתיב הראשוני
    currentRoute.value = Get.currentRoute;
    super.onInit();
  }

  void selectDate(DateTime date) {
    selectedMonth.value = date;
    HapticFeedback.lightImpact();
  }

  @override
  void onClose() {
    //scrollController.dispose();
    super.onClose();
  }
  /// RTDB-שליפה מלאה מה
  Future<void> fetchShifts() async {
    try {
      final snapshot = await _dbRef.get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final loaded = <String, DayShift>{};

        data.forEach((key, value) {
          final shiftData = Map<String, dynamic>.from(value);
          final model = DayShift.fromJson(shiftData, key: key);
          loaded[key] = model;
        });

        allShifts = loaded;
        filterShiftsByMonth(selectedMonth.value);
      }
    } catch (e) {
      Get.snackbar("שגיאה", "טעינת המשמרות נכשלה: $e");
    }
  }
  /// עדכון משמרת
  Future<void> updateShift(String dateKey, DayShift updatedShift) async {
    try {
      await _dbRef.child(dateKey).set(updatedShift.toJson());
      allShifts[dateKey] = updatedShift..dateKey = dateKey;
      filterShiftsByMonth(selectedMonth.value);
    } catch (e) {
      Get.snackbar("שגיאה", "עדכון נכשל: $e");
    }
  }
  
  /// מעבר חודש אחורה
  void previousMonth() {
    selectedMonth.value = DateTime(selectedMonth.value.year, selectedMonth.value.month - 1);
    filterShiftsByMonth(selectedMonth.value);
  }
  /// מעבר חודש קדימה
  void nextMonth() {
    selectedMonth.value = DateTime(selectedMonth.value.year, selectedMonth.value.month + 1);
    filterShiftsByMonth(selectedMonth.value);
  }
  /// סינון לפי חודש נבחר
  void filterShiftsByMonth(DateTime monthDate) {
    final month = monthDate.month;
    final year = monthDate.year % 100;
    final currentMonthShifts = <String, DayShift>{};

    allShifts.forEach((key, value) {
      try {
        final date = DateFormat('dd-MM-yy').parseStrict(key);
        if (date.month == month && date.year % 100 == year) {
          currentMonthShifts[key] = value;
        }
      } catch (_) {}
    });

    shifts.value = currentMonthShifts;
  }

}

//ScrollController scrollController = ScrollController();
  //double scrollPosition = 0; 
//Future<void> updateShift(String dateKey, DayShift s) async {
//  await db.ref('shifts/$dateKey').update(s.toJson());
//}
  //final selectedMonth = DateTime.now().obs;
  //final scrollController = ScrollController();
