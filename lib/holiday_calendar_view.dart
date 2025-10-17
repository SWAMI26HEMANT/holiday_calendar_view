import 'package:flutter/material.dart';
import 'calendar_grid.dart';
import 'calendar_header.dart';
import 'calendar_weekdays.dart';
import 'holiday.dart';

/// Holiday Calendar Widget
class HolidayCalendarView extends StatefulWidget {
  final List<Holiday> holidays;

  const HolidayCalendarView({super.key, required this.holidays});

  @override
  State<HolidayCalendarView> createState() => _HolidayCalendarViewState();
}

class _HolidayCalendarViewState extends State<HolidayCalendarView> {
  DateTime _focusedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CalendarHeader(
          focusedMonth: _focusedMonth,
          onMonthChanged: (newMonth) {
            setState(() {
              _focusedMonth = newMonth;
            });
          },
        ),
        const CalendarWeekdays(),
        const SizedBox(height: 2),
        CalendarGrid(
          focusedMonth: _focusedMonth,
          holidays: widget.holidays,
        ),
      ],
    );
  }
}
