import 'package:flutter/material.dart';

class TimeBooking extends StatefulWidget {
  final Function(String?) onTimeChanged; // Add onTimeChanged function

  const TimeBooking({
    Key? key,
    required this.onTimeChanged,
    required Color bColor,
    required Color pColor,
    required Color sdColor,
    required DateTime selectedValue,
  }) : super(key: key);

  @override
  State<TimeBooking> createState() => _TimeBookingState();
}

class _TimeBookingState extends State<TimeBooking> {
  late List<String> morningTimes;
  late List<String> eveningTimes;
  late List<String> nightTimes;

  String? selectedTime; // Variable to store the selected time

  @override
  void initState() {
    super.initState();
    morningTimes = ["8:00", "9:00", "10:00", "11:00"];
    eveningTimes = ["15:00", "16:00", "17:00", "18:00"];
    nightTimes = ["19:00", "20:00", "21:00", "22:00"];
  }

  @override
  Widget build(BuildContext context) {
    const Color bColor = Colors.black;
    const Color pColor = Color(0XFFE8F3FF);
    const Color sdColor = Colors.black12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimeRow("Morning", morningTimes, 0, bColor, pColor, sdColor),
        _buildTimeRow("Evening", eveningTimes, 1, bColor, pColor, sdColor),
        _buildTimeRow("Night", nightTimes, 2, bColor, pColor, sdColor),
      ],
    );
  }

  Widget _buildTimeRow(String title, List<String> times, int index,
      Color bColor, Color pColor, Color sdColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontFamily: 'poppins'),
          ),
        ),
        Container(
          height: 42,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: times.length,
            itemBuilder: (context, idx) {
              String time = times[idx];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTime = time; // Update selected time
                    widget.onTimeChanged(
                        selectedTime); // Pass selected time to parent widget
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 7),
                  width: 63,
                  decoration: BoxDecoration(
                    color: time == selectedTime ? pColor : Colors.white,
                    border: Border.all(
                      color: time == selectedTime
                          ? Colors.blue
                          : const Color(0XFFF1F1F1),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'poppins',
                        color: time == selectedTime
                            ? bColor
                            : bColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
