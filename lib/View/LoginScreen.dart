import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transportapp/Model/Constant.dart';
import 'package:transportapp/View/RegisterationScreen.dart';
import 'SettingsScreen.dart';
import 'MainAppScreen.dart';
import 'Widgets/FormTextField.dart';

class LoginScreen extends StatefulWidget {
  final Color color;

  LoginScreen({this.color});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String passWord;
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
            0.35,
            0.95
          ],
              colors: [
            widget.color,
            Colors.white,
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 85),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Bienvenue à",
                  style: Constant.kStyle10,
                ),
                Text('Guidini',
                style:Constant.kStyle11,),
                SizedBox(
                  height: 50,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FormTextField(
                        function: (value) {
                          email = value;
                        },
                        hint: "Email",
                        validator: (value) {
                          if (value.isNotEmpty) {
                            return null;
                          } else {
                            return "Ce case ne doit pas être vide";
                          }
                        },
                        abscur: false,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormTextField(
                        hint: "Mot de Pass",
                        function: (value) {
                          passWord = value;
                        },
                        abscur: true,
                        validator: (value) {
                          if (value.isNotEmpty) {
                            return null;
                          } else {
                            return "Ce case ne doit pas être vide";
                          }
                        },
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Material(
                      color: widget.color,
                      borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      elevation: 5.0,
                      child: MaterialButton(
                        onPressed: () async {
                          final FormState form = _formKey.currentState;
                          if(form.validate()){
                            try {
                              AuthResult user =
                              await _auth.signInWithEmailAndPassword(
                                  email: email, password: passWord);
                              if (user != null) {
                                if (user.user.uid ==
                                    "LjBriyibLeXRT12ZcCzE8JdFRmn1") {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SettingsScreen(color:widget.color,isUser:true),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MainAppScreen(color: widget.color,),
                                    ),
                                  );
                                }
                              }
                            } catch (e) {}
                          }else{

                          }

                        },

                        child: Text(
                          "Se connecter",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Spartan1',
                          ),
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                                text: "Pas de compte?",
                                style: TextStyle(
                                  fontFamily: 'Spartan5',
                                  color: widget.color,
                                  fontSize: 12,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: " S'inscrire.",
                                      style: TextStyle(
                                        fontFamily: 'Spartan1',
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                 RegistrationScreen(color:widget.color,) ,
                                            ),
                                          );
                                        })
                                ]),
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
