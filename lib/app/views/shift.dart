import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'widgets/build_shift_card.dart';
import '/app/controllers/shift.dart';
//import 'widgets/build_day_capsules.dart' as day_capsules;
import 'widgets/days_capsules.dart' as day_capsules; // Importing the DayCapsules widget by DeepSeek

class ShiftPage extends StatelessWidget {
  final ShiftsController _controller = Get.put(ShiftsController());
  ShiftPage({super.key});

  @override
  Widget build(BuildContext context) {
   
    // בניית המסך הרגיל
    return Scaffold(
      backgroundColor: const Color(0xFF225E75),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 7),
            day_capsules.DayCapsules(controller: _controller,), // Using the DayCapsules widget
            Expanded(
              child: Obx(() {
                if (_controller.shifts.isEmpty) {
                  return const Center(child: Text("הנתונים עדיין נטענים...", style: TextStyle(color: Colors.white)));
                }
                final dateKey = DateFormat('dd-MM-yy').format(_controller.selectedMonth.value);
                final shift = _controller.shifts[dateKey];
                //day_capsules.
                if (shift == null) {
                  return const Center(child: Text("אין נתונים ליום זה", style: TextStyle(color: Colors.white)));
                }
                if (_controller.selectedMonth.value.weekday == DateTime.saturday) {
                  return holidayFullScreen(
                    'שבת שלום!\nאין משמרות בשבת',
                    assetPng: 'assets/images/shabbat.png',
                    bg: const Color(0xFF1A374D),
                  );
                }
                return SafeArea(
                 // padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                        buildShiftCard('משמרת בוקר', shift.hd1.obs, shift.it1.obs, (v) {
                          shift.hd1 = v; // טכנאי בוקר
                        }, (v) {
                          shift.it1 = v; // מנהל רשת בוקר
                        }),
                        //const SizedBox(height: 1),
                        buildShiftCard('משמרת ערב', shift.hd2.obs, shift.it2.obs, (v) {
                          shift.hd2 = v; // טכנאי ערב
                        }, (v) {
                          shift.it2 = v; // מנהל רשת ערב
                        }),
                        //const SizedBox(height: 1),
                        // ↓↓↓ חדש: לילה
                        buildShiftCard('כוננות לילה', shift.hd3.obs, shift.it3.obs, (v) {
                          shift.hd3 = v; // טכנאי לילה
                        }, (v) {
                          shift.it3 = v; // מנהל רשת לילה
                        }),
                    ],
                    ),
                  );
              }),   
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF39B34),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  final dateKey = DateFormat('dd-MM-yy').format(_controller.selectedMonth.value);
                  final shift = _controller.shifts[dateKey];
                  if (shift != null) {
                    _controller.updateShift(dateKey, shift);
                    Get.snackbar("הצלחה", "המשמרת עודכנה ליום $dateKey");
                  }
                },
                child: const Text("עדכן", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget holidayFullScreen(String title, {String? assetPng, Color? bg}) {
 // final v = assetPng != null && bg != null
   //   ? HolidayVisuals(title, assetPng, bg)
   //   : visualsFor(title);

  return Container(
    color: bg ?? const Color(0xFF225E75),
    width: double.infinity,
    height: double.infinity,
    child: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetPng ?? '', width: 220, height: 220, fit: BoxFit.contain),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //const SizedBox(height: 8),
          //const Text(
         //   'אין משמרות בתאריך זה',
         //   style: TextStyle(color: Colors.white70, fontSize: 16),
         // ),
        ],
      ),
    ),
  );
}

}
