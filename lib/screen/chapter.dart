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
import 'package:oms/API/get_chapter_information.dart';
import 'package:oms/API/get_filename_image.dart';
import 'package:oms/API/get_manga_info.dart';
import 'package:oms/API/get_volume_and_chapters.dart';
import 'package:oms/API/get_manga_rating.dart';
import 'package:oms/API/get_manga_read_markers.dart';
import 'package:oms/API/get_statistics.dart';
import 'package:oms/API/post_manga_rating.dart';
import 'package:oms/API/post_manga_read_markers.dart';
import 'package:oms/API/post_manga_unread_markers.dart';
import 'package:oms/API/unfollow_manga.dart';
import 'package:oms/API/post_manga_reading_status.dart';
import 'package:oms/Constants/appColor.dart';
import 'package:oms/components/SignIn_SignUp_Magadex/sign_in_magadex.dart';
import 'package:oms/components/api_variables.dart';
import 'package:oms/components/statistics.dart';
import 'package:oms/models/items_model.dart';
import 'package:oms/provider/bookmark_model.dart';
import 'package:oms/provider/chapter_model.dart';
import 'package:oms/screen/bookmarks_page.dart';
import 'package:oms/screen/homePage.dart';
import 'package:oms/screen/message_box_screen.dart';
import 'package:oms/models/manga.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class Chapter extends StatefulWidget {
  const Chapter({Key? key}) : super(key: key);

  @override
  State<Chapter> createState() => _ChapterState();
}

Map<String, dynamic> dataList = {};
Map<String, dynamic> dataManga = {};
Map<String, dynamic> dataVolumesAndChapters = {};
var bookmarkBloc;

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
      LoadMangaReadMarkers(mangaID),
    ]);
  }

  Future<void> LoadMangaReadMarkers(String value) async {
    bookmarkBloc = Provider.of<BookmarkBloc>(context, listen: false);
    bookmarkBloc.init();
    final data = await GetMangaReadMarkers(query: value);
    if (data.isNotEmpty) {
      dataBookMarkers = data;
      bookmarkBloc.SetCount(data.length);
      for (var value in dataBookMarkers) {
        List<dynamic> temp = await GetChapterInformation(chapterID: value);
        ItemModel item = ItemModel(
          nameChapter: '${temp[2] ?? 'No chapter'} - ${temp[0] ?? 'No title'}',
          transLanguage: temp[1] ?? 'No language',
          chapterID: value,
        );
        bookmarkBloc.AddItem(item);
      }
      print(dataBookMarkers.length);
    } else {
      bookmarkBloc.SetCount(0);
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
    final data = await GetVolumesAndChapters(query: '$value');
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
    final data = await GetVolumesAndChapters(query: '$value');

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
    if (dataVolumesAndChapters == null ||
        dataVolumesAndChapters['volumes'] == null) {
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
                  return StatefulBuilder(
                    builder: (context, setState) {
                      bool isBookmarked =
                          dataBookMarkers.contains(chapter['id']);
                      bookmarkBloc = Provider.of<BookmarkBloc>(context);

                      return FutureBuilder<List<dynamic>>(
                          future: Provider.of<ChapterInfoProvider>(context,
                                  listen: false)
                              .getChapterInformation(chapter['id']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final List? chapterBonus = snapshot
                                .data; // List ? có nghĩa nó có thể giá trị null

                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'chapterContent',
                                    arguments: chapter['id']);
                              },
                              child: ListTile(
                                title: Text(
                                    'Ch.${chapter['chapter'] ?? ''}-${chapterBonus![0] ?? 'No title'}'),
                                subtitle: Text(
                                    'Translation language: ${chapterBonus![1] ?? 'No language'}'),
                                trailing: IconButton(
                                  icon: Icon(
                                    isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: const Color(0xFF219F94),
                                  ),
                                  onPressed: () async {
                                    if (!apiVariables.isLogin) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginFormDialog(),
                                          )).then(
                                        (value) => _handleLoginChange(),
                                      );
                                    } else {
                                      ItemModel item = ItemModel(
                                          chapterID: chapter['id'],
                                          nameChapter:
                                              '${chapter['chapter'] ?? ''} - ${chapterBonus![0] ?? 'No title'}',
                                          transLanguage:
                                              '${chapterBonus![1] ?? 'No language'}');
                                      if (isBookmarked) {
                                        dataBookMarkers.remove(chapter['id']);
                                        PostMangaUnReadMarkers(
                                          idmanga: mangaID,
                                          idchapter: chapter['id'],
                                        );
                                        bookmarkBloc.RemoveItem(item);
                                      } else {
                                        dataBookMarkers.add(chapter['id']);
                                        PostMangaReadMarkers(
                                          idmanga: mangaID,
                                          idchapter: chapter['id'],
                                        );
                                        bookmarkBloc.AddItem(item);
                                        bookmarkBloc.AddCount();
                                      }
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                            );
                          });
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
      LoadMangaReadMarkers(mangaID);
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (apiVariables.isLogin) {
                  showDialog(
                      context: context,
                      builder: (context) => MessageBoxScreen(mangaID: mangaID));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginFormDialog(),
                      )).then(
                    (value) => _handleLoginChange(),
                  );
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
    bookmarkBloc = Provider.of<BookmarkBloc>(context);
    return Scaffold(
        backgroundColor: Color(0xFFF1DCD1),
        appBar: AppBar(
            title: const Text(
              'Chapters',
              style: TextStyle(
                color: Color(0xff150B0B),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Text(bookmarkBloc.count.toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.bookmark),
                style: ButtonStyle(
                  iconSize: MaterialStateProperty.all(30),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'bookmarkPage');
                },
              ),
            ],
            backgroundColor: AppColor.darkCyan),
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
                  BuildStatistics(mangaID: mangaID),
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


Future<void> UpdateManagaRating(String? value) async {
  PostMangaRating(idmanga: mangaID, rating: int.parse(value!)).then((value) {
    if (value == '200') {
      print('Rating success');
    } else {
      print('Rating failed');
    }
  });
}