import 'package:EventManager/Authorisations/auth.dart';
import 'package:EventManager/Authorisations/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:EventManager/userprofile.dart';
import 'package:EventManager/Authorisations/SaveUser.dart';
import 'package:EventManager/Authorisations/PostgresKonnection.dart';
import 'package:postgres/postgres.dart';
import 'dart:core';
import 'package:EventManager/Pages/Admin/AdminEachEventDetails.dart';
import 'package:EventManager/Pages/Participant/ParticipantEachEvents.dart';
import 'package:EventManager/Pages/CommonPages/EventDetails.dart';
import 'package:EventManager/Authorisations/globals.dart' as g;

var results;
List<String> list2;
List<String> list1;
String eventid23;

void toastMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      fontSize: 16.0);
}

Container loading() {
  return Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          logo(90, 280),
          SizedBox(height: 45),
          LoadingBouncingGrid.square(
            borderColor: Colors.purple[300],
            borderSize: 9.0,
            size: 60.0,
            backgroundColor: Colors.purple,
            duration: Duration(milliseconds: 10000),
          )
        ],
      ),
    ),
  );
}

Widget logo(double h, double w) {
  return new Hero(
    tag: (h * w + h).toString(),
    child: Container(
      // alignment: Alignment.center,
      width: w,
      height: h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/logo.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

InputDecoration textInputDecoration(String labalText, String hintText) {
  return InputDecoration(
    labelText: labalText,
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white38,
    ),
    labelStyle: TextStyle(
      color: Colors.white,
    ),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
      color: Colors.white,
    )),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
      color: Colors.white,
    )),
  );
}

class DialogBox {
  informtion(BuildContext context, String title, String description) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(description),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    return Navigator.pop(context);
                  },
                  child: Text("Ok"))
            ],
          );
        });
  }
}

// ignore: non_constant_identifier_names
Widget DatailTitle(String title) {
  return new Text(
    title,
    textAlign: TextAlign.center,
    style:
        TextStyle(fontSize: 30.0, color: Colors.purple, fontFamily: "Signatra"),
  );
}

// ignore: non_constant_identifier_names
Widget DetailDescription(String data) {
  return SingleChildScrollView(
    child: new Card(
      elevation: 20.0,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(15.0),
      color: Colors.purple[100],

      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //         bottomRight: Radius.circular(50)),
      //     side: BorderSide(width: 1, color: Colors.blck)
      // ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
        side: BorderSide(
          color: Colors.purple[100],
          width: 1.0,
        ),
      ),
      child: new Container(
        color: Colors.white,
        padding: new EdgeInsets.all(15.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(
              data,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                // fontFamily: "Signatra"
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
Widget DetailImage(String data) {
  return SingleChildScrollView(
    child: new Card(
      elevation: 20.0,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(15.0),
      color: Colors.white,

      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //         bottomRight: Radius.circular(50)),
      //     side: BorderSide(width: 1, color: Colors.blck)
      // ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
        side: BorderSide(
          color: Colors.white,
          width: 1.0,
        ),
      ),
      child: new Container(
        color: Colors.white,
        padding: new EdgeInsets.all(15.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Image.network(
              data,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget appBarMain(BuildContext context, SaveUser _user,
    PostgresKonnection _postgresKonnection) {
  Future runQuery12() async {
    PostgreSQLConnection _konnection =
        await _postgresKonnection.getKonnection();
    print(_konnection);
    results = await _konnection.query("select event_name from evento");
    print(results);
    list1 = [];
    for (int i = 0; i < results.length; i++) {
      list1.add(results[i][0].toString());
    }
  }

  runQuery12();

  AuthorisationMethods _authorisationMethods = new AuthorisationMethods();
  return AppBar(
      backgroundColor: Colors.purple,
      toolbarHeight: 55,
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //logo(30, 100),
            Text(
              "Edu Hub", // 💫🌠
              style: TextStyle(
                  fontSize: 20.0, color: Colors.white, fontFamily: "Aries"),
            ),
            SizedBox(width: 60),

            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: DataSearch(_user, _postgresKonnection));
                }),

            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                _authorisationMethods.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NinjaCard(_user, _postgresKonnection)));
                toastMessage("User Profile Page loaded successfully");
              },
              color: Colors.white,
              hoverColor: Colors.blueAccent,
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _authorisationMethods.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => authenticate()));
                toastMessage("Signed-out successfully");
              },
              color: Colors.white,
              hoverColor: Colors.blueAccent,
            ),
          ])

      // logo(30,100),

      );
}

class DataSearch extends SearchDelegate<String> {
  PostgresKonnection _postgresKonnection;
  SaveUser _user;

  DataSearch(this._user, this._postgresKonnection);

  // Widget appBarMain1(BuildContext context, SaveUser _user, PostgresKonnection _postgresKonnection) {

/*
        Future goToEvent(String event_ID) async {
          PostgreSQLConnection _konnection = await _postgresKonnection
              .getKonnection();
          print(_konnection);
          await Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) =>
                      EventDetails(_user, _postgresKonnection, event_ID)));
        }
     // }
*/

  // should work on this for suggestions
  List list1_suggest = ["AlgoStrike", "DevHack 2.0 - Hardware"];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  //List<String> getResults(String query) {
  //apply getting results logic here
  //  return [];
  //}

  @override
  Widget buildResults(BuildContext context) {
    Future runquery1(String eventname) async {
      PostgreSQLConnection _konnection =
          await _postgresKonnection.getKonnection();
      print(_konnection);

      var results1 = await _konnection.query(
          "select event_id from evento where event_name = \'$eventname\'");
      eventid23 = results1[0][0].toString();
      //String hew = eventid23.toString();
      print(results1);
      print(eventid23);
      //print(hew);
      //}

      var results = await _konnection.query('select admin_email from admino');
      bool isAdmin = false;
      for (var result in results) {
        if (result[0] == _user.email) {
          isAdmin = true;
        }
      }

      
      if (!isAdmin) {
        await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ParticipantEachEvents(
                    _user, _postgresKonnection, eventid23)));
      } else {
         await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AdminEachEventDetails(
                    _user, _postgresKonnection, eventid23)));
      }

      //////////////////////////////////////////////////
      //Future goToEvent(String eventID) async {
      //  PostgreSQLConnection _konnection =
      //     await _postgresKonnection.getKonnection();
      // print(_konnection);
    }

    ////////////////////////////////////////////////////
    // }
    //String h = "Synergia";
    runquery1(query);

    return Container(
     
    );
  } //=> Container();
  //{

  /*return Container(
      height: 100.0,
      width: 100.0,
      child: Card(
        color: Colors.red,
        child: Center(
          child: Text(query),
        ),
      ),
    );
/*
         // final results = getResults(query);
         return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                // assuming `DetailsPage` exists
               // Navigator.push(context, DetailsPage(results[index]));
                goToEvent(index);
                print(index);
                //Navigator.pop(context);
              },
              title: Text(results[index]),
            ),
            itemCount: results.length,
            njosio
          );
          //gotoEvent();
          */ */
  //}

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? list1_suggest
        : list1
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          query = suggestionList.elementAt(index);
          showResults(context);
          //goToEvent
          //var results1;

          //eventid23 = "20202309";
          //print(eventid23);
          //goToEvent(eventid23);

          //super.showResults(context);
        },
        leading: Icon(
          Icons.assessment,
          color: Colors.white,
        ),
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].substring(0, query.length),
              style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.white))
              ]),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
