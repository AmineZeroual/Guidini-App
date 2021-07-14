import 'package:flutter/material.dart';
import 'package:transportapp/Model/Constant.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding:  EdgeInsets.only(top:45,left:15 ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Hero(
              transitionOnUserGestures: true,
              tag: "profile",
              child: Material(
                type: MaterialType.transparency,
                child: Text("Profil",
                  style: Constant.kStyle9,),
              ),
            ),
          ),
        )
    );
  }
}
