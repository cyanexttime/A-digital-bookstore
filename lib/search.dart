import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:oms/API/get_filename_image.dart';
import 'package:oms/API/get_mangas_by_search_api.dart';


String query = '';
List dataList = [];

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);
  State<SearchScreen> createState() => _Search();
}

class _Search extends State<SearchScreen>  {
  //chờ dữ liệu trả về từ api
 Future<void> loadAnimes(String value) async {
  final data = await getMangasBySearchApi(query: '$value');
  setState(() {
    dataList = data;
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

  Future<String?> GetImage({required final query}) async {
    final imageData = await GetFileNameImage(query: query);
    if (imageData.isNotEmpty) {
      return imageData['data']['attributes']['fileName'];
    }
  }

  @override
  Widget build (BuildContext context)
  {
    return Scaffold(
      backgroundColor: Color(0xFFF1DCD1),
      appBar: AppBar(
        title: Text(
          'SEARCH',
          style: TextStyle(
          color: Color(0xff150B0B),
          fontSize: 22,
          fontWeight: FontWeight.bold,
          )
        ),
        backgroundColor: Color(0xFF219F94),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SizedBox(height: 15),
          TextField(
            onChanged: (value) => loadAnimes(value),
            style: TextStyle(color: Color(0xff5D4242)),
            decoration:InputDecoration(
              filled: true,
              fillColor: Color(0xffF1DCD1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                ),
              hintText: 'Search manga',
              prefixIcon: Icon(Icons.search, color: Color(0xff5D4242)),
              ),
            ),

          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
              // final movie = dataList[index]['data'];
              final manga = dataList[index];
              final coverID = getCoverID(manga['relationships']);
              final fileName = GetImage(query: coverID); 
              final ID = manga['id'];
              final title = manga['attributes']['title']['en'];
              final status = manga['attributes']['status'];
              return FutureBuilder<String?>(
              future: GetImage(query: coverID),
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return (
                    Center(
                      child: CircularProgressIndicator()
                    )
                  ); // or some other widget while waiting
                } else {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else
                    return Column(
                      children:<Widget>[
                        ListTile(
                      leading:Container(
                        width: 60,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage('https://uploads.mangadex.org/covers/$ID/${snapshot.data}'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      title: Text(
                        title ?? 'No title',
                        style: TextStyle(
                          fontSize: 13, // Set your desired font size
                        ),
                      ),
                      trailing: Text(status),
                      onTap: () {
                        Navigator.pushNamed(context, 'chapter', arguments: manga['id']);
                      },
                      ),
                      SizedBox(height: 15),
                      ],
                    );   // use snapshot.data as the filename
                  }
                },
                );
              },
            ),
          )
          ],
        ),
        )

    );
  }
  
}

