// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shifts_employees/app/controllers/shift.dart';

class DayCapsules extends StatefulWidget {
  final ShiftsController controller;
  
  const DayCapsules({Key? key, required this.controller}) : super(key: key);

  @override
  State<DayCapsules> createState() => _DayCapsulesState();
}

class _DayCapsulesState extends State<DayCapsules> with RouteAware {
  late ScrollController _scrollController;
  late DateTime _currentDate;
  final _scrollKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _currentDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDay();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // רישום RouteObserver
    final route = ModalRoute.of(context);
    if (route != null) {//Get.find<RouteObserver>().subscribe(this, route);
      Get.put(RouteObserver<Route<dynamic>>());
    }
  }

  @override
  void didUpdateWidget(DayCapsules oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller.selectedMonth.value != oldWidget.controller.selectedMonth.value) {
      _scrollToCurrentDay();
    }
  }
  // נקרא כאשר חוזרים למסך זה
  @override
  void didPopNext() {
    _scrollToCurrentDay();
  }

  @override
  void dispose() {
    Get.find<RouteObserver>().unsubscribe(this);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentDay() {
    if (!_scrollController.hasClients) return;

    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final currentDay = widget.controller.selectedMonth.value.day;

    if (currentDay < 1 || currentDay > daysInMonth) return;

    const itemWidth = 60.0;
    const margin = 8.0;
    const totalItemWidth = itemWidth + margin;
    final viewportWidth = _scrollController.position.viewportDimension;
    final targetOffset = (currentDay - 1) * totalItemWidth - viewportWidth / 2 + itemWidth / 2;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final minScroll = _scrollController.position.minScrollExtent;
    final adjustedOffset = targetOffset.clamp(minScroll, maxScroll);

    _scrollController.animateTo(
      adjustedOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  String _getHebrewDayLetter(DateTime date) {
    const days = ['א', 'ב', 'ג', 'ד', 'ה', 'ו', 'שבת'];
    int index = date.weekday % 7;
    return days[index];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);

    return SizedBox(
      height: 80,
      child: ListView.builder(
        key: _scrollKey,
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: daysInMonth,
        itemBuilder: (context, index) {
          final day = index + 1;
          final date = DateTime(now.year, now.month, day);
          final isSelected = widget.controller.selectedMonth.value.day == day;
          final isToday = day == now.day && now.month == DateTime.now().month && now.year == DateTime.now().year;

          return GestureDetector(
            onTap: () {
              widget.controller.selectedMonth.value = date;
              HapticFeedback.lightImpact();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected 
                    ? const Color(0xFF49C2E1) 
                    : isToday 
                        ? const Color(0xFF1E88E5) 
                        : const Color(0xFF336B87),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected 
                    ? [BoxShadow(color: const Color(0xFF49C2E1).withOpacity(0.5), blurRadius: 8, spreadRadius: 1)]
                    : null,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                        fontSize: isSelected ? 18 : 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getHebrewDayLetter(date),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: isSelected ? 14 : 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}