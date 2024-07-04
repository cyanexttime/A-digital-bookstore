
// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';





import 'package:http/http.dart' as http;
import 'package:http/http.dart';


Map<String,dynamic> data = {};
Future<Map<String,dynamic>> GetMangaInfo({
  required String query,
}) async {
  const String baseUrl = "https://api.mangadex.org/manga";
  try{
    final response = await http.get(
      Uri.parse('$baseUrl/$query'),
    );
    if (response.statusCode == 200) {
        data= json.decode(response.body);
        Map<String,dynamic> check = data ?? {};
        // một danh sách các node anime trong khóa data của api
        return check;
    }
    else {
       return {};
    }
  }catch(e){
    if(e is ClientException){
      print('Failed to load data: $e');
       return {};
    }
  }
    return {};
}
  // Add a return statement h


