// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:oms/API/accessToken.dart';

Map<String, String> status = {
  "On Hold": "on_hold",
  "Reading": "reading",
  "Dropped": "dropped",
  "Plan to Read": "plan_to_read",
  "Completed": "completed",
  "Re-Reading": "re_reading",
};

Future<String> PostUpdateReadingStatus({
  required String idmanga,
  required String tempstatus,
}) async {
  const String baseUrl = "https://api.mangadex.org/manga";
  final String? sessionToken = await GetToken();
  print(tempstatus);
  if (tempstatus == "None") {
    final response = await http.post(
      Uri.parse("$baseUrl/$idmanga/status"),
      headers: {
        "Authorization": "Bearer $sessionToken",
      },
      body: jsonEncode({"status": null}),
    );
    if (response.statusCode == 200) {
      print("sc none");
      return (response.statusCode).toString();
    } else {
      print('no sc none ');
      return (response.statusCode).toString();
    }
  } else {
    String mappedStatus = status[tempstatus] ?? tempstatus;
    final response = await http.post(
      Uri.parse("$baseUrl/$idmanga/status"),
      headers: {
        "Authorization": "Bearer $sessionToken",
      },
      body: jsonEncode({"status": mappedStatus}),
    );
    if (response.statusCode == 200) {
      print("sc");
      return (response.statusCode).toString();
    } else {
      print('no scsc ');
      return (response.statusCode).toString();
    }
  }
}
  // Add a return statement h


