import 'package:flutter/material.dart';
import 'package:oms/API/get_chapter_list.dart';

class Chapter extends StatefulWidget {
  const Chapter({Key? key}) : super(key: key);

  @override
  State<Chapter> createState() => _ChapterState();
}
List<dynamic> dataList = [];

class _ChapterState extends State<Chapter> {
 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mangaID = ModalRoute.of(context)!.settings.arguments as String;
      LoadChapterList(mangaID); // Call LoadChapterList in initState
    });
  }

  Future<void> LoadChapterList(String value) async {
  final data = await GetChapterList(query: '$value');
  print(data);
  setState(() {
    dataList = data;
        if (dataList.isEmpty) {
      print('dataList is empty');
    } else {
      print('dataList is not empty');
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1DCD1),
      appBar: AppBar(
        backgroundColor: Color(0xFF219F94),
        title: Text('Chapters'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(5.0),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return Card(
            color: Color(0xFF8FBC8F),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dataList[index]['attributes']['title'] ?? 'No title'),
                  Text('Ngôn ngữ dịch: ' + dataList[index]['attributes']['translatedLanguage'] ?? 'No language')
                ],
              ),
              subtitle: Text('Chapter: ' + (dataList[index]['attributes']['chapter'] ?? 'No chapter')),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: ()
              {
                Navigator.pushNamed(context,'chapterContent', arguments: dataList[index]['id']);
              }
            ),
          );
        }
      ),
    );
  }
}