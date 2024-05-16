import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
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
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
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
              final movie = dataList[index];
              final title = movie['attributes']['title']['en'];
              final status = movie['attributes']['status'];
              return ListTile(
                title: Text(title ?? 'No title'),
                trailing: Text(status),
                onTap: () {
                      Navigator.pushNamed(context, 'chapter', arguments: movie['id']);
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

