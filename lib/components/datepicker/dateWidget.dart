import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'gestures/tap.dart';

class DateWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final DateTime date;
  final TextStyle? monthTextStyle, dayTextStyle, dateTextStyle;
  final Color selectionColor;
  final DateSelectionCallback? onDateSelected;
  final String? locale;

  DateWidget({
    required this.date,
    required this.monthTextStyle,
    required this.dayTextStyle,
    required this.dateTextStyle,
    required this.selectionColor,
    this.width,
    this.height,
    this.onDateSelected,
    this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: selectionColor,
        border: Border.all(
          color: Color(0XFFF1F1F1), // Border color
          width: 1, // Border width
        ),
      ),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  new DateFormat("MMM", locale)
                      .format(date)
                      .toUpperCase(), // Month
                  style: _getMonthTextStyle()),
              Text(date.day.toString(), // Date
                  style: _getDateTextStyle()),
              Text(
                  new DateFormat("E", locale)
                      .format(date)
                      .toUpperCase(), // WeekDay
                  style: _getDayTextStyle())
            ],
          ),
        ),
        onTap: () {
          // Check if onDateSelected is not null
          if (onDateSelected != null) {
            // Call the onDateSelected Function
            onDateSelected!(this.date);
          }
        },
      ),
    );
  }

  TextStyle _getMonthTextStyle() {
    return monthTextStyle ?? TextStyle(color: Colors.black);
  }

  TextStyle _getDateTextStyle() {
    return dateTextStyle ?? TextStyle(color: Colors.black);
  }

  TextStyle _getDayTextStyle() {
    return dayTextStyle ?? TextStyle(color: Colors.black);
  }
}
