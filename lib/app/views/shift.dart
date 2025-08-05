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
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      buildShiftCard('משמרת בוקר', shift.hd1.obs, shift.it1.obs, (v) {
                        shift.hd1 = v; // טכנאי בוקר
                        //controller.updateShift(dateKey, shift);
                      }, (v) {
                        shift.it1 = v; // מנהל רשת בוקר
                      }),
                      const SizedBox(height: 16),
                      buildShiftCard('משמרת ערב', shift.hd2.obs, shift.it2.obs, (v) {
                        shift.hd2 = v; // טכנאי ערב
                      }, (v) {
                        shift.it2 = v; // מנהל רשת ערב
                      }),
                    ],
                    ),
                  );
              }),   
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF39B34),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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

}
