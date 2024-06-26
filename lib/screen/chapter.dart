import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:oms/API/get_manga_read_markers.dart';
import 'package:oms/API/get_statistics.dart';
import 'package:oms/API/post_manga_rating.dart';
import 'package:oms/API/post_manga_read_markers.dart';
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

Map<String, dynamic> dataList = {};
Map<String, dynamic> dataManga = {};
Map<String, dynamic> dataVolumesAndChapters = {};

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
List<dynamic> dataBookMarkers = [];

class _ChapterState extends State<Chapter> {
  final _evaluationOptions = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];
  String ratingValue = '0';
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

  Future<void> LoadData() async {
    await Future.wait([
      LoadMangaRating(mangaID),
      LoadMangaInfo(mangaID),
      LoadChapterList(mangaID),
      LoadVolumesAndChapters(mangaID),
      LoadReadingStatus(mangaID),
      LoadMangaReadMarkers(mangaID),
    ]);
  }

  Map<String, String> changeTemp = {
    "on_hold": "On Hold",
    "reading": "Reading",
    "dropped": "Dropped",
    "plan_to_read": "Plan to Read",
    "completed": "Completed",
    "re_reading": "Re-reading",
  };
  Future<void> LoadMangaReadMarkers(String value) async {
    final data = await GetMangaReadMarkers(query: '$value');
    if (data.isNotEmpty) {
      dataBookMarkers = data;
      if (kDebugMode) {
        print(dataBookMarkers);
      }
    }
  }

  Future<void> LoadReadingStatus(String value) async {
    final statusdata = await GetAMangaReadingStatus(query: '$value');
    if (statusdata != null) {
      currentStatus = statusdata.toString();
      currentStatus = changeTemp[currentStatus]!;
    } else {
      currentStatus = 'None';
    }
  }

  Future<void> LoadMangaRating(String value) async {
    final rating = await GetMangaRating(query: '$value');
    setState(() {
      ratingValue = rating?.toString() ?? '0';
    });
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
        author = data['data']?['attributes']?['name'] ?? 'No author';
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
    if (mounted) {
      setState(() {
        dataVolumesAndChapters = data;
        if (dataVolumesAndChapters.isNotEmpty) {
          print(dataVolumesAndChapters);
        }
      });
    }
  }

  Future<void> LoadChapterList(String value) async {
    final data = await GetChapterList(query: '$value');

    if (mounted) {
      setState(() {
        if (dataList.isNotEmpty) {
          dataList = data;
        } else {
          //print('dataList is not empty');
        }
      });
    }
  }

  Future<void> LoadMangaInfo(String value) async {
    final dataMangaInfo = await GetMangaInfo(query: '$value');
    if (mounted) {
      setState(() {
        dataManga = dataMangaInfo;
        if (dataManga.isNotEmpty) {
          title = dataManga['data']['attributes']['title']['en'] ?? '';
          if (dataManga['data']['attributes']['altTitles'].isNotEmpty) {
            japanese =
                dataManga['data']['attributes']['altTitles'][0]['ja'] ?? '';
          }
          if (dataManga['data']['relationships'].isNotEmpty) {
            idAuthor = dataManga['data']['relationships'][0]['id'];
          }
          if (dataManga['data']['attributes']['description'].isNotEmpty) {
            description =
                dataManga['data']['attributes']['description']['en'] ?? '';
          }
          if (getCoverID(dataManga['data']['relationships']) != null) {
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
      });
    }
  }

  Widget buildImage() {
    if (mangaID.isNotEmpty && image.isNotEmpty) {
      String imageUrl = 'https://uploads.mangadex.org/covers/$mangaID/$image';
      print(imageUrl);
      return CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  void FollowManga() {
    PostMangaToMangaList(query: mangaID).then((value) {
      if (value == '200') {
        print('Added to library');
      } else {
        print('Failed to add to library');
      }
    });
  }

  void UnFollowMange() {
    DeleteMangaInMangaList(query: mangaID).then((value) {
      if (value == '200') {
        print('Delete thanh cong');
      } else {
        print('Fail');
      }
    });
  }

  Widget ShowVolumes() {
    if (dataVolumesAndChapters == null || dataVolumesAndChapters['volumes'] == null) {
      return const Center(child: CircularProgressIndicator());
    }

    int countVolume = dataVolumesAndChapters['volumes'].length;
    Map<dynamic, dynamic> volumes = dataVolumesAndChapters['volumes'] ?? {};

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: countVolume,
      itemBuilder: (_, indexVolume) {
        final itemKey = volumes.keys.elementAt(indexVolume);
        int countChapter =
            dataVolumesAndChapters['volumes'][itemKey]['chapters']?.length ?? 0;
        Map<dynamic, dynamic> item =
            dataVolumesAndChapters['volumes'][itemKey]['chapters'] ?? {};

        return Card(
          elevation: 12,
          child: ExpansionTile(
            title: Text('Volume ${itemKey ?? 0}'),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: countChapter,
                itemBuilder: (_, index) {
                  final chapterkey = item.keys.elementAt(index);
                  final chapter = item[chapterkey] ?? {};
                  return ListTile(
                    title: Text('Chapter: ${chapter['chapter'] ?? 'No title'}'),
                    trailing: StatefulBuilder(builder: (context, setState) {
                      bool isBookmarked = CheckBookMarkers(chapter['id']);

                      return IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.blue : Colors.black,
                        ),
                        onPressed: () {
                          if (!apiVariables.isLogin) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginFormDialog(),
                                )).then(
                              (value) => _handleLoginChange(),
                            );
                          } else {
                            print("da vao else roi");
                            setState(() {
                              isBookmarked = !isBookmarked;
                              if (isBookmarked) {
                                // Lưu bookmark
                                print(
                                    'Bookmarked chapter: ${chapter['chapter']}');
                                // Gọi API lưu trạng thái bookmark
                                PostMangaReadMarkers(
                                    idmanga: mangaID,
                                    idchapter: chapter['id'] ?? '');
                              } else {
                                // Xóa bookmark
                                print(
                                    'Unbookmarked chapter: ${chapter['chapter']}');
                                // Gọi API xóa trạng thái bookmark nếu cần
                              }
                            });
                          }
                        },
                      );
                    }),
                    onTap: () {
                      Navigator.pushNamed(context, 'chapterContent',
                          arguments: chapter['id']);
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
        Text(title,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        Text(japanese, style: TextStyle(color: Colors.black, fontSize: 15)),
        Text(author,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            )),
      ],
    );
  }

  void _handleLoginChange() {
    if (apiVariables.isLogin) {
      LoadMangaRating(mangaID);
    }
  }

  bool CheckBookMarkers(String chapterID) {
    for (var item in dataBookMarkers) {
      if (item == chapterID) {
        return true;
      }
    }
    return false;
  }

  Widget buildSnackBar(BuildContext context) {
    return SizedBox(
      // height: double.infinity,
      // width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (apiVariables.isLogin) {
                  MessageBoxScreen().showMessageBox(context);
                } else {
                  Navigator.pushNamed(context, 'signInMangadex');
                }
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFF219F94),
                  fixedSize: Size(150, 50),
                  backgroundColor: Colors.white,
                  shadowColor: Color(0xFF219F94),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              child: Text('Add to library'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.centerLeft,
              transformAlignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () async {
                  if (!apiVariables.isLogin) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginFormDialog(),
                        )).then(
                      (value) => _handleLoginChange(),
                    );
                  }
                },
                child: AbsorbPointer(
                    absorbing: !apiVariables.isLogin,
                    child: DropdownButton<String>(
                      value: ratingValue,
                      onChanged: (value) {
                        setState(() => ratingValue = value!);
                        if (value == null || value == '0') {
                          print('Delete');
                          DeleteMangaRating(idmanga: mangaID);
                        } else {
                          UpdateManagaRating(value);
                        }
                      },
                      items: _evaluationOptions.map(buildMenuItem).toList(),
                      dropdownColor: Colors.white,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                      iconEnabledColor: Colors.black,
                      underline: Container(),
                      iconSize: 30,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      onTap: () {},
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.amber, size: 30),
          SizedBox(width: 3),
          Text(
            item,
            style: TextStyle(fontSize: 30),
          )
        ],
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF1DCD1),
        appBar: AppBar(
          title: Text('Chapters'),
          backgroundColor: Color(0xFF219F94),
        ),
        body: Container(
            padding: EdgeInsets.all(13),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: buildMangaInfo()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  BuildStatistics(context),
                  const SizedBox(height: 10),
                  buildSnackBar(context),
                  const SizedBox(height: 10),
                  Text(description,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      )),
                  const SizedBox(height: 10),
                  ShowVolumes(),
                ],
              ),
            )));
  }
}

class BuildStatistics extends StatelessWidget {
  BuildStatistics(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetStatistics(query: mangaID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data!.isEmpty) {
            return Center(child: Text('No data'));
          }
          return Row(
            children: [
              Icon(Icons.star_border, color: Colors.amber),
              SizedBox(width: 2),
              Text('${data['rating']['average'].toStringAsFixed(2)}', style: const TextStyle(fontSize: 20)),
              SizedBox(width: 8), // Khoảng cách giữa các phần tử
              Icon(Icons.comment_bank_outlined, color: Colors.blue),
              SizedBox(width: 2),
              Text('${data['comments']?['repliesCount'] ?? 0 }', style: const TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Icon(Icons.people_alt_outlined, color: Colors.red),
              SizedBox(width: 2),
              Text('${data['follows'] ?? 0 }', style: const TextStyle(fontSize: 20)),
            ],
          );
        }
        return Center(child: Text('No data'));
      },
    );
  }
}

Future<void> UpdateManagaRating(String? value) async {
  PostMangaRating(idmanga: mangaID, rating: int.parse(value!)).then((value) {
    if (value == '200') {
      print('Rating success');
    } else {
      print('Rating failed');
    }
  });
}
