
import 'package:flutter/material.dart';


class IntroducePage extends StatefulWidget {
  const IntroducePage({Key? key}) : super(key: key);
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'login');
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      );
  }
}