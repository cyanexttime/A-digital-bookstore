
import 'dart:convert';





import 'package:http/http.dart' as http;
import 'package:http/http.dart';



Future<List<dynamic>> GetChapterInformation ({
  required String chapterID,
}) async {
  List data = [];
  const String baseUrl = "https://api.mangadex.org/chapter";
  try{
    final response = await http.get(
      Uri.parse('$baseUrl/$chapterID'),
    ).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
        var data1= json.decode(response.body);
        print (data1); // kiểm tra kiểu dữ liệu của data (kiểu Map
        if(data1.isNotEmpty)
        {
          data.add(data1['data']['attributes']['title']);
          data.add(data1['data']['attributes']['translatedLanguage']);
          data.add(data1['data']['attributes']['chapter']);
          print(data);
          return data;
        }
        // một danh sách các node anime trong khóa data của api
        else{
          return [];
        }
    }
    else {
      print('Error: ${response.statusCode}');
      return [];
    }
  }catch(e){
    if(e is ClientException){
      print('Failed to load data: $e');
    }
  }
    return [];
}
  // Add a return statement h


