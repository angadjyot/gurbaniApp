import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gurbani_app/Home.dart';

void main() => runApp(MaterialApp(
  title: "Star Batteries",
  debugShowCheckedModeBanner: false,
  home: Main(),   
  theme: ThemeData(primaryColor: Colors.teal[300],
  iconTheme: IconThemeData(color: Colors.white)),
));


class Main extends StatefulWidget {

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {


  void initState() { 
    super.initState();
    Timer(Duration(seconds: 2), () =>move());
  }

 move(){
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
          return Home(); 
       }
     ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            
            Align(alignment: Alignment.center,
            child: Container(
              child: Text('Gurbani App',style: TextStyle(fontSize: 30.0,color: Colors.orange),),
            ),
            ),  


            Align(alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 50),
              child: CircularProgressIndicator(
                backgroundColor: Colors.orange,
                valueColor:  new AlwaysStoppedAnimation<Color>(Colors.black),),
             )
           ,)
          ],
        ),
      ),
    );
  }
}