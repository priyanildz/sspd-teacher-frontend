import 'package:flutter/material.dart';
import 'package:teacher_portal/utils/profile_header.dart';


class LeaveRequestForm extends StatefulWidget {
  const LeaveRequestForm({super.key});
  @override
  State<LeaveRequestForm> createState() => _LeaveRequestFormState();

}

class _LeaveRequestFormState extends State<LeaveRequestForm> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
      child: Column(
          mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ProfileHeader(),
          SizedBox(height: 20),
          Text(
              "My Leave Request",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 20,),

          Text("Subject:"),
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),

          SizedBox(height: 10,),

          Text("Message:"),
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text("Send", style: TextStyle(color: Colors.white),)),
          )
        ],
      ),
    );
  }
}
