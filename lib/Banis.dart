import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Banis extends StatefulWidget {
  int id, langaugeId;
  Banis(int id, int langaugeId) {
    this.id = id;
    this.langaugeId = langaugeId;
  }

  @override
  _BanisState createState() => _BanisState();
}

class _BanisState extends State<Banis> {
//  List<Map<String,dynamic>> baniList = [];
  List baniListPunjabi = [];
  List baniListEnglish = [];
  Map<String, dynamic> langaugeMap;

  bool favoriteCheck = false;
  var url = '';

  List favoriteList = []; 

  @override
  void initState() {
    super.initState();
    print('id is ${widget.id}');

    retrieveBanis(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[300],
        title: baniListPunjabi.length == 0
            ? Text('')
            : Text(widget.langaugeId == 0
                ? langaugeMap['unicode']
                : langaugeMap['english']),
        elevation: 1,
        actions: <Widget>[

          favoriteCheck == false
              ? IconButton( 
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    favoriteCheck = true;
                    favoriteList.add(url);  
                    print('favoriteList $favoriteList');
                    setState(() {});
                  })
              : IconButton(icon: Icon(Icons.favorite), onPressed: () {
                 favoriteCheck = false;

                 if (favoriteList.contains(url)){
                   favoriteList.remove(url);
                   print('favoriteList $favoriteList');
                 } else{
                   print('removed nothing');
                 }

                 setState(() {
                   
                 });
          }),

          RaisedButton(
            child: Icon(
              Icons.language,
              color: Colors.white,
            ),
            // Text('Setting',
            //     style: TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed: () {
              showAlert(context);
            },
            elevation: 0,
            color: Colors.teal[300],
          )
        ],
      ),
      body: setUI(),
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

  retrieveBanis(int id) async {
    url = "https://api.gurbaninow.com/v2/banis/$id";
    print('url is $url');

    var response = await http.get(url);
    print('response is $response');

    var jsonResponse = convert.jsonDecode(response.body);
    // print('json response is $jsonResponse');

    langaugeMap = jsonResponse['baniinfo'];
    print('langaugeMap $langaugeMap');

    var bani = jsonResponse['bani'];
    // print('hukamnama $bani');

    for (var i in bani) {
      var x = i['line'];
      // print('hola $x');
      //map.add(x);

      var tanslation = x['translation'];
      // print('hola $eng');
      var eng = tanslation['english'];
      // print('eng is $eng');
      var def = eng['default'];
      //  print('def is $def');

      baniListEnglish.add(def);
      //print('baniListEnglish is $baniListEnglish');

      var y = x['gurmukhi'];
      var z = y['unicode'];
      baniListPunjabi.add(z);

      //  print('baniList $baniList');
      // baniList.add(x['gurmukhi']);
      //print('hola $baniList');
    }

    setState(() {});
  }

  setUI() {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: ListView.builder(
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
    );
  }
}
