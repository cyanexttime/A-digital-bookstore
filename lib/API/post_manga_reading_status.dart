
import 'dart:convert';





import 'package:http/http.dart' as http;
import 'package:oms/API/accessToken.dart';

Map<String,String> status ={
  "On Hold":"on_hold",
  "Reading":"reading",
  "Dropped":"completed",
  "Plan to Read":"dropped",
  "Completed":"plan_to_read",
  "Re-reading":"re_reading",
};



Future<String> PostUpdateReadingStatus( {
  required String idmanga,
  required String tempstatus,
}) async {
  const String baseUrl = "https://api.mangadex.org/manga";
  final String? sessionToken = await GetToken();
  final response = await http.post(
    Uri.parse("$baseUrl/$idmanga/status"),
    headers: {
      "Authorization": "Bearer $sessionToken",
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'status': status[tempstatus]!,
    }),
  );
  if (response.statusCode == 200) {
      print("sc");
      return (response.statusCode).toString();
  }
  else {
      print('Error: ${response.statusCode}');
      return (response.statusCode).toString();
  }
}
  // Add a return statement h


