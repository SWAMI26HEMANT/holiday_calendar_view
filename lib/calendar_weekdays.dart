import 'package:flutter/material.dart';

class CalendarWeekdays extends StatelessWidget {
  const CalendarWeekdays({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      child: Row(
        children: days
            .map((day) => Expanded(
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          ),
        ))
            .toList(),
      ),
    );
  }
}
