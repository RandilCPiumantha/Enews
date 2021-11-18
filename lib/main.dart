import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/views/home.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MyApp> {

  String _status;


  @override
  void initState() {
    _status = 'Not Authenticated';
  }


  void _signInAnon() async {
    FirebaseUser user = (await _auth.signInAnonymously()) as FirebaseUser;
    if(user != null && user.isAnonymous == true) {
      setState(() {
        _status = 'Signed in Anonymously';
      });
    } else {
      setState(() {
        _status = 'Sign in failed!';
      });
    }
  }



  void _signInGoogle(BuildContext context) async {


    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    Navigator.push(context,MaterialPageRoute(
        builder: (context) => HomePage()));


    if(user != null && user.isAnonymous == false) {
      setState(() {
        _status = 'Signed in with Google';
      });
    } else {
      setState(() {
        _status = 'Google Signin Failed';
      });
    }
  }


  // class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Colors.white,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: HomePage(),
//     );
//   }
// }

  void _signOut() async {
    await _auth.signOut();
    setState(() {
      _status = 'Signed out';
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Name here'),
      ),
      body: new Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(_status),
                new RaisedButton(onPressed: _signOut, child: new Text('Sign out'),),
                new RaisedButton(onPressed: _signInAnon, child: new Text('Sign in Anon'),),
                new RaisedButton(onPressed:() => _signInGoogle(context), child: new Text('Sign in Google'),),
              ],
            ),
          )
      ),
    );
  }
}





