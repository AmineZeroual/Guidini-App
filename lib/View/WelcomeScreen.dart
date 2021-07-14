import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportapp/Model/Constant.dart';
import 'package:transportapp/View/LoginScreen.dart';
import 'MainAppScreen.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:introduction_screen/introduction_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Color color1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    color1 = Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        globalBackgroundColor: color1,
        pages: [
          PageViewModel(
            title: "Prêt À Prendre La Route ?",
            decoration: PageDecoration(
              titleTextStyle: Constant.kStyle7,
              titlePadding: EdgeInsets.only(top: 50),
              descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              imagePadding: EdgeInsets.zero,
              bodyTextStyle: Constant.kStyle1,
            ),
            bodyWidget: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/images/png1.png",
                    width: 300.0,
                    height: 300,
                    alignment: Alignment.center,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Trouvez le meilleur chemin vers votre destination et s'amesez de la ville !",
                    style: Constant.kStyle1,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          PageViewModel(
              title: 'Choisissez Votre Couleur Préférée',
              decoration: PageDecoration(
                titleTextStyle: Constant.kStyle7,
                titlePadding: EdgeInsets.only(top: 50),
                descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                imagePadding: EdgeInsets.zero,
                bodyTextStyle: Constant.kStyle1,
              ),
              bodyWidget: Padding(
                padding:  EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: MaterialColorPicker(
                        shrinkWrap: true,
                        allowShades: true,
                        onlyShadeSelection: true,
                        circleSize: 50,
                        onColorChange: (color) {
                          setState(() {
                            color1 = color;
                            Constant varConst = Constant();
                            varConst.setColor(color1);
                          });
                          color1 = color;
                        },
                        selectedColor: color1,
                        colors: [
                          Colors.pink,
                          Colors.red,
                          Colors.amber,
                          Colors.yellow,
                          Colors.green,
                          Colors.blue,
                          Colors.purple,
                          Colors.deepPurple,
                          Colors.grey,
                          Colors.blueGrey,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )),
        ],
        onDone: () {
          if (Platform.isIOS) {
            showCupertinoDialog(
              context: context,
              builder: (_) => CupertinoAlertDialog(
                title: Text('Avertissement !'),
                content: Text(
                    "En utilisant le mode visiteur, vous ne pouvez pas voir votre historique de recherche"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/Map');
                      },
                      child: Text("Visiteur"),
                    ),
                  ),
                  CupertinoDialogAction(
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/Login');
                      },
                      child: Text("Se connecter"),
                    ),
                  ),
                ],
              ),
            );
          } else if (Platform.isAndroid) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(
                  'Avertissement !',
                  style: Constant.kStyle4,
                ),
                content: Text(
                  "En utilisant le mode visiteur, vous ne pouvez pas voir votre historique de recherche",
                  style: Constant.kStyle1,
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainAppScreen(
                            color: color1,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Visiteur",
                      style: Constant.kStyle1,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen(
                                  color: color1,
                                )),
                      );
                    },
                    child: Text(
                      "Se connecter",
                      style: Constant.kStyle1,
                    ),
                  ),
                ],
                backgroundColor: color1,
                elevation: 15,
              ),
            );
          }
        },
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        skip:  Text(
          'Skip',
          style: Constant.kStyle1,
        ),
        next:  Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
        done:  Text(
          'Done',
          style: Constant.kStyle1,
        ),
        dotsDecorator:  DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeColor: Colors.white,
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
