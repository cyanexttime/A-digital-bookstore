import 'package:flutter/foundation.dart' show immutable;
import 'package:oms/models/manga.dart';

@immutable
class MangaInfo {
  final Iterable<Manga> mangas;

  const MangaInfo({
    required this.mangas,
  });

  factory MangaInfo.fromJson(Map<String, dynamic> json) {
    List<dynamic> mangaRankingList = json['data'];
    List<Manga> mangaRankingItems = mangaRankingList
        .map(
          (item) => Manga.fromJson(item),
        )
        .toList();

    return MangaInfo(
      mangas: mangaRankingItems,
    );
  }
}

@immutable
class Ranking {
  final int rank;

  const Ranking({
    required this.rank,
  });

  factory Ranking.fromJson(Map<String, dynamic> json) {
    return Ranking(
      rank: json['rank'],
    );
  }
}
