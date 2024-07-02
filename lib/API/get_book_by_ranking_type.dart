import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:oms/config/app_config.dart';

import 'package:oms/models/manga.dart';
import 'package:oms/models/manga_node.dart';

Future<Iterable<Manga>> getMangaByRankingType({
  required String rankingType,
  required int limit,
}) async {
  final baseURL =
      'https://api.myanimelist.net/v2/manga/ranking?ranking_type=$rankingType&limit=$limit';

  final response = await http.get(
    Uri.parse(baseURL),
    headers: {
      'X-MAL-CLIENT-ID': clientId,
    },
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> mangaNodeList = data['data'];
    final mangas = mangaNodeList
        .where((mangaNode) => mangaNode['node']['main_picture'] != null)
        .map((node) {
      return Manga.fromJson(node);
    });

    return mangas;
  } else {
    debugPrint("Error: ${response.statusCode}");
    debugPrint("Body: ${response.body}");
    throw Exception("Failed to get data!");
  }
}
