import 'package:flutter/foundation.dart' show immutable;

import 'package:oms/models/manga_info.dart';
import '/models/manga_node.dart';

@immutable
class Manga {
  final MangaNode node;
  final Ranking? ranking;

  const Manga({
    required this.node,
    this.ranking,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      node: MangaNode.fromJson(json['node']),
      ranking:
          json['ranking'] != null ? Ranking.fromJson(json['ranking']) : null,
    );
  }
}