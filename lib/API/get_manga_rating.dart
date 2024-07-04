
// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oms/API/accessToken.dart';


Future<int> GetMangaRating( 
  {required final String query}
) async {
  const String baseUrl = "https://api.mangadex.org";
  final String? sessionToken = await GetToken();
  final response = await http.get(
      Uri.parse("$baseUrl/rating?manga[]=$query"),
      headers: {
        "Authorization": "Bearer $sessionToken"
        },
      );
  
  if (response.statusCode == 200) {
    print("$baseUrl/query?id=$query");
    print(response.body);
    var decodedData = jsonDecode(response.body);

    // Extract the rating // Replace with the actual manga ID
    int? rating = decodedData['ratings'][query]?['rating'];

    // Printing the rating for verification
    if (rating != null) {
      print("Rating: $rating");
      return rating;
    } else {
      print("Rating not found");
      return 0;
    }

    
  } else {
    print('Error: ${response.statusCode}');
    return 0;
  }
}





