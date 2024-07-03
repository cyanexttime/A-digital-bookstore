import 'package:flutter/foundation.dart' show immutable;

import '/models/manga_node.dart';
import '/models/picture.dart';

class MangaDetails {
  final int? id;
  final String title;
  final Picture mainPicture;
  final AlternativeTitles alternativeTitles;
  final String startDate;
  final String endDate;
  final String synopsis;

  // Most of the times it's an int, but to avoid rare cases errors when it's
  // a double, define "mean" as dynamic
  final dynamic mean;
  final int? rank;
  final int? popularity;
  final int? numListUsers;
  final int? numScoringUsers;
  final String createdAt;
  final String updatedAt;
  final String status;
  final List<Genre> genres;
  final int? numVolumes;
  final int? numChapters;
  final List<Picture> pictures;
  //Manga & Upcoming manga
  final String background;
  final List<RelatedAnime> relatedAnime;
  final List<RelatedManga> relatedManga;
  final List<Recommendation> recommendations;

  const MangaDetails({
    required this.id,
    required this.title,
    required this.mainPicture,
    required this.alternativeTitles,
    required this.startDate,
    required this.endDate,
    required this.synopsis,
    required this.mean,
    required this.rank,
    required this.popularity,
    required this.numListUsers,
    required this.numScoringUsers,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.genres,
    required this.numVolumes,
    required this.numChapters,
    required this.pictures,
    required this.background,
    required this.relatedAnime,
    required this.recommendations,
    required this.relatedManga,
  });

  factory MangaDetails.fromJson(Map<String, dynamic> json) {
    return MangaDetails(
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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      numVolumes: json['num_volumes'],
      numChapters: json['num_chapters'],
      status: json['status'],
      genres: List<Genre>.from(
        json['genres'].map(
          (genre) => Genre.fromJson(genre),
        ),
      ),
      background: json['background'],
      relatedAnime: List<RelatedAnime>.from(
        json['related_anime'].map(
          (anime) => RelatedAnime.fromJson(anime),
        ),
      ),
      relatedManga: List<RelatedManga>.from(
        json['related_manga'].map(
          (manga) => RelatedManga.fromJson(manga),
        ),
      ),
      recommendations: List<Recommendation>.from(
        json['recommendations'].map(
          (rec) => Recommendation.fromJson(rec),
        ),
      ),
      pictures: List<Picture>.from(
        json['pictures'].map((picture) => Picture.fromJson(picture)),
      ),
    );
  }
}

@immutable
class AlternativeTitles {
  final List<String> synonyms;
  final String en;
  final String ja;

  const AlternativeTitles({
    required this.synonyms,
    required this.en,
    required this.ja,
  });

  factory AlternativeTitles.fromJson(Map<String, dynamic> json) {
    return AlternativeTitles(
      synonyms: List<String>.from(json['synonyms']),
      en: json['en'],
      ja: json['ja'],
    );
  }
}

@immutable
class Genre {
  final int id;
  final String name;

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
class RelatedAnime {
  final MangaNode node;
  final String relationType;
  final String relationTypeFormatted;

  const RelatedAnime({
    required this.node,
    required this.relationType,
    required this.relationTypeFormatted,
  });

  factory RelatedAnime.fromJson(Map<String, dynamic> json) {
    return RelatedAnime(
      node: MangaNode.fromJson(json['node']),
      relationType: json['relation_type'],
      relationTypeFormatted: json['relation_type_formatted'],
    );
  }
}

@immutable
class RelatedManga {
  final MangaNode node;
  final String relationType;
  final String relationTypeFormatted;

  const RelatedManga({
    required this.node,
    required this.relationType,
    required this.relationTypeFormatted,
  });

  factory RelatedManga.fromJson(Map<String, dynamic> json) {
    return RelatedManga(
      node: MangaNode.fromJson(json['node']),
      relationType: json['relation_type'],
      relationTypeFormatted: json['relation_type_formatted'],
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

// @immutable
// class Status {
//   /// These stats usually come at the form of String but as
//   /// there are some manga which get these stats as int,
//   /// I decided to tell that they're dynamics and can
//   /// come at any form.
//   final dynamic watching;
//   final dynamic completed;
//   final dynamic onHold;
//   final dynamic dropped;
//   final dynamic planToWatch;

//   const Status({
//     required this.watching,
//     required this.completed,
//     required this.onHold,
//     required this.dropped,
//     required this.planToWatch,
//   });

//   factory Status.fromJson(Map<String, dynamic> json) {
//     return Status(
//       watching: json['watching'],
//       completed: json['completed'],
//       onHold: json['on_hold'],
//       dropped: json['dropped'],
//       planToWatch: json['plan_to_watch'],
//     );
//   }
// }
