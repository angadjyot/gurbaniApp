import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gurbani_app/Banis.dart';
import 'package:gurbani_app/GuruGranthSahibJi.dart';
import 'package:gurbani_app/Hukamnama.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
//  List<Map<String, dynamic>> map = [];

  List map = [];
  var langaugeCheck = 1;

  List baniListPunjabi = [];
  List baniListEnglish = [];

  List arr = ['Sri Guru Granth Sahib Ji','Hukamnama']; 
  var icons = [
    'assets/images/book.png',
    'assets/images/study.png',
  ];


  @override
  void initState() { 
    super.initState();
    retrieveGurbani();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.teal[300],
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
                    color:  Colors.teal[300],
                  )
                ],
                bottom: TabBar(
                  tabs: <Widget>[
                    Text('My Bani', style: TextStyle(fontSize: 16.0)),
                    Text(
                      'Sri Guru Granth Sahib Ji',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text('Favourites', style: TextStyle(fontSize: 16.0)),
                  ],
                ),
                title: Text(' The Gurbani App',style:TextStyle(fontSize:22.0)),
              ),
              body: TabBarView(children: [
                setUIForBanis(),
                setUIForGuruGranthSahibJi(),
                Icon(Icons.directions_bike),
              ]))),
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
              langaugeCheck = 1;
              Navigator.pop(context, 'One');
              print('english');
              setState(() {});
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Punjabi'),
            onPressed: () {
              langaugeCheck = 0;
              Navigator.pop(context, 'Two');
              print('punjabi');
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  retrieveGurbani() async {
    var url = "https://api.gurbaninow.com/v2/banis";
    var response = await http.get(url);
    print('response is $response');

    var jsonResponse = convert.jsonDecode(response.body);
    // print('jsonResponse $jsonResponse');
    // var hukamnama = jsonResponse['hukamnama'];
    // print('hukamnama $jsonResponse');
    map = jsonResponse;
    // print('map is $map');

    for (var i in map) {
      var x = i['id'];
      //   print(x);
      //map.add(x);
    }

    setState(() {});
    // print('map is $map');

    //  for (var i in map){
    //    var gurmukhi = i['gurmukhi']['unicode'];
    //       print('gurmukhi $gurmukhi');
    //  }
  }



  setUIForBanis() {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: map.length,
          itemBuilder: (BuildContext context, int index) {
            return map.length == 0
                ? Text('')
                : ListTile(

                    title: 
                    langaugeCheck == 0
                        ? Text(map[index]['unicode'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold))
                        : Text(map[index]['english'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold)),
                
                    subtitle: Divider(height: 2, color: Colors.grey),
                    // trailing: Icon(Icons.favorite),  

                    onTap: () {
                      print('hello');
                      int id = map[index]['id'];
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return Banis(id, langaugeCheck);
                      }));
                    },
                  );
          },
        ),
      ),
    );
  }

   setUIForGuruGranthSahibJi() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 1.1,
              children: List<Widget>.generate(icons.length, (index) {
                return Stack(
                  children: <Widget>[
                    // Container(
                    //     // color: Colors.grey,
                    //     ),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          print('tapped');
                          onTap(index);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 0.8,
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[ 

                              Padding(
                                padding: const EdgeInsets.only(top:30.0),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: 
                                    Image(
                                      height: 70,
                                      image: AssetImage(icons[index]),
                                    )
                                    ),
                              ), 

                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(arr[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: Colors.blueGrey)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              scrollDirection: Axis.vertical,
              crossAxisCount: 2,
              mainAxisSpacing: 0.0,
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  } 

    onTap(index) {
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return GuruGranthSahibJi(langaugeCheck);
        }));
        break;

      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return Hukamnama(langaugeCheck);
        }));
        break;
      default:
    }
  }


 
   setUIForFavourites() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 1.1,
              children: List<Widget>.generate(icons.length, (index) {
                return Stack(
                  children: <Widget>[
                    // Container(
                    //     // color: Colors.grey,
                    //     ),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          print('tapped');
                          onTap(index);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 0.8,
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[ 

                              Padding(
                                padding: const EdgeInsets.only(top:30.0),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: 
                                    Image(
                                      height: 70,
                                      image: AssetImage(icons[index]),
                                    )
                                    ),
                              ), 

                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(arr[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: Colors.blueGrey)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              scrollDirection: Axis.vertical,
              crossAxisCount: 2,
              mainAxisSpacing: 0.0,
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  } 


}
