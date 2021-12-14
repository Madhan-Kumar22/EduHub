import 'dart:io';
import 'package:EventManager/userprofile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:EventManager/Authorisations/auth.dart';
import 'package:validators/validators.dart';
import 'package:email_validator/email_validator.dart';
import 'package:EventManager/Authorisations/SaveUser.dart';
import 'package:EventManager/Authorisations/PostgresKonnection.dart';
import 'package:postgres/postgres.dart';
import 'package:EventManager/Authorisations/globals.dart' as g;

//User user1 = FirebaseAuth.instance.currentUser;
/*final _auth = FirebaseAuth.instance;
final currentUser =  FirebaseAuth.currentUser;
String userEmail;
void getCurrentUserEmail() async {
  final user =  await _auth.currentUser;
  await _auth.currentUser().then((value) => userEmail = value.email);
}*/

void toastMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      fontSize: 16.0);
}

class LoginPage extends StatefulWidget {
  PostgresKonnection _postgresKonnection;
  SaveUser _user;
  //user_det user1;

  LoginPage(this._user, this._postgresKonnection);
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginData {
  String username = '';
  String email = '';
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  String _validateEmail(String value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    try {
      assert(EmailValidator.validate(value));
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }

  String _validateUsername(String value) {
    if (value.length < 8) {
      return 'The Username must be at least 8 characters.';
    }

    return null;
  }

/*
  Future resetEmail(String newEmail) async {

    AuthResult authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser firebaseUser = authResult.user;
    var message="";
    //FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    //User firebaseUser = await _firebaseAuth.currentUser();
    User firebaseUser = await FirebaseAuth.instance.currentUser;

    firebaseUser
        .updateEmail(newEmail)
        .then(
          (value) => message = 'Success',
    )
        .catchError((onError) => message = 'error');
    return message;
  }
*/
  Future changeEmail(String email, String password, String newemail) async {
    try {
      User user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;
      await user.updateEmail(newemail);
      print(email);
      print(newemail);
      print("////3");
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  bool isAdmin = false;
  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.

      Future runQuery(String username, String email, String newemail) async {
        //final User user1 = await auth.currentUser();
        //final currentUser =  FirebaseAuth.currentUser;
        //User user = await FirebaseAuth.instance.currentUser();

        PostgreSQLConnection _konnection =
            await widget._postgresKonnection.getKonnection();
        print(_konnection);

        var results = await _konnection.query('select admin_email from admino');

        for (var result in results) {
          if (result[0] == email) {
            isAdmin = true;
          }
        }
        print(results);
        print("admin is :");
        //print(isAdmin);
        print("/////");
        var res1, res2, res3, res4;
        if (!isAdmin) {
          res1 = await _konnection.query(
              "update participant set participant_name=\'$username\' where participant_email=\'$email\'");
          res2 = await _konnection.query(
              "update participant set  participant_email=\'$newemail\' where participant_name=\'$username\'");
        } else {
          res3 = await _konnection.query(
              "update admino set admin_name=\'$username\' where admin_email=\'$email\'");
          print("////1");
          //isAdmin = true;
          res4 = await _konnection.query(
              "update admino set  admin_email=\'$newemail\' where admin_name=\'$username\'");
        }
      }

      runQuery(_data.username, widget._user.email, _data.email);

      print("////2");
      //Future runQuery2(String username, String email) async {
      // PostgreSQLConnection _konnection =
      //   await widget._postgresKonnection.getKonnection();
      //print(_konnection);
      /*
        var results1 =
            await _konnection.query('select admin_email from admino');
        bool isAdmin = false;
        for (var result in results1) {
          if (result[0] == email) {
            isAdmin = true;
          }
        }
        */
      // print("////&");
      // print(isAdmin);
      // print("////&");

      // }
      // }
      print("////9");
      //runQuery2(_data.username, _data.email);
      print("////9");
      //resetEmail(_data.email);
      print("prev admin mail");
      print(widget._user.email);
      print("future admin mail");
      print(_data.email);
      print("future admin username");
      print(_data.username);
      //user_det user2;
      //print(widget.user1.password1);
      print(g.pass);
      String password = g.pass; // get password from auth page to this page
      print(widget._user.email);
      print(_data.email);
      print("////%");
      changeEmail(widget._user.email, password, _data.email);

      //print('Printing the login data.');
      print('Username: ${_data.username}');
      print('Email: ${_data.email}');

      toastMessage("User Profile Updated Successfully");
      widget._user.email = _data.email;
      Navigator.pop(context);
      //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => NinjaCard(widget._user, widget._postgresKonnection)), // needs speculation
      //    );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    print("//////////////////////////");
    //print(user1);
    print("//////////////////////////");
    return new Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: new AppBar(
        backgroundColor: Colors.purple,
        title: new Text('Profile Update'),
      ),
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                new TextFormField(
                    style: TextStyle(color: Colors.purple),
                    decoration: new InputDecoration(
                        hintText: 'Update Username', labelText: 'Username'),
                    validator: this._validateUsername,
                    onSaved: (String value) {
                      this._data.username = value;
                    }),
                new TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                        color:
                            Colors.purple), // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: 'you@example.com',
                        labelText: 'E-mail Address'),
                    validator: this._validateEmail,
                    onSaved: (String value) {
                      this._data.email = value;
                    }),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Update',
                      style: new TextStyle(color: Colors.white),
                    ),
                    onPressed: this.submit,
                    color: Colors.purple,
                  ),
                  margin: new EdgeInsets.only(top: 20.0),
                )
              ],
            ),
          )),
    );
  }
}
