

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oms/API/get_chapter_content.dart';


class ChapterContent extends StatefulWidget {
  const ChapterContent({super.key});

  @override
  State<ChapterContent> createState() => _ChapterContentState();
}

class  _ChapterContentState extends State <ChapterContent> {
  Map<String, dynamic> dataList = {} ;
  List<dynamic> dataImageList = [];
  late String baseUrl;
  late String hash;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chapterID = ModalRoute.of(context)!.settings.arguments as String;
      LoadChapter(chapterID); // Call LoadChapterList in initState
    });
  }

  Future<void> LoadChapter(String value) async {
  Map<String,dynamic> data = await GetChapterContent(query: value);
  setState(() {
    dataList = data;
    if (dataList.isEmpty) {
      print('dataList is empty');
    } 
    else 
    {
      baseUrl = dataList['baseUrl'];
      hash = dataList['chapter']['hash'];
      dataImageList = dataList['chapter']['data'];
    }
    }
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter Content'),
        backgroundColor: const Color(0xFF219F94),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: dataImageList.length,
        separatorBuilder:   (context, index) => const SizedBox(height: 5),
        itemBuilder: (context, index) => CachedNetworkImage(
          key: UniqueKey (),
          imageUrl: '$baseUrl/data/$hash/' + dataImageList[index],
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Container(
            color: Colors.black12, 
            child: const Icon(Icons.error, color: Colors.red, size: 80)
          )
        )
      ),
    );
  }
}