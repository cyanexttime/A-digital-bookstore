
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class IntroducePage extends StatefulWidget {
  const IntroducePage({Key? key}) : super(key: key);
  @override
  _IntroducePageState createState() => _IntroducePageState();
}

class _IntroducePageState extends State<IntroducePage>
{
  Widget build(BuildContext context){
    return SafeArea(
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/introduce_page.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          
          child: Column
          (
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child:Container(
                width: 300,
                height: 300,
                child : Image.asset('assets/main_logo.png'),
                )
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'login');
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    Text('Next'),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}