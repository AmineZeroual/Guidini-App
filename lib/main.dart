import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:transportapp/View/BottomSheetScreen.dart';
import 'package:transportapp/View/ChoicesScreen.dart';
import 'package:transportapp/View/MainAppScreen.dart';
import 'View/WelcomeScreen.dart';
import 'View/LoginScreen.dart';
import 'View/RegisterationScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>MainAppScreen()));
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>MainAppScreen()));
      },
    );


  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(context)=>WelcomeScreen(),
        '/Login':(context)=>LoginScreen(),
        '/Registration':(context)=>RegistrationScreen(),
        '/Map':(context)=> MainAppScreen(),
        '/Choices':(context)=>ChoicesScreen(allPaths: null,),
        '/BS':(context)=> BottomSheetScreen(),
      }
    );
  }
}
