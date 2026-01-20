import 'package:flutter/material.dart';

class AttendanceToggle extends StatelessWidget {
  final String selectedToggle;
  final Function(String) onToggleChanged;

  const AttendanceToggle({
    Key? key,
    required this.selectedToggle,
    required this.onToggleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100], // Light background
        borderRadius: BorderRadius.circular(16), // Slightly rounded corners
      ),
      padding: EdgeInsets.all(2), // Reduced inner padding
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton("Day"),
          _buildToggleButton("Week"),
          _buildToggleButton("Month"),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text) {
    bool isSelected = text == selectedToggle;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.5), // Reduced space
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Smaller button size
          backgroundColor: isSelected ? Colors.blue : Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Slightly smaller rounding
          ),
        ),
        onPressed: () => onToggleChanged(text), // Call the function to update the toggle
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14, // Slightly smaller font
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
