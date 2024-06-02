import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:oms/API/accessToken.dart';
import 'package:oms/API/authencation.dart';
import 'package:oms/API/get_filename_image.dart';
import 'package:oms/API/get_list_apiclient.dart';
import 'package:oms/API/get_mangas_by_search_api.dart';
import 'package:oms/components/api_variables.dart';


String query = '';
List dataList = [];

class LibraryScreen extends StatefulWidget {
  LibraryScreen({Key? key}) : super(key: key);
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>  {
  
  
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      CheckLogin();
    });
  }

  Future<void> CheckLogin() async {
    if(apiVariables.isLogin == false){
      Navigator.pushNamed(context, 'signInMangadex');
    }
    else{
      
    }
  }
  List<String> dropDownMenuItems = [
    'All',
    'Reading',
    'Completed',
    'Dropped',
    'Plan to read',
    'Re-Reading',
    'On Hold'
  ];
  String selectedValue = 'All';

  @override
  Widget build (BuildContext context)
  {
    return Scaffold(
      backgroundColor: Color(0xFFF1DCD1),
      appBar: AppBar(
        title: Text(
          'LIBRARY',
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
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
            child:Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:[
                Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.filter_alt),
                ),
                DropdownButton(
                elevation: 12,
                underline: Container(),
                items: dropDownMenuItems
                  .map<DropdownMenuItem<String>>(
                      (String value) {
                  return DropdownMenuItem<String>(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        value,
                        style: TextStyle(
                            fontSize: 20),
                      ),
                    ),
                    value: value);
                    }).toList(),
                    value: selectedValue,
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue =
                              newValue.toString();
                  });
                  },  
                ),
                ],
              ),
             ),
            SizedBox(height: 10),
            Container(
            height: MediaQuery.of(context).size.height - 280, // 85 is the total height of other widgets
            child: SearchResults(),
              ),
            ],
          ),
          )
     ),
      );
  }
  
}

SearchResults() {
}

