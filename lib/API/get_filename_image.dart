
import 'dart:convert';
import 'package:http/http.dart' as http;



Future<Map<String,dynamic>> GetFileNameImage({
  required String query,
}) async {
  const String baseUrl = "https://api.mangadex.org/cover";
  Map<String,dynamic> data = {};
  try{
    final response = await http.get(
    Uri.parse('$baseUrl/$query')
  ).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      data = json.decode(response.body);
      // một danh sách các node anime trong khóa data của api
      return data;
    } 
  }catch(e){
    print('Error: $e');
  }
  
  // Add a return statement here
  return {}; 
}


