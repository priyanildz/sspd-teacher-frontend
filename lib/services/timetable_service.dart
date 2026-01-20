import 'package:http/http.dart' as http;
import 'dart:convert';

const String _baseUrl = "http://192.168.1.33:6000/api";

class TimetableService {
  static Future<List<Map<String, dynamic>>> getTimetable(
      String standard, String division, String weekday) async {
    final url = "$_baseUrl/timetable/$standard/$division/$weekday";
    print("Requesting: $url");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      print("Error: ${response.statusCode}, ${response.body}");
      throw Exception('Failed to load timetable');
    }
  }
}
