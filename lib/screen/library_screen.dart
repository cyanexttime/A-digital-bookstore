import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:oms/API/accessToken.dart';
import 'package:oms/API/authencation.dart';
import 'package:oms/API/get_all_reading_status.dart';
import 'package:oms/API/get_author.dart';
import 'package:oms/API/get_filename_image.dart';
import 'package:oms/API/get_list_apiclient.dart';
import 'package:oms/API/get_manga_info.dart';
import 'package:oms/API/get_mangas_by_search_api.dart';
import 'package:oms/screen/chapter.dart';
import 'package:oms/components/api_variables.dart';
import 'package:oms/components/get_coverID.dart';
import 'package:oms/components/get_image.dart';
import 'package:provider/provider.dart'; // Add this line to import the 'Provider' class

String query = '';
List dataList = [];
Map<String, dynamic> dataReadingStatus = {};
final Map<String, Future<List<dynamic>>> _futures = {};

class LibraryScreen extends StatefulWidget {
  LibraryScreen({Key? key}) : super(key: key);
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      CheckLogin();
    });
  }

  Future<void> CheckLogin() async {
    if (apiVariables.isLogin == false) {
      Navigator.pushNamed(context, 'signInMangadex');
    } else {
      dataReadingStatus = await GetALLMangaReadingStatus(query: 'All');
    }
  }

  List<String> dropDownMenuItems = [
    'All',
    'Reading',
    'Completed',
    'Dropped',
    'Plan to read',
    'Re Reading',
    'On Hold'
  ];
  String selectedValue = 'All';

  Widget Results(String value) {
    if (apiVariables.isLogin != true) {
      return Center(child: Text("Please Login Mangadex Account"));
    } else {
      return FutureBuilder<dynamic>(
        future: GetALLMangaReadingStatus(query: value),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data != null) {
              Map<String, dynamic> dataReadingStatus = snapshot.data;
              Map<String, dynamic>? statuses = dataReadingStatus['statuses'];
              if (statuses == null) {
                return Center(
                    child: Text('No Manga', style: TextStyle(fontSize: 20)));
              }
              List<MapEntry<String, dynamic>> mangaEntries =
                  statuses.entries.toList();
              int countMangaId = dataReadingStatus['statuses'].length;
              return ListView.builder(
                  addAutomaticKeepAlives: true,
                  itemCount: countMangaId,
                  itemBuilder: (context, index) {
                    final mangaEntry = mangaEntries.elementAt(index);
                    final mangaID = mangaEntry.key;

                    if (!_futures.containsKey(mangaID)) {
                      _futures[mangaID] = () async {
                        Map<String, dynamic> mangaInfo =
                            await GetMangaInfo(query: mangaID);
                        var coverID = await getCoverID(
                            mangaInfo['data']['relationships']);
                        var getImageString = await GetImage(query: coverID);
                        var author =
                            mangaInfo['data']['relationships'][0]['id'] ?? '';
                        var title = mangaInfo['data']['attributes']['title']
                                ['en'] ??
                            '';
                        var description = mangaInfo['data']['attributes']
                                ['description']['en'] ??
                            '';

                        return [mangaInfo, getImageString, title, description];
                      }();
                    }
                    return FutureBuilder<List<dynamic>>(
                      future: _futures[mangaID],
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          String imageUrl =
                              'https://uploads.mangadex.org/covers/$mangaID/${snapshot.data?[1]}';
                          return Container(
                            width: double.infinity,
                            color: Colors.blueAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 200,
                                        child: CachedNetworkImage(
                                          key: ValueKey(imageUrl),
                                          imageUrl: imageUrl,
                                          placeholder: (context, url) => const Center(
                                              child:CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data?[2],
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              snapshot.data?[3],
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Status: ${mangaEntry.value}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, 'chapter',
                                                    arguments: mangaID);
                                              },
                                              child: Text('Read'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  });
            } else {
              return Text('No Manga Found');
            }
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1DCD1),
      appBar: AppBar(
        title: Text('LIBRARY',
            style: TextStyle(
              color: Color(0xff150B0B),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Color(0xFF219F94),
        elevation: 0.0,
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(Icons.filter_alt),
                      ),
                      DropdownButton(
                        elevation: 12,
                        underline: Container(),
                        items: dropDownMenuItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              value: value);
                        }).toList(),
                        value: selectedValue,
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue = newValue.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height -
                      240, // 85 is the total height of other widgets
                  child: Results(selectedValue),
                ),
              ],
            ),
          )),
    );
  }
}
