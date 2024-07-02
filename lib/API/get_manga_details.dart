import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/config/app_config.dart';
import '/models/manga_details.dart';

Future<MangaDetails> getMangaDetailsApi({
  required int id,
}) async {
  final baseUrl =
      'https://api.myanimelist.net/v2/manga/$id?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_volumes,num_chapters,authors{first_name,last_name},pictures,background,related_anime,related_manga,recommendations,serialization{name}';

  final response = await http.get(
    Uri.parse(baseUrl),
    headers: {
      'X-MAL-CLIENT-ID': clientId,
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final mangaDetails = MangaDetails.fromJson(data);
    return mangaDetails;
  } else {
    debugPrint('Code: ${response.statusCode}');
    debugPrint('Error: ${response.body}');
    throw Exception('Could Not Get Data!');
  }
}
