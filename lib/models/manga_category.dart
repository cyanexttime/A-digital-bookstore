import 'package:flutter/material.dart';

@immutable
class MangaCategory {
  final String title;
  final String rankingType;

  const MangaCategory({
    required this.title,
    required this.rankingType,
  });

  factory MangaCategory.fromJson(Map<String, dynamic> json) {
    return MangaCategory(
      title: json['title'],
      rankingType: json['rankingType'],
    );
  }
}

const animeCategories = [
  MangaCategory(title: 'Top All', rankingType: 'all'),
  MangaCategory(title: 'Top Manga', rankingType: 'manga'),
  MangaCategory(title: 'Top Novels', rankingType: 'novels'),
  MangaCategory(title: 'Top One-shots', rankingType: 'oneshots'),
  MangaCategory(title: 'Top Doujinshi', rankingType: 'doujin'),
  MangaCategory(title: 'Top Manhwa', rankingType: 'manhwa'),
  MangaCategory(title: 'Top Manhua', rankingType: 'manhua'),
  MangaCategory(title: 'Top Popular', rankingType: 'bypopularity'),
  MangaCategory(title: 'Top Favorited', rankingType: 'favorite'),
];