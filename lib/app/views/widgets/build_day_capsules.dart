// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/controllers/shift.dart'; // Adjust the import based on your project structure

// Replace 'YourController' with the actual controller class that has 'selectedDay'
Widget buildDayCapsules(ShiftsController controller) {
  final now = DateTime.now();
  final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
  ScrollController scrollController = ScrollController();
  String getHebrewDayLetter(DateTime date) {
    const days = ['א', 'ב', 'ג', 'ד', 'ה', 'ו', 'שבת'];
    // Flutter: יום ראשון = 7, יום שני = 1 ... יום שבת = 6
    // DateTime.weekday: 1=Monday ... 7=Sunday
    // בעברית: א=ראשון ... ש=שבת
    int index = date.weekday % 7; // ראשון=0, שני=1, ..., שבת=6
    return days[index];
  }
  //double oldPosition =0; // משתנה לאיפוס מיקום הגלילה
  ///////////////////////////////////////
  ///      גלילה של רשימת הימים      //
  ///////////////////////////////////////
  // גלילה למיקום ספציפי (בפיקסלים)
  /*
  void scrollToPosition(double offset) {
    scrollController.animateTo(
      offset,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  // גלילה לתחילת הרשימה
  void scrollToStart() {
    scrollController.jumpTo(0); // מיידי
    // או: _scrollController.animateTo(0, ...)
  }

  // גלילה לסוף הרשימה
  void scrollToEnd() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
*/
  // גלילה לפריט ספציפי (אם כל הפריטים באותו רוחב)
  void scrollToIndex(int index) {
    const itemWidth = 116; // רוחב פריט + מרווחים
      scrollController.animateTo(
      index.toDouble() * itemWidth,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
  
  return Obx(() {
    final selectedDay =
        controller.selectedMonth.value.day; // שימוש ישיר ב-observable
    
    return SizedBox(
      height: 70,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: daysInMonth,
        itemBuilder: (context, index) {
          final day = index + 1;
          final date = DateTime(now.year, now.month, day);
          final isSelected = selectedDay == day;
          try {
            // אם יש גלילה קודמת, גלול למיקום הקודם
            if (scrollController.position.pixels != 0) {
              scrollToIndex(5); // גלילה למיקום הקודם
              //controller.scrollController.jumpTo(controller.scrollPosition);
            }
          } catch (e) {
            // טיפול בשגיאה אם הגלילה לא מצליחה
            print("גלילה נכשלה: $e");
          }
          
          return GestureDetector(
            onTap:  () { 
              controller.selectedMonth.value = date; // עדכון התאריך הנבחר  
              //scrollController.position.pixels = controller.scrollController.position.pixels; //  מיקום הגלילה
              //controller.scrollPosition = scrollController.position.pixels;
              //scrollController.jumpTo(controller.scrollPosition);
              //controller.selectedMonth.value = DateTime(now.year, now.month, day);  
            },  
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF49C2E1)
                    : const Color(0xFF336B87),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(day.toString().padLeft(2, '0'),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(getHebrewDayLetter(date),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  });

}


