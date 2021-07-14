import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transportapp/Model/City.dart';
import 'package:transportapp/View/Widgets/DropDownWidget.dart';
import 'package:transportapp/View/Widgets/FormTextField.dart';
import 'package:transportapp/View/Widgets/TabWidget.dart';

class WilayaSetting extends StatefulWidget {
  final Color color;

   WilayaSetting({this.color});
  @override
  _WilayaSettingState createState() => _WilayaSettingState();
}

class _WilayaSettingState extends State<WilayaSetting> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String text1;
  String text2;
  String ddValue ="";
  Firestore cloud =Firestore.instance;
  List<DropdownMenuItem<String>> list2 = List();
  List<City> city=List();

  Future<List<DropdownMenuItem<String>>> createTheList()async{
    List<DropdownMenuItem<String>> list = List();
    await cloud.collection("Wilaya").getDocuments().then((QuerySnapshot snapshot){
      snapshot.documents.forEach((element) {
        city.add(City(element.documentID, element.data["NomWilaya"], null));
      });
    });

    list.add(DropdownMenuItem(child:Text("Aucune"),value:"",));
    city.forEach((element) {
      list.add(DropdownMenuItem(child:Text(element.stateName,),value:element.codeState));

    });
    return list;
  }
  void initList()async{
    list2= await createTheList();
  }
@override
  void initState() {
    initList();
    super.initState();
  }
  void showToast() {
    Fluttertoast.showToast(
      msg: "La Wilaya est Ajoutée Correctement",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.blueGrey,
      fontSize: 16.0,
    );
  }
  void validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      cloud.collection("Wilaya").document("W$text2").setData({
        "NomWilaya": "${text1[0].toUpperCase()}${text1.substring(1)}",
      });
      showToast();
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  void validateAndSave2() {
   cloud.collection("Wilaya").document(ddValue).delete();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
          length: 1,
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.blueGrey,
            appBar: AppBar(
              title: Hero(
                tag: "wilaya",
                transitionOnUserGestures: true,
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    "Wilaya",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Spartan5",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.blueGrey,
              bottom: TabBar(indicatorColor: Colors.white, tabs: <Widget>[
                TabWidgets(
                  icon: Icons.add,
                  text: "Ajouter",
                  color: Colors.white,
                ),
              ]),
            ),
            body: TabBarView(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 14),
                            child: FormTextField(
                              abscur: false,
                              hint: "Écrire le nom de la wilaya",
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  return null;
                                } else {
                                  return "Ce case ne doit pas être vide";
                                }
                              },
                              function: (value){
                                text1=value;

                              },
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 14),
                              child: FormTextField(
                                abscur: false,
                                hint: "Écrire le numéro de la wilaya",
                                validator: (value) {
                                  if (value.isNotEmpty) {
                                    if (int.parse(value) == null) {
                                      return "Le numéro de wilaya doit être un nombre entier";
                                    }
                                    return null;
                                  } else {
                                    return "Ce case ne doit pas être vide";
                                  }
                                },
                                function: (value){
                                  text2=value;
                                },
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:  BorderRadius.circular(20.0),
                              ),
                              elevation: 8,
                              color: Colors.white,
                              child: Padding(
                                padding:  EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 8),
                                child: Text(
                                  'Ajouter',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.blueGrey,
                                      fontFamily: 'Spartan1'),
                                ),
                              ),
                              onPressed: validateAndSave,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}

