

import 'package:flutter/material.dart';


class IntroducePage extends StatefulWidget {
  const IntroducePage({super.key});
  @override
  _IntroducePageState createState() => _IntroducePageState();
}

class _IntroducePageState extends State<IntroducePage>
{
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Container(
        
          decoration: const BoxDecoration(
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
                child:SizedBox(
                width: 300,
                height: 300,
                child : Image.asset('assets/main_logo.png'),
                )
              ),
              const SizedBox(height: 20),
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