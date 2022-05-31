
import 'package:flutter/material.dart';

/// [CalendarHeader] is a widget to show calendar header.
/// 
class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const <Widget>[
        Image(
          image: AssetImage("assets/images/calendar.png"),
          width: 30,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "CREATE YOUR CALENDAR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
