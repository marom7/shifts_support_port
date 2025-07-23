import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '/app/views/widgets/build_shift_card.dart';
import '/app/controllers/shift.dart';
import 'widgets/build_day_capsules.dart' as day_capsules;

class ShiftPage extends StatelessWidget {
  final ShiftsController controller = Get.put(ShiftsController());

 ShiftPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF225E75),
      body: SafeArea(
        child: Column(
          children: [
            day_capsules.buildDayCapsules(controller),
            Expanded(
              child: Obx(() {
                final dateKey = DateFormat('dd-MM-yy').format(controller.selectedMonth.value);
                final shift = controller.shifts[dateKey];

                if (shift == null) {
                  return const Center(child: Text("אין נתונים ליום זה", style: TextStyle(color: Colors.white)));
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      buildShiftCard('משמרת בוקר', shift.hd1, shift.it1, (v) {
                        shift.hd1 = v; // טכנאי בוקר
                        //controller.updateShift(dateKey, shift);
                      }, (v) {
                        shift.it1 = v; // מנהל רשת בוקר
                        //controller.updateShift(dateKey, shift);
                      }),
                      const SizedBox(height: 16),
                      buildShiftCard('משמרת ערב', shift.hd2, shift.it2, (v) {
                        shift.hd2 = v; // טכנאי ערב
                        //controller.updateShift(dateKey, shift);
                      }, (v) {
                        shift.it2 = v; // מנהל רשת ערב
                        //controller.updateShift(dateKey, shift);
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
                  final dateKey = DateFormat('dd-MM-yy').format(controller.selectedMonth.value);
                  final shift = controller.shifts[dateKey];
                  if (shift != null) {
                    controller.updateShift(dateKey, shift);
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
