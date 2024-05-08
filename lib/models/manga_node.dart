
import 'package:flutter/foundation.dart' show immutable;

import 'picture.dart';

@immutable
class MangaNode {
  final int id;
  final String title;
  final Picture mainPicture;

  const MangaNode({
    required this.id,
    required this.title,
    required this.mainPicture,
  });

  factory MangaNode.fromJson(Map<String, dynamic> json) {
    return MangaNode(
      id: json['id'],
      title: json['title'],
      mainPicture: Picture.fromJson(json['main_picture']),
    );
  }
}