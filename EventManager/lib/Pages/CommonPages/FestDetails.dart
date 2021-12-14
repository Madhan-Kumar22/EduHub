import 'package:EventManager/Authorisations/PostgresKonnection.dart';
import 'package:EventManager/Authorisations/SaveUser.dart';
import 'package:EventManager/Classes/EventInfo.dart';
//import 'package:EventManager/Classes/SponsorInfo.dart';
import 'package:EventManager/Pages/Invigilator/InvigilatorEachEvent.dart';
import 'package:EventManager/Pages/Participant/ParticipantEachEvents.dart';
import 'package:EventManager/Widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

bool isSwitched = false;
// setState() {
//  isSwitched = false;
// }

var result22;

// ignore: must_be_immutable
class FestDetails extends StatefulWidget {
  PostgresKonnection _postgresKonnection;
  SaveUser _user;
  FestDetails(this._user, this._postgresKonnection);

  @override
  _FestDetailsState createState() => _FestDetailsState();
}

class _FestDetailsState extends State<FestDetails> {
  bool _isLoading = true;

  List<EventInfo> _eventList = [];
  List results;

  String festImageURL =
      "https://parsec.iitdh.ac.in/images/logos/logo-about.jpg";

  List res;

  Future runQuery() async {
    PostgreSQLConnection _konnection =
    await widget._postgresKonnection.getKonnection();

    print(_konnection);
    if (!isSwitched) {
      result22 = await _konnection.query('select * from evento');
    }
    // if else group part and event to ()
    ///////////////////////////////////

    //results1 = await _konnection.query('select * from evento');
    else {
      var mail = widget._user.email;
      var regID;
      var resul11 = await _konnection.query(
          'select participant_id from participant where participant_email= \'$mail\'');

      regID = resul11[0][0];
// select A.event_id,A.event_name,A.start_date_time,A.end_date_time,A.register_start_date_time,A.register_end_date_time,A.place,A.short_description,A.description,ABC.group_name,A.price from evento as A , group_participant as ABC where A.event_id=ABC.event_id and ABC.participant_id='2020230002';
      result22 = await _konnection.query(
          'select A.event_id,A.event_name,A.start_date_time,A.end_date_time,A.register_start_date_time,A.register_end_date_time,A.place,A.short_description,A.description,ABC.group_name,A.price from evento as A , group_participant as ABC where A.event_id=ABC.event_id and ABC.participant_id=\'$regID\'');
      //results1=await _konnection.query('select * from evento');
      /////////////////////////////////////
      //print("////////////////");
      //print(result22[0][0]);
      //print(result22[0][1]);
    }
    print(result22.length);

    _eventList.clear();

    for (int i = 0; i < result22.length; i++) {
      EventInfo _eventInfo = new EventInfo();

      _eventInfo.event_id = result22[i][0];
      _eventInfo.event_name = result22[i][1];
      _eventInfo.start_date_time = result22[i][2];
      _eventInfo.end_date_time = result22[i][3];
      _eventInfo.register_start_date_time = result22[i][4];
      _eventInfo.register_end_date_time = result22[i][5];
      _eventInfo.place = result22[i][6];
      _eventInfo.short_description = result22[i][7];
      _eventInfo.description = result22[i][8];
      _eventInfo.price =
      result22[i][10]; // 9 for each part and 10 for all events
      // _eventInfo.imageURL = results[i][11];

      _eventList.add(_eventInfo);
    }

    print(_eventList);
    print(_eventList.length);

    Future runQuery3() async {
      PostgreSQLConnection _konnection =
      await widget._postgresKonnection.getKonnection();
      print(_konnection);
      var results3 = await _konnection.query("select description from evento");
      print(results3);
    }

    runQuery3();

    setState(() {
      _isLoading = false;
    });
  }
/*
*
* */
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      runQuery();
    }
    // runQuery();
    return Scaffold(
      appBar: _isLoading
          ? null
          : appBarMain(context, widget._user, widget._postgresKonnection),
      //resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      body: _isLoading
          ? loading()
          : SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 50.0, bottom: 10.0),
                    child: new Text(
                      "Filter Registered Events",
                      style: new TextStyle(
                        fontSize: 25.0,
                        color: Colors.purple[300],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 0.0, bottom: 0.0),

                    child: Switch(
                      value: isSwitched,
                      inactiveTrackColor: Colors.white,
                      //inactiveColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          print("///////////");
                          runQuery();
                          print(isSwitched);
                        });
                      },
                      activeTrackColor: Colors.purpleAccent,
                      activeColor: Colors.purple,
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 30.0, bottom: 10.0),
                    child: new Text(
                      "Events",
                      style: new TextStyle(
                        fontSize: 30.0,
                        color: Colors.purple[300],
                        fontWeight: FontWeight.bold,)
                      ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 10.0),
                    child: Container(
                      color: Colors.purple[100],
                      child: new ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _eventList.length,
                        itemBuilder: (_, index) {
                          //this builds up all event list elements.
                          return PostUI(
                            context,
                            widget._user,
                            widget._postgresKonnection,
                            _eventList[index].event_id,
                            _eventList[index].imageURL,
                            _eventList[index].event_name,
                            _eventList[index].description,
                            _eventList[index].short_description,
                          );
                        },
                      ),
                    ),
                  ),

                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(top: 50.0, bottom: 10.0),
                  //   child: new Text(
                  //     "Sponsors",
                  //     style: new TextStyle(
                  //         fontSize: 22.0, color: Colors.white),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 24.0, vertical: 10.0),
                  //   child: Container(
                  //     color: Colors.black,
                  //     child: new ListView.builder(
                  //       padding: EdgeInsets.all(8.0),
                  //       physics: const ClampingScrollPhysics(),
                  //       scrollDirection: Axis.vertical,
                  //       shrinkWrap: true,
                  //       itemCount: _sponsorList.length,
                  //       itemBuilder: (_, index) {
                  //         return SponsorPostUI(
                  //           _sponsorList[index].sponsor_link,
                  //           _sponsorList[index].sponsor_name,
                  //           _sponsorList[index].sponsor_category,
                  //           "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget PostUI(
    BuildContext context,
    SaveUser _user,
    PostgresKonnection _postgresKonnection,
    // ignore: non_constant_identifier_names
    String event_ID,
    String image,
    // ignore: non_constant_identifier_names
    String event_name,
    String description,
    // ignore: non_constant_identifier_names
    String short_description,
    ) {
  bool isInvigilator;
  print("////////");
  print(_user.userID);
  print("////////");
  Future goToEvent() async {
    PostgreSQLConnection _konnection =
    await _postgresKonnection.getKonnection();

    print(_konnection);

    isInvigilator = false;

    var result =
    await _konnection.query('select invigilator_email from invigilator');
    for (var resu in result) {
      if (resu[0] == _user.email) {
        isInvigilator = true;
      }
    }

    if (isInvigilator) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  InvigilatorEachEvent(_user, _postgresKonnection, event_ID)));
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ParticipantEachEvents(_user, _postgresKonnection, event_ID)));
    }
  }

  return new Card(
    elevation: 20.0,
    clipBehavior: Clip.antiAlias,
    margin: EdgeInsets.all(15.0),
    color: Colors.red,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40.0),
      side: BorderSide(
        color: Colors.purple[100],
        width: 1.0,
      ),
    ),
    child: GestureDetector(
      onTap: () {
        goToEvent();
        print("clicked on event $event_ID");
      },
      child: new Container(
        color: Colors.white,
        padding: new EdgeInsets.all(25.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(
                    short_description,
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                // new Text(
                //   event_name,
                //   textAlign: TextAlign.center,
                //   style: new TextStyle(fontSize: 16.0, color: Colors.black),
                // )
              ],
            ),
            new Text(
              event_name,
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black),
            ),
            SizedBox(
              height: 10.0,
            ),
            new Image.asset(
              "assets/images/tech.jpg",
              fit: BoxFit.cover,
            ),
            // new Image.network(
            //   image,
            //   fit: BoxFit.cover,
            // ),
            SizedBox(
              height: 10.0,
            ),
            new Text(
              description,
              textAlign: TextAlign.center,
              style: new TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    ),
  );
}
