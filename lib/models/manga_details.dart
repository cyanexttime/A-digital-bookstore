import 'package:flutter/foundation.dart' show immutable;

import 'package:oms/models/manga_node.dart';
import 'package:oms/models/picture.dart';
import 'package:oms/API/get_book_details.dart';

class MangaDetails {
  final int id;
  final String title;
  final Picture mainPicture;
  final String startDate;
  final String endDate;
  final String synopsis;
  final dynamic mean;
  final int rank;
  final int popularity;
  final int numListUsers;
  final String nsfw;
  final String createAt;
  final String updateAt;
  final String mediaType;
  final String status;
  final List<Genre> genres;
  final int numofchapter;
  final int numScoringUsers;
  final int numofVolume;
  final String author;
  final List<Picture> pictures;
  final String background;
  final List<Recommendation> recommendations;
  final List<dynamic> relatedManga;
  final AlternativeTitles alternativeTitles;

  const MangaDetails(
      { required this.mainPicture,
      required this.id,
      required this.title,
      required this.endDate,
      required this.startDate,
      required this.synopsis,
      required this.createAt,
      required this.mean,
      required this.nsfw,
      required this.numListUsers,
      required this.popularity,
      required this.rank,
      required this.updateAt,
      required this.author,
      required this.genres,
      required this.mediaType,
      required this.numScoringUsers,
      required this.numofVolume,
      required this.numofchapter,
      required this.pictures,
      required this.status,
      required this.background,
      required this.recommendations,
      required this.relatedManga,
      required this.alternativeTitles});

  factory MangaDetails.fromJson(Map<String, dynamic> json) {
    return MangaDetails(
      author: json['author'],
      id: json['id'],
      title: json['title'],
      mainPicture: Picture.fromJson(json['main_picture']),
      alternativeTitles: AlternativeTitles.fromJson(json['alternative_titles']),
      startDate: json['start_date'] ?? 'Unknown',
      endDate: json['end_date'] ?? 'Unknown',
      synopsis: json['synopsis'],
      mean: json['mean'] ?? 0.0,
      rank: json['rank'] ?? 0,
      popularity: json['popularity'],
      numListUsers: json['num_list_users'],
      numScoringUsers: json['num_scoring_users'],
      numofVolume: json['num_volumes'],
      numofchapter: json['num_chapters'],
      nsfw: json['nsfw'],
      createAt: json['created_at'],
      updateAt: json['updated_at'],
      mediaType: json['media_type'],
      status: json['status'],
      genres: List<Genre>.from(
        json['genres'].map(
          (genre) => Genre.fromJson(genre),
        ),
      ),
      
      pictures: List<Picture>.from(
        json['pictures'].map(
          (picture) => Picture.fromJson(picture),
        ),
      ),
      background: json['background'],
      
      relatedManga: json['related_manga'],
      recommendations: List<Recommendation>.from(
        json['recommendations'].map(
          (rec) => Recommendation.fromJson(rec),
        ),
      ),
     
    );
  }
}

@immutable
class AlternativeTitles {
  final List<String> synonyms;
  final String en;

  const AlternativeTitles({
    required this.synonyms,
    required this.en,
  });

  factory AlternativeTitles.fromJson(Map<String, dynamic> json) {
    return AlternativeTitles(
      synonyms: List<String>.from(json['synonyms']),
      en: json['en'],
    );
  }
}

@immutable
class Genre {
  final String name;
  final int id;

  const Genre({
    required this.id,
    required this.name,
  });
  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}

@immutable
class Recommendation {
  final MangaNode node;
  final int numRecommendations;

  const Recommendation({
    required this.node,
    required this.numRecommendations,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      node: MangaNode.fromJson(json['node']),
      numRecommendations: json['num_recommendations'],
    );
  }
}

@immutable
class Status {
  final dynamic completed;
  final dynamic onHold;
  final dynamic dropped;
  final dynamic newwatching;

  const Status({
    required this.completed,
    required this.onHold,
    required this.dropped,
    required this.newwatching,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      completed: json['completed'],
      onHold: json['on_hold'],
      dropped: json['dropped'],
      newwatching: json['new_read'],
    );
  }
}
