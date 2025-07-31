
// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/controllers/shift.dart';

class DayCapsules extends StatefulWidget {
  final ShiftsController controller;
  const DayCapsules({Key? key, required this.controller}) : super(key: key);

  @override
  State<DayCapsules> createState() => _DayCapsulesState();
}

class _DayCapsulesState extends State<DayCapsules> {
  late ScrollController _scrollController;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _currentMonth = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToThisDay();
    });
  }

  @override
  void didUpdateWidget(covariant DayCapsules oldWidget) {
    super.didUpdateWidget(oldWidget);
    final now = DateTime.now();
    //widget.controller.scrollPosition = now;
    //if (now.month != _currentMonth.month || now.year != _currentMonth.year) {
      _currentMonth = now;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToDay(widget.controller.selectedMonth.value.day); // Scroll to the 13th day as an example
      });
    //}
  }

  // גלילה לפריט ספציפי (אם כל הפריטים באותו רוחב)
  void _scrollToDay(int index) {
    const itemWidth = 40; // רוחב פריט + מרווחים
      _scrollController.animateTo(
      index.toDouble() * itemWidth,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
  void _scrollToThisDay() {
    if (!_scrollController.hasClients) return;

    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final currentDay = now.day;

    // Ensure current day is within valid range
    if (currentDay < 1 || currentDay > daysInMonth) return;

    const itemWidth = 60.0;
    const horizontalMargin = 4.0;
    // ignore: unused_local_variable
    const padding = 8.0;
    const totalItemWidth = itemWidth + horizontalMargin * 2;
    
    // Calculate scroll position to center the current day
    final centerOffset = (currentDay - 1) * totalItemWidth + itemWidth / 2;
    final viewportWidth = _scrollController.position.viewportDimension;
    final scrollOffset = centerOffset - viewportWidth / 2;

    // Apply boundaries to prevent over-scrolling
    final maxScroll = _scrollController.position.maxScrollExtent;
    final minScroll = _scrollController.position.minScrollExtent;
    final adjustedOffset = scrollOffset.clamp(minScroll, maxScroll);

    _scrollController.jumpTo(adjustedOffset);
  }

  String getHebrewDayLetter(DateTime date) {
    const days = ['א', 'ב', 'ג', 'ד', 'ה', 'ו', 'שבת'];
    int index = date.weekday % 7;
    return days[index];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);

    return Obx(() {
      final selectedDay = widget.controller.selectedMonth.value.day;
      return SizedBox(
        height: 70,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: daysInMonth,
          itemBuilder: (context, index) {
            final day = index + 1;
            final date = DateTime(now.year, now.month, day);
            final isSelected = selectedDay == day;

            return GestureDetector(
              onTap: () => widget.controller.selectedMonth.value = date,
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
}