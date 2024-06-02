import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oms/API/follow_manga.dart';
import 'package:oms/API/get_a_manga_reading_status.dart';
import 'package:oms/API/get_author.dart';
import 'package:oms/API/get_filename_image.dart';
import 'package:oms/API/get_manga_info.dart';
import 'package:oms/API/get_chapter_list.dart';
import 'package:oms/API/unfollow_manga.dart';
import 'package:oms/API/update_manga_reading_status.dart';
import 'package:oms/message_box_screen.dart';
import 'package:oms/models/manga.dart';
import 'package:transparent_image/transparent_image.dart';



class Chapter extends StatefulWidget {
  const Chapter({Key? key}) : super(key: key);

  @override
  State<Chapter> createState() => _ChapterState();
}
Map<String,dynamic> dataList = {};
Map<String,dynamic> dataManga = {};
Map<String,dynamic> dataVolumesAndChapters = {};

String currentStatus = '';
String title = '';
String idAuthor = '';
String japanese = ''; //teen goi theo tieng nhat cua truyen 
String author = ''; //ten tac gia
String coverID = '';
String image = '';
String mangaID = '';
String description = '';
String selectedCategory = '';
bool isPressed = false;


class _ChapterState extends State<Chapter> {
 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mangaID = ModalRoute.of(context)!.settings.arguments as String;
      LoadData();
    });
  }

  String? getCoverID(List<dynamic> relationships) {
    for (var relationship in relationships) {
      if (relationship['type'] == 'cover_art') {
        return relationship['id'];
      }
    }
    return null;
  }

  Future<void> LoadData() async{
    await Future.wait([
      LoadMangaInfo(mangaID),
      LoadChapterList(mangaID),
      LoadVolumesAndChapters(mangaID),
      LoadReadingStatus(mangaID), 
    ]);
  }

    Map<String,String>  changeTemp={
      "on_hold":"On Hold",
      "reading":"Reading",
      "dropped":"Dropped",
      "plan_to_read":"Plan to Read",
      "completed":"Completed",
      "re_reading":"Re-reading",
    };
  Future<void> LoadReadingStatus(String value) async {
    final statusdata = await GetAMangaReadingStatus(query: '$value');
    if (statusdata != null) {
      currentStatus = statusdata.toString();
      currentStatus = changeTemp[currentStatus]!;
    } else {
      currentStatus = 'None';
    }
  }
  Future<void> LoadAuthor(String value) async {
  if (value == null || value.trim().isEmpty) {
    print('Invalid author ID');
    return;
  }
    final data = await GetAuthor(query: '$value');
    print(data);
    if (mounted) {
      setState(() {
      author = data['data']?['attributes']?['name']??'No author';
    });
  }
  }

  Future<String?> GetImage({required final query}) async {
    final imageData = await GetFileNameImage(query: query);
    if (imageData.isNotEmpty) {
      return imageData['data']['attributes']['fileName'];
    }
    return null;
  }
  Future<void> LoadVolumesAndChapters(String value) async {
    final data = await GetChapterList(query: '$value');
    if(mounted)
    {
      setState(() {
        dataVolumesAndChapters = data;
        if (dataVolumesAndChapters.isNotEmpty) {
          print(dataVolumesAndChapters);
        } 
      }
      );
    }
  }

  Future<void> LoadChapterList(String value) async {
    final data = await GetChapterList(query: '$value');
   
    if(mounted)
    {
      setState(() {
        
        if (dataList.isNotEmpty) {
          dataList = data;
        } else {
          //print('dataList is not empty');
        }
      }
      );
    }
  }
  Future<void> LoadMangaInfo(String value) async {
    final dataMangaInfo = await GetMangaInfo(query: '$value');
      if(mounted)
      {
        setState(() {
        dataManga = dataMangaInfo;
        if(dataManga.isNotEmpty){
          title = dataManga['data']['attributes']['title']['en']??'';
          if (dataManga['data']['attributes']['altTitles'].isNotEmpty) {
            japanese = dataManga['data']['attributes']['altTitles'][0]['ja'] ?? '';
          }
          if (dataManga['data']['relationships'].isNotEmpty) {
            idAuthor = dataManga['data']['relationships'][0]['id'];
          }
          if(dataManga['data']['attributes']['description'].isNotEmpty)
          {
            description = dataManga['data']['attributes']['description']['en']??'';
          }
          if(getCoverID(dataManga['data']['relationships']) != null)
          {
            coverID = getCoverID(dataManga['data']['relationships'])!;
            GetImage(query: coverID).then((fileName) {
            if (fileName != null) {
              setState(() {
                image = fileName;
              });
            }  
          });
          LoadAuthor(idAuthor);
          }
        }
      }
      );
    }
  }

Widget buildImage() {
  if (mangaID.isNotEmpty && image.isNotEmpty) {
    String imageUrl = 'https://uploads.mangadex.org/covers/$mangaID/$image';
    print(imageUrl);
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => CircularProgressIndicator(),
      
    );
  } else {
    return CircularProgressIndicator();
  }
}

  void FollowManga() {
    PostMangaToMangaList( query: mangaID).then((value) {
      if (value == '200') {
        print('Added to library');
      } else {
        print('Failed to add to library');
      }
    });
  }

  void UnFollowMange(){
    DeleteMangaInMangaList(query: mangaID).then((value) {
      if(value == '200'){
        print('Delete thanh cong');
      }
      else
      {
        print('Fail');
      }
    });
  }

Widget ShowVolumes() {
  if (dataVolumesAndChapters == null || dataVolumesAndChapters['volumes'] == null) {
    return CircularProgressIndicator();
  }

  int countVolume = dataVolumesAndChapters['volumes'].length;
  Map<dynamic, dynamic> volumes = dataVolumesAndChapters['volumes'] ?? {};

  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: countVolume,
    itemBuilder: (_, indexVolume) {
      final itemKey = volumes.keys.elementAt(indexVolume);
      int countChapter = dataVolumesAndChapters['volumes'][itemKey]['chapters']?.length ?? 0;
      Map<dynamic, dynamic> item = dataVolumesAndChapters['volumes'][itemKey]['chapters'] ?? {};

      return Card(
        elevation: 12,
        child: ExpansionTile(
          title: Text('Volume $itemKey'),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: countChapter,
              itemBuilder: (_, index) {
                final chapterkey = item.keys.elementAt(index);
                final chapter = item[chapterkey] ?? {};
                return ListTile(
                  title: Text(chapter['chapter'] ?? 'No title'),
                  subtitle: Text('Chapter: ${chapter['attributes']?['chapter'] ?? 'No chapter'}'),
                  onTap: () {
                    Navigator.pushNamed(context, 'chapterContent', arguments: chapter['id']);
                  },
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
  Widget buildMangaInfo() {
    if (dataManga.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
        Text(japanese, style: TextStyle(color: Colors.black, fontSize: 15)),
        Text(author, style: TextStyle(color: Colors.black, fontSize: 15,)),
      ],
    );
  }

  Widget buildSnackBar(BuildContext context)
  {
    List<String> items = ['Add to library', 'Remove from library'];
    return Row(
      children: [
        ButtonBar(
          children: [
            ElevatedButton(
              onPressed: () {
                MessageBoxScreen().showMessageBox(context);
                // if(isPressed == false)
                // {
                //   FollowManga();
                //   isPressed = true;
                // }
                // else{
                //   UnFollowMange();
                //   isPressed = false;
                // }
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text(isPressed ? 'Added to library' : 'Removed from library'),
                //     duration: Duration(seconds: 2),          
                //   ),
                // );
                // setState(() {
                //   isPressed != isPressed;
                // });
              },
              child: Text(isPressed ? 'Remove from library' : 'Add to library'),
            ),
         ],
        ),
        DropdownButton<String>(items: items.map((String value)
        {
          hint:const Text('Remove from library');
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(), onChanged: (String? value) {  },
        )
     ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF1DCD1),
      child:Scaffold(
        appBar:AppBar(
          title: Text('Chapters'),
          backgroundColor: Color(0xFF219F94),
        ),
        body:Container(
          color: Color(0xffF1DCD1),
          padding: EdgeInsets.all(13),
          child:SingleChildScrollView(
             child: Column(
                children: [
                Row(
                  children:
                  [
                    Expanded(
                      flex: 2, // Ảnh sẽ chiếm 2/3 không gian
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: buildImage(),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
              
                    Expanded(
                      flex: 3,
                      child:Align(
                        alignment: Alignment.topLeft,
                        child: buildMangaInfo()
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                buildSnackBar(context),
                Text(description, style: TextStyle(color: Colors.black, fontSize: 15,)),
                SizedBox(height: 10),
                
                ShowVolumes(),
              ],
            ),
          )
         )
      ),
    );
  }
}

