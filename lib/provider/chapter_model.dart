import 'package:flutter/cupertino.dart';
import 'package:oms/API/get_chapter_information.dart';

class ChapterInfoProvider with ChangeNotifier {
  final Map<String, List<dynamic>> _chapterInfoCache = {};

  Future<List<dynamic>> getChapterInformation(String chapterID) async {
    if (_chapterInfoCache.containsKey(chapterID)) {
      return _chapterInfoCache[chapterID]!;
    } else {
      List<dynamic> chapterData = await GetChapterInformation(chapterID: chapterID);
      _chapterInfoCache[chapterID] = chapterData;
      notifyListeners();
      return chapterData;
    }
  }
}
