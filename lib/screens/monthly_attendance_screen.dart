import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/screens/main_layout.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

class MonthlyAttendanceScreen extends StatelessWidget {
  const MonthlyAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.textScaleFactorOf(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return MainLayout(
      selectedIndex: 0,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButtonWidget(),
            const Text(
              "Attendance",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04), // Adjust padding dynamically
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Image (Placeholder)
                  Container(
                    width: screenWidth * 0.12, // Responsive width
                    height: screenWidth * 0.12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04), // Responsive spacing
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Student Name",
                        style: TextStyle(fontSize: 18 * textScale, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Class: 5th A  |  Roll no. 01",
                        style: TextStyle(color: Colors.grey, fontSize: 14 * textScale),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Responsive spacing
            Container(height: 2, width: double.infinity, color: Colors.blue),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenWidth * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text("Month", style: _tableHeaderStyle(textScale))),
                  Expanded(child: Center(child: Text("Present", style: _tableHeaderStyle(textScale)))),
                  Expanded(child: Center(child: Text("Absent", style: _tableHeaderStyle(textScale)))),
                  Expanded(child: Center(child: Text("T.D", style: _tableHeaderStyle(textScale)))),
                ],
              ),
            ),
            Container(height: 2, width: double.infinity, color: Colors.blue),
            Expanded(
              child: ListView(
                children: [
                  _buildMonthRow(context, "June", 20, 10, 30, textScale),
                  _buildMonthRow(context, "July", 18, 12, 30, textScale),
                  _buildMonthRow(context, "August", 22, 8, 30, textScale),
                  _buildMonthRow(context, "September", 20, 10, 30, textScale),
                  _buildMonthRow(context, "October", 18, 12, 30, textScale),
                  _buildMonthRow(context, "November", 22, 8, 30, textScale),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _tableHeaderStyle(double textScale) {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: 16 * textScale, color: Colors.black87);
  }

  Widget _buildMonthRow(BuildContext context, String month, int present, int absent, int totalDays, double textScale) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showCalendarPopup(context, month),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenWidth * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(month, style: TextStyle(fontSize: 16 * textScale, fontWeight: FontWeight.bold))),
                Expanded(child: Center(child: Text("$present", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14 * textScale)))),
                Expanded(child: Center(child: Text("$absent", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14 * textScale)))),
                Expanded(child: Center(child: Text("$totalDays", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 * textScale)))),
              ],
            ),
          ),
        ),
        Container(height: 1.5, width: double.infinity, color: Colors.blue),
      ],
    );
  }

  void _showCalendarPopup(BuildContext context, String month) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return CalendarPopup(month: month);
      },
    );
  }
}

class CalendarPopup extends StatefulWidget {
  final String month;
  const CalendarPopup({required this.month});

  @override
  _CalendarPopupState createState() => _CalendarPopupState();
}

class _CalendarPopupState extends State<CalendarPopup> {
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  Map<DateTime, String> attendance = {
    DateTime(2024, 6, 2): "present",
    DateTime(2024, 6, 5): "absent",
    DateTime(2024, 6, 10): "leave",
    DateTime(2024, 6, 15): "present",
    DateTime(2024, 6, 20): "absent",
  };

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(15),
      height: screenHeight * 0.6,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              Text(widget.month, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          _buildLegend(),
          const Divider(),
          Expanded(
            child: TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: focusedDay,
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay;
                  this.focusedDay = focusedDay;
                });
              },
              headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              calendarStyle: const CalendarStyle(todayDecoration: BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.green, "Present"),
        _legendItem(Colors.red, "Absent"),
        _legendItem(Colors.yellow, "Leave"),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 15, height: 15, color: color),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}
