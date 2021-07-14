import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transportapp/Model/City.dart';
import 'package:transportapp/Model/Location.dart';
import 'package:transportapp/View/Widgets/DropDownWidget.dart';
import 'package:transportapp/View/Widgets/FormTextField.dart';
import 'package:transportapp/View/Widgets/TabWidget.dart';

class LocaliteSettings extends StatefulWidget {
  final Color color;

  LocaliteSettings({this.color});

  @override
  _LocaliteSettingsState createState() => _LocaliteSettingsState();
}

class _LocaliteSettingsState extends State<LocaliteSettings> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String ddValue = "";
  String ddValue2 = "";
  String ddValue4 = "";
  String ddValue5 = "";
Location tempLoc;
  String text = "",locationMod;
  Firestore cloud = Firestore.instance;
  List<DropdownMenuItem<String>> list2 = List();
  List<DropdownMenuItem<String>> list1 = List();
  List<City> city = List();
  List<Location> location = List();
  bool wilaya =false,nom=false;
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  Future<List<DropdownMenuItem<String>>> createTheList() async {
    await cloud
        .collection("Wilaya")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        final City city1 =
            City(element.documentID, element.data["NomWilaya"], null);
        city.add(city1);
      });
    });
    List<DropdownMenuItem<String>> list = List();
    list.add(DropdownMenuItem(
      child: Text("Aucune"),
      value: "",
    ));
    city.forEach((element) {
      list.add(DropdownMenuItem(
          child: Text(
            element.stateName,
          ),
          value: element.codeState));
    });

    return list;
  }

  Future<void> initS(String code) async {
    await cloud
        .collection("Localité")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        if(element.documentID.contains(code)){
          location.add(Location(element.documentID, element.data["NomLocalite"],
              element.data["CodeWilaya"]));
        }

      });
    });
  }

  Future<List<DropdownMenuItem<String>>> createList2(String code) async {
    List<DropdownMenuItem<String>> list = List();
    location.clear();
    await initS(code);
    list.add(DropdownMenuItem(
      child: Text("Aucune"),
      value: "",
    ));
    location.forEach((element) {
      list.add(DropdownMenuItem(
          child: Text(
            element.locationName,
          ),
          value: element.codeLocation));
    });

    return list;
  }

  void initList() async {
    list2 = await createTheList();
  }
  Location getLoc(String code) {
    Location tempLoc;
    location.forEach((element) {
      if (element.codeLocation == code) {
        tempLoc = Location(element.codeLocation, element.locationName,element.codeState
           );
      }
    });
    return tempLoc;
  }

  int getIndex(String code) {
    int count = 0;
    location.forEach((element) {
      if (element.codeState == code) {
        count++;
      }
    });
    return count;
  }

  void showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.blueAccent,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    initList();
    super.initState();
  }

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    int value = getIndex(ddValue);
    value = value + 1;
    final String codeDoc = ddValue +
        "L" +
        (value < 10 ? (value).toString().padLeft(2, "0") : (value).toString());
    if (form.validate()) {
      cloud.collection("Localité").document(codeDoc).setData({
        "NomLocalite": "${text[0].toUpperCase()}${text.substring(1)}",
        "CodeWilaya": ddValue
      });
      location.clear();
      initS(ddValue4);
      showToast("La Localité est Ajoutée Correctement");
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  void validateAndSave2() async {
    String index = ddValue2.substring(3);
    String code = ddValue5+index;
    if(ddValue2!="" &&ddValue4!=""){
      if(nom){
        final FormState form = _formKey2.currentState;
        if(form.validate()){
          cloud.collection("Localité").document(ddValue2).updateData(
              {
                "NomLocalite":"${locationMod[0].toUpperCase()}${locationMod.substring(1)}",
              }
          );
        }


      }
      if(wilaya){

        await cloud.collection("Station").getDocuments().then((QuerySnapshot snapshots){
          snapshots.documents.forEach((element) {
            if(element.data["CodeLocalite"]==ddValue2){
              cloud.collection('Station').document(element.documentID).updateData(
                  {
                    "CodeLocalite":code
                  }
              );
            }

          });
        });
        cloud.collection("Localité").document(code).setData({
          'NomLocalite':nom ? "${locationMod[0].toUpperCase()}${locationMod.substring(1)}":tempLoc.locationName,
          'CodeWilaya':ddValue5
        });
        cloud.collection("Localité").document(tempLoc.codeLocation).delete();
      }

     showToast("modification terminer correctement");
      
    }else{
      showToast("Choisir les donnes Correctement");
    }

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: widget.color,
        appBar: AppBar(
          title: Hero(
            tag: "loca",
            transitionOnUserGestures: true,
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                "Localité",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Spartan5",
                  color: Colors.white,
                ),
              ),
            ),
          ),
          backgroundColor: widget.color,
          bottom: TabBar(indicatorColor: Colors.white, tabs: <Widget>[
            TabWidgets(
              icon: Icons.add,
              text: "Ajouter",
              color: Colors.white,
            ),
            TabWidgets(
              icon: Icons.repeat,
              text: "Modifier",
              color: Colors.white,
            ),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            FutureBuilder(
              future: createTheList(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DropdownMenuItem<String>>> snapshot) {
                if (snapshot.hasData) {
                  return Form(
                    key: _formKey,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Sélectionner La wilaya",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Spartan5",
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 14),
                                child: DropDownWidget(
                                  function: (String newValue) {
                                    setState(() {
                                      ddValue = newValue;
                                    });
                                    ddValue = newValue;
                                  },
                                  ddValue: ddValue,
                                  ddColors: widget.color,
                                  items: list2,
                                )),
                            Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 14),
                                child: FormTextField(
                                  abscur: false,
                                  hint: "Écrire le nom de la Localité",
                                  validator: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        text = value;
                                      });
                                      text = value;
                                      return null;
                                    } else {
                                      return "Ce case ne doit pas être vide";
                                    }
                                  },
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: 30.0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                ),
                                elevation: 8,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 8),
                                  child: Text(
                                    'Ajouter',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: widget.color,
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
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            FutureBuilder(
              future: createTheList(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DropdownMenuItem<String>>> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Sélectionner La wilaya",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Spartan5",
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 14),
                              child: DropDownWidget(
                                function: (String newValue) async {
                                  setState(() {
                                    ddValue4 = newValue;

                                  });
                                  list1 = await createList2(ddValue4);
                                  ddValue4 = newValue;
                                },
                                ddValue: ddValue4,
                                ddColors: widget.color,
                                items: list2,
                              )),
                          Text(
                            "Quelle est la Localité que vous souhaitez Modifier ?",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Spartan5",
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 14),
                              child: DropDownWidget(
                                function: (String newValue) {
                                  setState(() {
                                    ddValue2 = newValue;
                                  });
                                  ddValue2 = newValue;
                                  tempLoc = getLoc(ddValue2);
                                },
                                ddValue: ddValue2,
                                ddColors: widget.color,
                                items: list1,
                              )),
                          Text(
                            "Que voulez-vous modifier?",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Spartan5",
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Wilaya",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Spartan5",
                                        color: Colors.white,
                                      ),
                                    ),
                                    Checkbox(
                                        checkColor: widget.color,
                                        activeColor: Colors.white,
                                        value: wilaya,
                                        onChanged: (value) {
                                          setState(() {
                                            wilaya = value;
                                          });
                                        }),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Nom",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Spartan5",
                                        color: Colors.white,
                                      ),
                                    ),
                                    Checkbox(
                                        checkColor: widget.color,
                                        activeColor: Colors.white,
                                        value: nom,
                                        onChanged: (value) {
                                          setState(() {
                                            nom = value;
                                          });
                                        }),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Builder(builder: (BuildContext context) {
                            if(wilaya){
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      "La Wilaya",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Spartan5",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DropDownWidget(
                                    function: (String newValue) {
                                      setState(() {
                                        ddValue5 = newValue;
                                      });
                                      ddValue5 = newValue;
                                    },
                                    ddValue: ddValue5,
                                    ddColors: widget.color,
                                    items: list2,
                                  ),
                                ],
                              ) ;
                            }else{
                              return Text("");
                            }
                          },),
                          Builder(builder: (BuildContext context) {
                            if(nom){
                              return Form(
                                key:_formKey2 ,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 4.0, bottom: 14),
                                  child: FormTextField(
                                    abscur: false,
                                    hint: "Écrire le Nom de la Localité",
                                    validator: (value) {
                                      if (value.isNotEmpty) {
                                        return null;
                                      } else {
                                        return "Ce case ne doit pas être vide";
                                      }
                                    },
                                    function: (value) {
                                      setState(() {
                                        locationMod = value;
                                      });

                                    },
                                  ),
                                ),
                              ) ;
                            }else{
                              return Text("");
                            }
                          },),
                          Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              elevation: 8,
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 8),
                                child: Text(
                                  'Modifier',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: widget.color,
                                      fontFamily: 'Spartan1'),
                                ),
                              ),
                              onPressed: validateAndSave2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
