import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teacher_portal/services/auth_service.dart'; // ✅ Import AuthService for token handling
import 'package:jwt_decoder/jwt_decoder.dart'; 

// const String _baseUrl = "http://192.168.1.37:5000/api"; // ✅ API Base URL
// Change this to your live Vercel link
const String _baseUrl = "https://sspd-teacher-backend.vercel.app/api";

class ApiService {
  // ✅ Login function
static Future<Map<String, dynamic>> login(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse("$_baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      String token = data["token"];
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token); // 🔥 Decode token

      String userId = decodedToken["userId"]; // ✅ Extract userId from token
      await AuthService.saveToken(token);
      await AuthService.saveUserId(userId); // ✅ Save extracted userId
      await AuthService.saveUserData(data["user"]);

      return {"success": true, "data": data};
    } else {
      return {"success": false, "message": data["message"] ?? "Login failed"};
    }
  } catch (e) {
    return {"success": false, "message": "Server error: $e"};
  }
}

  // ✅ Add Event (Requires Token)
  static Future<Map<String, dynamic>> addEvent(String name, String date, String venue, String managedBy) async {
    try {
      String? token = await AuthService.getToken();
      if (token == null) return {"success": false, "message": "User not authenticated"};

      final response = await http.post(
        Uri.parse("$_baseUrl/events/add"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ Include Token
        },
        body: jsonEncode({"name": name, "date": date, "venue": venue, "managedBy": managedBy}),
      );

      final data = jsonDecode(response.body);
      return response.statusCode == 201
          ? {"success": true, "message": "Event added successfully", "data": data}
          : {"success": false, "message": data["message"] ?? "Failed to add event"};
    } catch (e) {
      return {"success": false, "message": "Server error: $e"};
    }
  }

  // ✅ Fetch Events (No Token Required)
  static Future<Map<String, dynamic>> fetchEvents() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/events"),
        headers: {"Content-Type": "application/json"},
      );

      final data = jsonDecode(response.body);
      return response.statusCode == 200
          ? {"success": true, "data": data}
          : {"success": false, "message": data["message"] ?? "Failed to fetch events"};
    } catch (e) {
      return {"success": false, "message": "Server error: $e"};
    }
  }

  // ✅ Fetch Profile (Requires Token)
  static Future<Map<String, dynamic>> fetchProfile() async {
    try {
      String? token = await AuthService.getToken();
      if (token == null) return {"success": false, "message": "User not authenticated"};

      final response = await http.get(
        Uri.parse("$_baseUrl/auth/profile"), // 🔥 Correct route
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);
      return response.statusCode == 200
          ? {"success": true, "data": data}
          : {"success": false, "message": data["message"] ?? "Failed to fetch profile"};
    } catch (e) {
      return {"success": false, "message": "Server error: $e"};
    }
  }

  // ✅ Add Timetable Subjects (Requires Token)
  static Future<Map<String, dynamic>> addTimetableSubjects(String userId, List<Map<String, String>> subjects) async {
    try {
      String? token = await AuthService.getToken();
      if (token == null) return {"success": false, "message": "User not authenticated"};

      final response = await http.post(
        Uri.parse("$_baseUrl/add-my-subjects"), // 🔥 Correct endpoint
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ Include Token
        },
        body: jsonEncode({"user_id": userId, "subjects": subjects}),
      );

      final data = jsonDecode(response.body);
      return response.statusCode == 201 || response.statusCode == 200
          ? {"success": true, "message": "Subjects updated successfully", "data": data}
          : {"success": false, "message": data["message"] ?? "Failed to update subjects"};
    } catch (e) {
      return {"success": false, "message": "Server error: $e"};
    }
  }

  // ✅ Fetch My Subjects (Requires Authentication)
static Future<Map<String, dynamic>> fetchMySubjects() async {
  try {
    String? token = await AuthService.getToken();
    String? userId = await AuthService.getUserId();
    if (token == null || userId == null) {
      return {"success": false, "message": "User not authenticated"};
    }

    final response = await http.get(
      Uri.parse("$_baseUrl/mysubjects?user_id=$userId"), // ✅ Corrected URL
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
    );

    print("🔥 API Response: ${response.body}");  // Debugging

    // 🛑 Check if response is actually JSON
    if (response.headers["content-type"] == null ||
        !response.headers["content-type"]!.contains("application/json")) {
      return {"success": false, "message": "Invalid response from server"};
    }

    final data = jsonDecode(response.body);
    return response.statusCode == 200
        ? {"success": true, "subjects": data["subjects"]}
        : {"success": false, "message": data["message"] ?? "Failed to fetch subjects"};
  } catch (e) {
    return {"success": false, "message": "Server error: $e"};
  }
}

// Fetch timetable for a class on a specific weekday
// ✅ Fetch timetable for a class on a specific weekday (Static + _baseUrl)
static Future<List<dynamic>> fetchTimetable({
  required String standard,
  required String division,
  required String weekday,
}) async {
  final uri = Uri.parse(
    '$_baseUrl/timetable/$standard/$division/$weekday',
  );

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data; // assuming it's already a list
  } else {
    throw Exception('Failed to load timetable');
  }
}

// ✅ Upload timetable (Static + _baseUrl)
static Future<void> uploadTimetable({
  required String standard,
  required String division,
  required List<Map<String, dynamic>> timetable,
}) async {
  final uri = Uri.parse('$_baseUrl/timetable/upload');

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'standard': standard,
      'division': division,
      'timetable': timetable,
    }),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to upload timetable');
  }
}

static Future<Map<String, dynamic>> postAnnouncement(Map<String, dynamic> announcement) async {
  try {
    String? token = await AuthService.getToken();

    // Remove senderId since backend will get it from token
    announcement.remove('senderId');

    final response = await http.post(
      Uri.parse("$_baseUrl/announcement/add-announcement"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(announcement),
    );

    final data = jsonDecode(response.body);
    return response.statusCode == 201
        ? {"success": true, "data": data}
        : {"success": false, "message": data["message"] ?? "Failed to create announcement"};
  } catch (e) {
    return {"success": false, "message": "Server error: $e"};
  }
}


static Future<Map<String, dynamic>> fetchAnnouncements({String? status}) async {
  try {
    String? token = await AuthService.getToken();

    final uri = status != null
        ? Uri.parse('$_baseUrl/announcement/get-announcement?status=$status')
        : Uri.parse('$_baseUrl/announcement/get-announcement');

    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    final data = jsonDecode(response.body);

    return response.statusCode == 200
        ? {"success": true, "announcements": data}
        : {"success": false, "message": "Failed to fetch announcements"};
  } catch (e) {
    return {"success": false, "message": "Server error: $e"};
  }
}

 // Fetch all teachers except current user
  static Future<List<Map<String, dynamic>>> fetchTeachers() async {
  final token = await AuthService.getToken();

  final response = await http.get(
    Uri.parse('$_baseUrl/teachers'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final teachers = data['teachers'] as List;
    return teachers.map((t) => {
          'id': t['_id'],
          'name': t['name'],
        }).toList();
  } else {
    throw Exception('Failed to load teachers');
  }
}

// Send a chat message
// static Future<bool> sendMessage({
//   required String receiverId,
//   required String message,
// }) async {
//   try {
//     String? token = await AuthService.getToken();
//     final res = await http.post(
//       Uri.parse("$_baseUrl/messages/send"),
//       headers: {
//         "Authorization": "Bearer $token",
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode({"receiverId": receiverId, "content": message}),
//     );

//     return res.statusCode == 201;
//   } catch (e) {
//     print("Error sending message: $e");
//     return false;
//   }
// }

// // Fetch chat messages
// static Future<List<Map<String, dynamic>>> fetchMessages(String receiverId) async {
//   try {
//     String? token = await AuthService.getToken();
//     final res = await http.get(
//       Uri.parse("$_baseUrl/messages/$receiverId"),
//       headers: {"Authorization": "Bearer $token"},
//     );

//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       return List<Map<String, dynamic>>.from(data['messages']);
//     } else {
//       return [];
//     }
//   } catch (e) {
//     print("Error loading messages: $e");
//     return [];
//   }
// }






}
