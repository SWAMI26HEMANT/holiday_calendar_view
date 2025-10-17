import 'package:flutter/material.dart';
import 'package:holiday_calendar_view/helper.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatefulWidget {
  final DateTime focusedMonth;
  final ValueChanged<DateTime> onMonthChanged;

  const CalendarHeader({
    super.key,
    required this.focusedMonth,
    required this.onMonthChanged,
  });

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  bool _showMonthPicker = false;

  @override
  Widget build(BuildContext context) {
    final months = List.generate(12, (i) => i + 1);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text(
            DateFormat.yMMMM().format(widget.focusedMonth),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: Icon(
              _showMonthPicker ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black87,
              size: 26,
            ),
            onPressed: () {
              setState(() {
                _showMonthPicker = !_showMonthPicker;
              });
            },
          ),
          if (_showMonthPicker)
            Expanded(
              child: Container(
                height: 38,
                padding: const EdgeInsets.only(left: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: months.map((m) {
                    final isSelected = m == widget.focusedMonth.month;
                    return GestureDetector(
                      onTap: () {
                        widget.onMonthChanged(
                          DateTime(widget.focusedMonth.year, m),
                        );
                        setState(() => _showMonthPicker = false);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.deepPurple.withFixedOpacity(0.12)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
                            width: 1.2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            DateFormat.MMMM().format(DateTime(0, m)),
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? Colors.deepPurple : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
