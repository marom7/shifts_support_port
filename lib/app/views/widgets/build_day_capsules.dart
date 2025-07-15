import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/controllers/shift.dart'; // Adjust the import based on your project structure

// Replace 'YourController' with the actual controller class that has 'selectedDay'
Widget buildDayCapsules(ShiftsController controller) {
  final now = DateTime.now();
  final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);

  String getHebrewDayLetter(DateTime date) {
    const days = ['א', 'ב', 'ג', 'ד', 'ה', 'ו', 'שבת'];
    // Flutter: יום ראשון = 7, יום שני = 1 ... יום שבת = 6
    // DateTime.weekday: 1=Monday ... 7=Sunday
    // בעברית: א=ראשון ... ש=שבת
    int index = date.weekday % 7; // ראשון=0, שני=1, ..., שבת=6
    return days[index];
  }

  return Obx(() {
    final selectedDay =
        controller.selectedMonth.value.day; // שימוש ישיר ב-observable
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: daysInMonth,
        itemBuilder: (context, index) {
          final day = index + 1;
          final date = DateTime(now.year, now.month, day);
          final isSelected = selectedDay == day;

          return GestureDetector(
            onTap: () => controller.selectedMonth.value = date,
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
