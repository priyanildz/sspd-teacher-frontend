import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/screens/main_layout.dart';
import 'package:teacher_portal/screens/event_students_screen.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';
import 'package:teacher_portal/services/api_service.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> events = [];
  List<Map<String, dynamic>> filteredEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  void fetchEvents() async {
    final response = await ApiService.fetchEvents();

    if (response == null) {
      setState(() => isLoading = false);
      print("Error fetching events: Response is null");
      return;
    }

    print("Full API response: $response");

    // 🔥 Fix: access nested 'data' -> 'events'
    if (response["success"] == true &&
        response["data"] != null &&
        response["data"]["success"] == true &&
        response["data"].containsKey("events")) {
      setState(() {
        events = List<Map<String, dynamic>>.from(response["data"]["events"]);
        filteredEvents = List.from(events);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      print("Error fetching events: ${response["data"]?["message"] ?? "Unknown error"}");
    }
  }



  void filterEvents(String query) {
    setState(() {
      filteredEvents = query.isEmpty
          ? List.from(events)
          : events
          .where((event) => event["name"]!
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
    final formattedDay = DateFormat('EEEE').format(DateTime.now());

    return MainLayout(
      selectedIndex: 0,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                Text(
                  "Events",
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(formattedDate,
                        style: TextStyle(fontSize: screenWidth * 0.035)),
                    Text(formattedDay,
                        style: TextStyle(fontSize: screenWidth * 0.035)),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),

            /// 🔹 Title
            Center(
              child: Text(
                "Events List",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(thickness: 2, height: 20),

            /// 🔹 Search Bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Event",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: filterEvents,
            ),
            SizedBox(height: screenHeight * 0.02),

            /// 🔹 Events List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredEvents.isEmpty
                  ? const Center(child: Text("No events found"))
                  : ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];

                  return Container(
                    margin:
                    EdgeInsets.only(bottom: screenHeight * 0.015),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        /// 🔹 Number Box
                        Container(
                          width: screenWidth * 0.1,
                          height: screenHeight * 0.08,
                          color: Colors.blue,
                          alignment: Alignment.center,
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        /// 🔹 Event Details
                        Expanded(
                          child: Container(
                            padding:
                            EdgeInsets.all(screenWidth * 0.03),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event["name"] ?? "Unknown Event",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.045,
                                  ),
                                ),
                                SizedBox(
                                    height: screenHeight * 0.005),
                                Text(
                                  "${event["date"] ?? "Unknown Date"} | ${event["venue"] ?? "Unknown Venue"}",
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.035),
                                ),
                                SizedBox(
                                    height: screenHeight * 0.005),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Managed by ${event["managedBy"] ?? "Unknown Manager"}",
                                        style: TextStyle(
                                          fontSize:
                                          screenWidth * 0.035,
                                          color: Colors.grey,
                                        ),
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EventStudentsScreen(
                                                  eventName:
                                                  event["name"] ??
                                                      "Unknown Event",
                                                  managedBy:
                                                  event["managedBy"] ??
                                                      "Unknown Manager",
                                                  date: event["date"] ??
                                                      "Unknown Date",
                                                  venue:
                                                  event["venue"] ??
                                                      "Unknown Venue",
                                                ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "View Students",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize:
                                          screenWidth * 0.035,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
