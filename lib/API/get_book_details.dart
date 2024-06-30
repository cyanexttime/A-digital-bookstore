import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oms/models/manga_category.dart';

import '/config/app_config.dart';
import '/models/manga.dart';
import '/models/manga_info.dart';

import 'package:oms/config/app_config.dart';

import 'package:oms/models/manga.dart';
import 'package:oms/models/manga_node.dart';

Future<Iterable<Manga>> GetMangaDetails({
    required int id,
    required String query,
})async {
  final baseUrl = "https://api.myanimelist.net/v2/manga/2?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_volumes,num_chapters,authors{first_name,last_name},pictures,background,related_anime,related_manga,recommendations,serialization{name}q=$query&limit=10";

  final response = await http.get(
    Uri.parse(baseUrl),
    headers: {
      'X-MAL-CLIENT-ID': clientId,
    },
  );

  if (response.statusCode == 200) {
    // Successful response
    final Map<String, dynamic> data = json.decode(response.body);
    MangaInfo mangaInfo = MangaInfo.fromJson(data);
    Iterable<Manga> mangas = mangaInfo.mangas;

    return mangas;
  } else {
    // Error handling
    debugPrint("Error: ${response.statusCode}");
    debugPrint("Body: ${response.body}");
    throw Exception("Failed to get data!");
  }
}