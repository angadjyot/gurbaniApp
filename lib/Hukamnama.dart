import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
// import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';


class Hukamnama extends StatefulWidget {
  int langaugeId;
  Hukamnama(int langaugeId) {
    this.langaugeId = langaugeId;
  }

  @override
  _HukamnamaState createState() => _HukamnamaState();
}

class _HukamnamaState extends State<Hukamnama> {
  List baniListPunjabi = [];
  List baniListEnglish = [];

  Map<String, dynamic> gregorian;
  Map<String, dynamic> punjabi;

  TextEditingController hukamnamaDate = TextEditingController();

  var gDate = '';
  var gMonth = '';
  var gYear = '';

  var pDate = '';
  var pMonth = '';
  var pYear = '';

  var oldHukamnamaDay = '';
  var oldHukamnamaMonth = '';
  var oldHukamnamaYear = '';


  bool search = false; 
  DateTime _currentDate;

  DateTime date = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();


  @override
  void initState() {
    super.initState();
    retrieveHukamnama();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: baniListPunjabi.length == 0
              ? Text('')
              : Center(
                child: Text(
                    widget.langaugeId == 0
                        ? '$pDate $pMonth $pYear'
                        : '$gDate $gMonth $gYear',
                    style: TextStyle(color: Colors.white),
                  ),
              ),
          backgroundColor: Colors.teal[300],
          iconTheme: IconThemeData(color: Colors.white),
          brightness: Brightness.dark,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              onPressed: () {
              //  search = true;
              selectDate(context);
                setState(() {
                  
                });
              },
              color: Colors.blue[300],
            ),
            IconButton(
              icon: Icon(
                Icons.language,
                color: Colors.white,
              ),
              onPressed: () {
                showAlert(context);
              },
              color: Colors.blue[300],
            )
          ]),
      body: setUI(),
    );
  }


  //   setCalendar() {
  //   return CalendarCarousel(
  //     onDayPressed: (DateTime date, List l) {
  //       setState(() {
  //        this._currentDate = date;
  //         print('date is ${this._currentDate}');
  //       });
  //     },
  //     thisMonthDayBorderColor: Colors.green,
  //     height: 420.0,
  //     selectedDateTime: _currentDate,
  //     daysHaveCircularBorder: false,
  //   );
  // }

   Future<Null> selectDate(BuildContext context) async {

     try {
      final DateTime picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 45000)),
      lastDate: DateTime.now(),
      // initialDate: DateTime.now().subtract(Duration(days: 0)),
      initialDate: DateTime.now()
    );
    print('date selected ${picked.toString()}');
    setState(() {
      date = picked;
      String x = DateFormat('yyyy-MM-dd').format(date);
      print('date is $x');
      oldHukamnamaDay = '${date.day}';
      oldHukamnamaMonth = '${date.month}';
      oldHukamnamaYear = '${date.year}';

      print('$oldHukamnamaDay,$oldHukamnamaMonth,$oldHukamnamaYear');

      retrieveOldHukamnama();

     // hukamnamaDate.text = x;
    });
    print('selected date is ${date.toString()}'); 
     } catch (e) {
       print('error is ${e.toString()}');
     }
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

  setUI() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          // search == true ?
          // Padding(
          //   padding: const EdgeInsets.only(top: 5.0),
          //   child: Container(
          //     height: 60,
          //     width: MediaQuery.of(context).size.width,
          //     color: Colors.white,
          //     child:
          //         Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

          //       Padding(
          //         padding: const EdgeInsets.only(left:8.0),
          //         child: Container(
          //           // color: Colors.yellow,
          //           width: MediaQuery.of(context).size.width / 1 * 0.7,
          //           child: TextField(
          //             controller: hukamnamaDate,
          //             onTap: (){
          //               selectDate(context);
          //             }
          //           ),
          //         ),
          //       ),

          //       Padding(
          //         padding: const EdgeInsets.only(left:8.0),
          //         child: Container(
          //           // color: Colors.pink,
          //           width:  MediaQuery.of(context).size.width / 5,
          //           // height: 30,
          //           child: Padding(
          //             padding: const EdgeInsets.only(top:8.0),
          //             child: RaisedButton(
          //               child: Text('Search',style:TextStyle(color: Colors.white)),
          //               onPressed: () {},
          //               color: Colors.blue[300],
          //             ),
          //           ),
          //         ),
          //       )
          //     ]),
          //   ),
          // ) :  Container(),

          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
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
        ],
      ),
    );
  }

  retrieveHukamnama() async {
    baniListEnglish.clear();
    baniListPunjabi.clear();

    var url = "https://api.gurbaninow.com/v2/hukamnama/today";
    var response = await http.get(url);
    //print('response is $response');

    var jsonResponse = convert.jsonDecode(response.body);
    print('jsonResponse $jsonResponse');

    var hukamnama = jsonResponse['hukamnama'];
    // print('hukamnama $hukamnama');
    var date = jsonResponse['date'];
    print('date is $date');

    gregorian = date['gregorian'];
    print('gregorian is $gregorian');

    gDate = '${gregorian['date']}';
    gMonth = '${gregorian['month']}';
    gYear = '${gregorian['year']}';

    print('$gDate $gMonth $gDate');

    var nanakshahi = date['nanakshahi'];
    print('nanakshahi is $nanakshahi');

    punjabi = nanakshahi['punjabi'];
    print('punjabi is $punjabi');

    pDate = '${punjabi['date']}';
    pMonth = '${punjabi['month']}';
    pYear = '${punjabi['year']}';

    print('$pDate $pMonth $pDate');

    for (var i in hukamnama) {
      var x = i['line'];
      // print('map is $x');

// punjabi
      var y = x['gurmukhi']['unicode'];
      // print('y is $y');
      baniListPunjabi.add(y);
      // print('baniListPunjabi $baniListPunjabi');

// // english
      var translation = x['translation'];
      // print('translation is $translation');

      var eng = translation['english']['default'];
      //print('eng is $eng');

      baniListEnglish.add(eng);
      //  print('baniListEnglish $baniListEnglish');
    }
    setState(() {});
  }


    retrieveOldHukamnama() async {
    baniListEnglish.clear();
    baniListPunjabi.clear();

    var url = "https://api.gurbaninow.com/v2/hukamnama/$oldHukamnamaYear/$oldHukamnamaMonth/$oldHukamnamaDay";
    var response = await http.get(url);
    //print('response is $response');

    var jsonResponse = convert.jsonDecode(response.body);
    print('jsonResponse $jsonResponse');

    var hukamnama = jsonResponse['hukamnama'];
    // print('hukamnama $hukamnama');
    var date = jsonResponse['date'];
    print('date is $date');

    gregorian = date['gregorian'];
    print('gregorian is $gregorian');

    gDate = '${gregorian['date']}';
    gMonth = '${gregorian['month']}';
    gYear = '${gregorian['year']}';

    print('$gDate $gMonth $gDate');

    var nanakshahi = date['nanakshahi'];
    print('nanakshahi is $nanakshahi');

    punjabi = nanakshahi['punjabi'];
    print('punjabi is $punjabi');

    pDate = '${punjabi['date']}';
    pMonth = '${punjabi['month']}';
    pYear = '${punjabi['year']}';

    print('$pDate $pMonth $pDate');

    for (var i in hukamnama) {
      var x = i['line'];
      // print('map is $x');

// punjabi
      var y = x['gurmukhi']['unicode'];
      // print('y is $y');
      baniListPunjabi.add(y);
      // print('baniListPunjabi $baniListPunjabi');

// // english
      var translation = x['translation'];
      // print('translation is $translation');

      var eng = translation['english']['default'];
      //print('eng is $eng');

      baniListEnglish.add(eng);
      //  print('baniListEnglish $baniListEnglish');
    }
    setState(() {});
  }



}
