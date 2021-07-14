import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportapp/Model/Constant.dart';
import 'package:transportapp/View/DataScreen.dart';
import 'package:transportapp/View/HistoriqueScreen.dart';
import 'package:transportapp/View/LoginScreen.dart';
import 'package:transportapp/View/MainAppScreen.dart';
import 'package:transportapp/View/ProfilScreeen.dart';
import 'package:transportapp/View/StatistiqueScreen.dart';
import 'package:transportapp/View/WelcomeScreen.dart';

import 'Widgets/OptionsWidget.dart';

class OptionScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Color color;

  OptionScreen(this.color);

  Future<bool> isNotUser() async {
    bool isLogin;
    await auth.currentUser().then((value) => isLogin = (value == null));
    return isLogin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: auth.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
      if (snapshot.data != null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 14.0, top: 35, bottom: 16),
              child: Text(
                "Options",
                style: Constant.kStyle9,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 16),
                children: <Widget>[
                  OptionsWidgets(
                    color: color,
                    icon: Icons.account_circle,
                    text: "Profil",
                    tag:"profile",
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  OptionsWidgets(
                    color: color,
                    icon: Icons.sort,
                    text: "Les Données",
                    tag: "data",
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataScreen(color:color,isUser: false,),
                        ),
                      );
                    },
                  ),
                  OptionsWidgets(
                    color: color,
                    icon: Icons.history,
                    text: "Historique",
                    tag:"history",
                    function: () async {
                      FirebaseUser user = await auth.currentUser();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryScreen(color: color,user: user,),
                        ),
                      );
                    },
                  ),
                  OptionsWidgets(
                    color: color,
                    icon: Icons.arrow_back,
                    text: "Déconnecter",
                    tag: "",
                    function: () {
                      auth.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 14.0, top: 35, bottom: 16),
              child: Text(
                "Options",
                style: Constant.kStyle9,
              ),
            ),
            Expanded(
              child: GridView.count(
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 16),
                crossAxisCount: 2,
                children: <Widget>[
                  OptionsWidgets(
                    color: color,
                    icon: Icons.sort,
                    text: "Les Données",
                    tag: "data",
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataScreen(color: color,isUser: false,),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }
        },
      ),
    );
  }
}
