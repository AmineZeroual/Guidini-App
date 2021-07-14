import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportapp/Model/Constant.dart';

class NotificationScreen extends StatefulWidget {
  final Color color;

   NotificationScreen({this.color});
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
 @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child:
        Text("L'Ajout d'une notification s'effectue à partir du site Web de Firebase",
        style: Constant.kStyle4,
        textAlign: TextAlign.center,

        )),
      ),
    );
  }
}
