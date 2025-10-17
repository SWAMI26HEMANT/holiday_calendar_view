import 'package:flutter/material.dart';
import 'package:holiday_calendar_view/helper.dart';
import 'package:intl/intl.dart';

import 'holiday.dart';

class CalendarGrid extends StatelessWidget {
  final DateTime focusedMonth;
  final List<Holiday> holidays;

  const CalendarGrid({
    super.key,
    required this.focusedMonth,
    required this.holidays,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(focusedMonth.year, focusedMonth.month);
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final startWeekday = firstDay.weekday;
    final totalCells = daysInMonth + startWeekday - 1;

    final List<DateTime?> calendarDays = List.generate(totalCells, (i) {
      if (i < startWeekday - 1) return null;
      return DateTime(focusedMonth.year, focusedMonth.month, i - startWeekday + 2);
    });

    return Expanded(
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final aspectRatio = screenWidth < 400 ? 1.1 : 1.5;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: aspectRatio,
              ),
              itemCount: calendarDays.length,
              itemBuilder: (context, index) {
                final date = calendarDays[index];
                if (date == null) return const SizedBox.shrink();

                final holiday = _findHolidayForDate(date);
                final hasEvent = holiday != null;

                Color dateColor = hasEvent
                    ? Colors.deepPurple
                    : (DateUtils.isSameDay(date, DateTime.now())
                    ? Colors.deepPurple
                    : Colors.black87);

                double fontSize = screenWidth < 400 ? (hasEvent ? 16 : 13) : (hasEvent ? 17 : 15);

                return GestureDetector(
                  onTap: () {
                    if (hasEvent) {
                      _showEventPopup(context, date, [holiday!]);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: DateUtils.isSameDay(date, DateTime.now())
                            ? Colors.deepPurple.withFixedOpacity(0.4)
                            : Colors.transparent,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${date.day}",
                        style: TextStyle(
                          fontSize: fontSize,
                          color: dateColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Holiday? _findHolidayForDate(DateTime date) {
    for (final h in holidays) {
      final parsed = _parseDate(h.date);
      if (parsed != null &&
          parsed.year == date.year &&
          parsed.month == date.month &&
          parsed.day == date.day) {
        return h;
      }
    }
    return null;
  }

  DateTime? _parseDate(String dateString) {
    try {
      return DateFormat("yyyy-MM-dd").parse(dateString);
    } catch (_) {
      return null;
    }
  }

  void _showEventPopup(BuildContext context, DateTime date, List<Holiday> eventsOnDate) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "${DateFormat.MMMM().format(date)} ${date.day}, ${date.year}",
          style: const TextStyle(color: Colors.black87),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: eventsOnDate
              .map(
                (event) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.only(bottom: 12),
              color: Colors.deepPurple.withFixedOpacity(0.1),
              child: Text(
                event.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}
