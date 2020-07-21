import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class GuruGranthSahibJi extends StatefulWidget {
  int langaugeId;
  GuruGranthSahibJi(int langaugeId) {
    this.langaugeId = langaugeId;
  }

  @override
  _GuruGranthSahibJiState createState() => _GuruGranthSahibJiState();
}

class _GuruGranthSahibJiState extends State<GuruGranthSahibJi> {
  List baniListPunjabi = [];
  List baniListEnglish = [];

  var englishLang = '';
  var punjabiLang = '';

  int count = 1;

  // Map<String, dynamic> gregorian;


  List arr = ['Sri Guru Granth Sahib Ji', 'Hukamnama'];
  var icons = [
    'assets/images/book.png',
    'assets/images/study.png',
  ];

  @override
  void initState() {
    super.initState();
    retrieveGuruGranthSahibJiBani();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: baniListPunjabi.length == 0
              ? Text('')
              : Text(widget.langaugeId == 0 ? punjabiLang : englishLang,
                  style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          brightness: Brightness.dark,
          actions: <Widget>[
            // RaisedButton(
            //   child: Text('Setting',
            //       style: TextStyle(fontSize: 18.0, color: Colors.white)),
            //   onPressed: () {},
            //   elevation: 0,
            //   color: Colors.blue,
            // ),
            RaisedButton(
              child: Icon(
                Icons.language,
                color: Colors.white,
              ),
              onPressed: () {
                showAlert(context);
              },
              elevation: 0,
              color: Colors.teal[300],
            )
          ]
          ),
      body: setUIForGuruGranthSahibJi(),
    );
  }

  showAlert(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Choose Langauge', style: TextStyle(fontSize: 18.0)),
        message:
            const Text('Your options are', style: TextStyle(fontSize: 16.0)),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text('English'),
            onPressed: () {
              widget.langaugeId = 1;
              Navigator.pop(context, 'One');
              print('english');
              setState(() {});
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Punjabi'),
            onPressed: () {
              widget.langaugeId = 0;
              Navigator.pop(context, 'Two');
              print('punjabi');
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  retrieveGuruGranthSahibJiBani() async {
    baniListEnglish.clear();
    baniListPunjabi.clear();

    var url = "https://api.gurbaninow.com/v2/ang/$count";
    var response = await http.get(url);
    //print('response is $response');

    var jsonResponse = convert.jsonDecode(response.body);
    //  print('jsonResponse $jsonResponse');

    var langaugeSource = jsonResponse['source'];
    //  print('langauge is $langaugeSource');

    englishLang = langaugeSource['english'];
    punjabiLang = langaugeSource['unicode'];

    print('englishLang,punjabiLang $englishLang,$punjabiLang');

    var unicode = jsonResponse['page'];
    print('unicode $unicode');

    for (var i in unicode) {
      var x = i['line'];
      // print('map is $x');

// punjabi
      var y = x['gurmukhi'];
      // print('y is $y');
      var z = y['unicode'];
      //print('z is $z');
      baniListPunjabi.add(z);

// english
      var translation = x['translation'];
      // print('translation is $translation');

      var eng = translation['english']['default'];
      print('eng is $eng');

      baniListEnglish.add(eng);
      print('baniListEnglish $baniListEnglish');
    }
    setState(() {});
  }

  setUIForGuruGranthSahibJi() {
    return SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: Colors.white,
            // height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: baniListPunjabi.length,
                itemBuilder: (BuildContext context, int index) {
                  return baniListPunjabi.length == 0
                      ? Text('')
                      : ListTile(
                          title: widget.langaugeId == 0
                              ? Text(baniListPunjabi[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold))
                              : Text(baniListEnglish[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold)),
                          onTap: () {
                            // showPopup(context);
                          },
                        );
                },
              ),
            ),
          ),

          Container(
            // color: Colors.red,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, top: 5, bottom: 10.0, right: 12.0),
                  child: Align(  
                    alignment: Alignment.topCenter,
                    child: RaisedButton(
                      child: Text(
                        'Previous Page',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      onPressed: () {
                        minusFunc();
                      },
                      elevation: 0,
                      color: Colors.teal[300],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, top: 5, bottom: 10.0, right: 12.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 0.0, bottom: 0.0, top: 0.0),
                      child: RaisedButton(
                        child: Text(
                          'Next Page',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                        onPressed: () {
                          plusFunc();
                        },
                        elevation: 0,
                        color: Colors.teal[300],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  plusFunc() {
    count = count + 1;
    print('count is $count');
    retrieveGuruGranthSahibJiBani();
  }

  minusFunc() {
    count = count - 1;
    print('count is $count');
    retrieveGuruGranthSahibJiBani();
  }
}
