import 'dart:io';
import 'package:flutter/material.dart';
import 'package:EventManager/Authorisations/SaveUser.dart';
import 'package:EventManager/Authorisations/PostgresKonnection.dart';
import 'package:postgres/postgres.dart';
import 'package:EventManager/user_profile_update.dart';


class NinjaCard extends StatefulWidget {

  PostgresKonnection _postgresKonnection;
  SaveUser _user;

  NinjaCard(this._user, this._postgresKonnection);

  @override
  _NinjaCardState createState() => _NinjaCardState();
}

class _NinjaCardState extends State<NinjaCard> {

  String name = "";
  Future runQuery(String email) async {

    PostgreSQLConnection _konnection =
    await widget._postgresKonnection.getKonnection();
    print(_konnection);

    var results = await _konnection.query('select admin_email from admino');
    //fetching the admin results from admino table in the database.

    bool isAdmin = false; //check the user is admin.
    //print("Admin is");
    //print(results);
    for (var result in results) {
      //if anyone of the admin email matches with the current email then we set the user as admin
      if (result[0] == email) {
        isAdmin = true;
      }
    }
    var res;
    if(!isAdmin)
     res = await _konnection.query("select participant_name from participant where participant_email=\'$email\'");
  else
     res = await _konnection.query("select admin_name from admino where admin_email=\'$email\'");

    setState((){
      name = res[0][0];
    });

  }


  @override
  Widget build(BuildContext context) {
    
    runQuery(widget._user.email);
    return Scaffold(

      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: Text('User Profile'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 40.0,
                backgroundImage: AssetImage('assets/images/logo.jpeg'),
              ),
            ),
            SizedBox(height: 50.0),
            Text(
              'Username:',
              style: TextStyle(
                color: Colors.purple,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              'Email:',
              style: TextStyle(
                color: Colors.purple,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                SizedBox(width: 10.0),
                Text(
                  widget._user.email,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    letterSpacing: 1.0,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      //if(tt)
      //{
      floatingActionButton: FloatingActionButton (
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage(widget._user, widget._postgresKonnection)), // needs speculation
          );
        },
        child: Icon(Icons.edit,),
        foregroundColor: Colors.white,
      ),
      //}
    );
  }

}
