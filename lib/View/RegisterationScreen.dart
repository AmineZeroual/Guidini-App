import 'package:flutter/material.dart';
import 'Widgets/FormTextField.dart';
import 'file:///D:/study/PFE/appFolder/transport_app/lib/Model/Constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transportapp/View/MainAppScreen.dart';

class RegistrationScreen extends StatefulWidget {
  final Color color;

  const RegistrationScreen({this.color});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String email;
  String passWord;
  String userName;
  String phoneNumber;
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 85),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Rejoignez-nous à",
                  style: Constant.kStyle10,
                ),
                Text(
                  'Guidini',
                  style:Constant. kStyle11,
                ),
                SizedBox(
                  height: 50,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FormTextField(
                        function: (value) {
                          userName = value;
                        },
                        hint: "Nom d'Utilisateur",
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
                        function: (value) {
                          phoneNumber = value;
                        },
                        hint: "Numéro de téléphone",
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
                Center(
                  child: Material(
                    color: widget.color,
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        final FormState form = _formKey.currentState;
                        if (form.validate()) {
                          try {
                            AuthResult user =
                                await _auth.createUserWithEmailAndPassword(
                                    email: email, password: passWord);
                            if (user != null) {
                              await Firestore.instance
                                  .collection('Users')
                                  .document(email)
                                  .setData({
                                'UserId': user.user.uid,
                                'email': email,
                                'phoneNumber': phoneNumber,
                                'UserName': userName,
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MainAppScreen(color: widget.color,),
                                ),
                              );
                            }
                          } catch (e) {
                            Fluttertoast.showToast(
                              msg: e.toString(),
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey[350],
                              textColor: Color(0xff383285),
                              fontSize: 16.0,
                            );
                          }
                        } else {}
                      },
                      child: Text(
                        "S'inscrire",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Spartan1',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
