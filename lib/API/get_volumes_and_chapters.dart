
import 'dart:convert';





import 'package:http/http.dart' as http;
import 'package:http/http.dart';


Map<String,dynamic> data = {};
Future<Map<String,dynamic>> GetVolumeAndChapter({
  required String query,
}) async {
  const String baseUrl = "https://api.mangadex.org/manga";
  try{
    final response = await http.get(
      Uri.parse('$baseUrl/$query/aggregate'),
    ).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
        data= json.decode(response.body);
        Map<String,dynamic> check = data ?? {};
        // một danh sách các node anime trong khóa data của api
        return check;
    }
    else {
      print('Error: ${response.statusCode}');
    }
  }catch(e){
    if(e is ClientException){
      print('Failed to load data: $e');
    }
  }
    return {};
}
  // Add a return statement h


