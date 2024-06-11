import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:oms/API/delete_manga_rating.dart';
import 'package:oms/API/follow_manga.dart';
import 'package:oms/API/get_a_manga_reading_status.dart';
import 'package:oms/API/get_author.dart';
import 'package:oms/API/get_filename_image.dart';
import 'package:oms/API/get_manga_info.dart';
import 'package:oms/API/get_chapter_list.dart';
import 'package:oms/API/get_manga_rating.dart';
import 'package:oms/API/post_manga_rating.dart';
import 'package:oms/API/unfollow_manga.dart';
import 'package:oms/API/post_manga_reading_status.dart';
import 'package:oms/components/SignIn_SignUp_Magadex/sign_in_magadex.dart';
import 'package:oms/components/api_variables.dart';
import 'package:oms/screen/message_box_screen.dart';
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
Future<int>? _futureRating;

class _ChapterState extends State<Chapter> {
 
  final _evaluationOptions = ['0', '1', '2', '3', '4', '5', '6','7','8','9','10'];
  String? ratingValue;
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
      //PostMangaRating(idmanga: mangaID, rating: 5),
      _futureRating = GetMangaRating(query: mangaID),
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
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      
    );
  } else {
    return Center(child: CircularProgressIndicator());
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
    return Center(child: CircularProgressIndicator());
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: Colors.black, width: 2),
                  ),
                  onPressed: () {
                    if(apiVariables.isLogin){
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
                    }
                    else{
                      Navigator.pushNamed(context,'signInMangadex');
                    }
                  },
                  child: Text(isPressed ? 'Remove from library' : 'Add to library'),
              ),
            ),
            
            Padding(
          padding: const EdgeInsets.all(10.0),
          child: Expanded(
                child:Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      if(!apiVariables.isLogin){  
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginFormDialog (),
                        )
                      );
                      }
                    },
                    child: AbsorbPointer(
                      absorbing: !apiVariables.isLogin,
                      child: FutureBuilder<int>(
                          future:   _futureRating,
                          builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                  return (Text('Loading...'));
                              }

                             else {
                                ratingValue = snapshot.data?.toString();
                                print(ratingValue);
                                return DropdownButton<String>(
                                value: ratingValue??'0',
                                onChanged:apiVariables.isLogin? (value) {
                                setState(() => ratingValue = value
                              );
                              if(ratingValue == null || ratingValue == '0')
                              {
                                print('Delete');
                                DeleteMangaRating(idmanga: mangaID);
                                

                              }
                              else{
                                UpdateManagaRating(value);
                              }
                              setState(() {
                                _futureRating = GetMangaRating(query: mangaID);
                              });
                            }:null,
                          items:  _evaluationOptions.map(buildMenuItem).toList(),
                          dropdownColor: Colors.white,
                          style: TextStyle(color: Colors.black),
                          iconEnabledColor: Colors.black,
                          underline: Container(),
                          iconSize: 36,
                                              );
                          }
                        },
                        ),
                ),
              ),
              ),
            )
            )
          ],  
      );
  }


  DropdownMenuItem<String> buildMenuItem(String item) => 
    DropdownMenuItem(
      value: item,
      onTap: () {
      },
      child:Row(
        children: [
          Icon(Icons.star, color: Colors.amber),
          SizedBox(width: 3),
           Text(
            item,
            style: TextStyle(fontSize: 20),
          )
        ],)
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1DCD1),
        appBar:AppBar(
          title: Text('Chapters'),
          backgroundColor: Color(0xFF219F94),
        ),
        body:Container(
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
      );
  }
}

Future<void> UpdateManagaRating(String? value) async{
  PostMangaRating(idmanga: mangaID, rating: int.parse(value!)).then((value) {
    if (value == '200') {
      print('Rating success');
    } else {
      print('Rating failed');
    }
  });
}

