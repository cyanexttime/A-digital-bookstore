import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:oms/API/accessToken.dart';

final readingStatus = {
  "All": "",
  "On Hold": "on_hold",
  "Reading": "reading",
  "Completed": "completed",
  "Dropped": "dropped",
  "Plan to read": "plan_to_read",
  "Re Reading": "re_reading",
};

Future<Map<String, dynamic>> GetALLMangaReadingStatus(
    {required final String query}) async {
  const String baseUrl = "https://api.mangadex.org/manga";
  final String? sessionToken = await GetToken();
  if (query == "All") {
    final response = await http.get(
      Uri.parse("$baseUrl/status"),
      headers: {"Authorization": "Bearer $sessionToken"},
    );
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      if (decodedData['statuses'].isEmpty) {
        return {};
      } else {
        print("sc");
        print(decodedData);
        return decodedData;
      }
    } else {
      print(response.statusCode);
      return {};
    }
  } else {
    final value = readingStatus[query]!;
    final response = await http.get(
      Uri.parse("$baseUrl/status?status=$value"),
      headers: {"Authorization": "Bearer $sessionToken"},
    );
    if (response.statusCode == 200) {
      print(value);
      var decodedData = jsonDecode(response.body);
      if (decodedData['statuses'].isEmpty) {
        print("no sc");
        return {};
      } else {
        // Xử lý trường hợp dữ liệu là một danh sách
        // Bạn có thể trả về phần tử đầu tiên, hoặc kết hợp các phần tử theo cách nào đó
        return decodedData;
      }
    } else {
      return {};
    }
  }
}
