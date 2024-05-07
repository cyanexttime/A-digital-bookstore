
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:oms/configs/app_configs.dart';

import 'package:http/http.dart' as http;



Future<List<dynamic>> getAnimesBySearchApi({
  required String query,
}) async {
  final reponse = await http.get(
    Uri.parse('https://api.myanimelist.net/v2/anime?q=$query&limit=10'),
    // Send authorization headers to the backend.
    headers: {
      'X-MAL-CLIENT-ID': clientId,
    },
  );
  List<dynamic> data = [];
  if (reponse.statusCode == 200) {
    data = json.decode(reponse.body)['data'];
    print(reponse.body);
    // một danh sách các node anime trong khóa data của api
    return data;
  } 
  // Add a return statement here
  return []; 
}


