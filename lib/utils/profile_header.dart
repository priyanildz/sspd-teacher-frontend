import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

class ProfileHeader extends StatelessWidget {
  final bool goHome; // Control where back button navigates

  const ProfileHeader({super.key, this.goHome = false}); // Default: normal back

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BackButtonWidget(goHome: goHome), // 🔥 Pass dynamic control
        const Text(
          "My Profile",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              weekday,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
