import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transportapp/Model/City.dart';
import 'package:transportapp/Model/Constant.dart';
import 'package:transportapp/Model/Line.dart';
import 'package:transportapp/Model/Location.dart';
import 'package:transportapp/Model/Slice.dart';
import 'package:transportapp/Model/StationInfo.dart';
import 'package:transportapp/View/Widgets/DropDownWidget.dart';
import 'package:transportapp/View/Widgets/FormTextField.dart';
import 'package:transportapp/View/Widgets/TabWidget.dart';
import 'dart:io';

class LineSetting extends StatefulWidget {
  final Color color;

  const LineSetting({this.color});

  @override
  _LineSettingState createState() => _LineSettingState();
}

class _LineSettingState extends State<LineSetting> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String ddValue = "";
  String ddValue2 = "";
  String ddValue3 = "";
  String ddValue4 = "";
  String ddValue5 = "";
  String ddValue6 = "";
  String ddValue7 = "";
  String text1 = "";
  String stationAv = "";
  String stationDp = "";
  List<Location> location = List();
  Firestore cloud = Firestore.instance;
  String code1, code2;
  List<DropdownMenuItem<String>> list2 = List();
  List<DropdownMenuItem<String>> list3 = List();
  List<DropdownMenuItem<String>> list4 = List();
  List<DropdownMenuItem<String>> list1 = List();

  List<City> city = List();
  List<Line> line = List();
  List<Slice> sliceList = List();

  Future<List<DropdownMenuItem<String>>> createTheList() async {
    city.clear();
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

  Future<List<DropdownMenuItem<String>>> createTheList2(String code) async {
    line.clear();
    await cloud
        .collection("Ligne")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        if (element.documentID.contains(code)) {
          final Line line1 = Line(
              element.documentID,
              element.data["CodeWilaya"],
              element.data["CodeMoyenDeTransport"],
              element.data["Destination"],
              element.data["Origine"]);
          line.add(line1);
        }
      });
    });
    List<DropdownMenuItem<String>> list = List();
    list.add(DropdownMenuItem(
      child: Text("Aucune"),
      value: "",
    ));
    line.forEach((element) {
      list.add(DropdownMenuItem(
          child: Text(
            element.origin + "-" + element.destination,
          ),
          value: element.codeLine));
    });
    return list;
  }


  void createList(String value) async {
    sliceList.clear();
    await cloud
        .collection("Tronçon")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        if (element.documentID.startsWith(value)) {
          final Slice slice = Slice(
              element.documentID,
              element.data['CodeStation1'],
              element.data['CodeStation2'],
              element.data['CodeLigne'],
              element.data['Distance'],
              element.data['Duree']);
          sliceList.add(slice);
        }
      });
    });
  }

  void initList() async {
    list2 = await createTheList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initList();
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: "Supprission Terminer Correctement",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showToast2() {
    Fluttertoast.showToast(
      msg: "La Ligne est Ajoutée Correctement",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: widget.color,
      fontSize: 16.0,
    );
  }

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    int templn = text1.length;
    String lineV2 = templn == 1
        ? text1.padLeft(3, "0")
        : templn == 2 ? text1.padLeft(3, "0") : text1;
    String transp = ddValue2 == "Bus"
        ? "LBS"
        : ddValue2 == "Tramway"
            ? "LTY"
            : ddValue2 == "Métro"
                ? "LMO"
                : ddValue2 == "Train" ? "LTN" : ddValue2 == "Taxi" ? "LTX" : "";
    String codeLigne = ddValue + transp + lineV2;
    if (form.validate()) {
      Firestore.instance.collection("Ligne").document(codeLigne).setData({
        "CodeMoyenDeTransport": ddValue2,
        "CodeWilaya": ddValue,
        "Destination": "${stationAv[0].toUpperCase()}${stationAv.substring(1)}",
        "Origine": "${stationDp[0].toUpperCase()}${stationDp.substring(1)}",
      });
      Firestore.instance.collection("Tronçon").document(codeLigne+"T001").setData({
        "CodeStation1":code1,
        "CodeStation2":code2,
        "CodeLigne":codeLigne,
        "Distance":"0",
        "Duree":"0"
      });
      Firestore.instance.collection("Tronçon").document(codeLigne+"T002").setData({
        "CodeStation1":code2,
        "CodeStation2":code1,
        "CodeLigne":codeLigne,
        "Distance":"0",
        "Duree":"0"
      });
      showToast2();
    } else {
      print('Form is invalid');
    }
  }

  void validateAndSave2() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text('Avertissement !'),
          content: Text(
              "Voulez-vous vraiment supprimer cette station"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: CupertinoButton(
                onPressed: () {
                  try {
                    cloud.collection("Ligne").document(ddValue3).delete();
                    cloud.collection("Station").getDocuments().then((QuerySnapshot snapshot) {
                      snapshot.documents.forEach((element) {
                        if (element.documentID.startsWith(ddValue3)) {
                          cloud.collection("Station").document(element.documentID).delete();
                        }
                      });
                    });
                    cloud.collection("Tronçon").getDocuments().then((QuerySnapshot snapshot) {
                      snapshot.documents.forEach((element) {
                        if (element.documentID.startsWith(ddValue3)) {
                          cloud.collection("Tronçon").document(element.documentID).delete();
                        }
                      });
                    });
                    showToast();
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text("Oui"),
              ),
            ),
            CupertinoDialogAction(
              child: CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Non"),
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
            "Voulez-vous vraiment supprimer cette station",
            style: Constant.kStyle1,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                try {
                  cloud.collection("Ligne").document(ddValue3).delete();
                  cloud.collection("Station").getDocuments().then((QuerySnapshot snapshot) {
                    snapshot.documents.forEach((element) {
                      if (element.documentID.startsWith(ddValue3)) {
                        cloud.collection("Station").document(element.documentID).delete();
                      }
                    });
                  });
                  cloud.collection("Tronçon").getDocuments().then((QuerySnapshot snapshot) {
                    snapshot.documents.forEach((element) {
                      if (element.documentID.startsWith(ddValue3)) {
                        cloud.collection("Tronçon").document(element.documentID).delete();
                      }
                    });
                  });
                  showToast();
                } catch (e) {
                  print(e);
                }
              },
              child: Text(
                "Oui",
                style: Constant.kStyle1,
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(
                  context
                );
              },
              child: Text(
                "Non",
                style: Constant.kStyle1,
              ),
            ),
          ],
          backgroundColor: widget.color,
          elevation: 15,
        ),
      );
    }
    /************************************************/
    /********************************************/

  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: widget.color,
        appBar: AppBar(
          title: Hero(
            tag: "line",
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                "Ligne",
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
              icon: Icons.delete_forever,
              text: "Supprimer",
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
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Sélectionner La wilaya",
                              style: TextStyle(
                                fontSize: 15,
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
                                    items: list2)),
                            Text(
                              "Sélectionner Le Moyen de Transport",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Spartan5",
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 14),
                                child: DropDownWidget(
                                  function: (String newValue) {
                                    setState(() {
                                      ddValue2 = newValue;
                                    });
                                    ddValue2 = newValue;
                                  },
                                  ddValue: ddValue2,
                                  ddColors: widget.color,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text("Aucune"),
                                      value: "",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Bus"),
                                      value: "Bus",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Tramway"),
                                      value: "Tramway",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Métro"),
                                      value: "Métro",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Train"),
                                      value: "Train",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Taxi"),
                                      value: "Taxi",
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0, bottom: 14),
                              child: FormTextField(
                                abscur: false,
                                hint: "Écrire le numéro de la ligne",
                                validator: (value) {
                                  if (value.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "Ce case ne doit pas être vide";
                                  }
                                },
                                function: (value) {
                                  text1 = value;
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 4.0, bottom: 14),
                                        child: FormTextField(
                                          abscur: false,
                                          hint: "Station du Début",
                                          validator: (value) {
                                            if (value.isNotEmpty) {
                                              return null;
                                            } else {
                                              return "Ce case ne doit pas être vide";
                                            }
                                          },
                                          function: (value) {
                                            stationDp = value;
                                          },
                                        ),
                                      ),
                                      RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(20.0),
                                        ),
                                        elevation: 8,
                                        color: Colors.white,
                                        onPressed: () async {
                                          code1 = await showModalBottomSheet(
                                            context: context,
                                            builder: (context) =>
                                                SingleChildScrollView(
                                                  child: Container(
                                                  padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                    child: CreateStation(
                                                  wilaya: ddValue,
                                                  transportType: ddValue2,
                                                  line: text1,
                                                  name: stationDp,
                                                  color: widget.color,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 8),
                                          child: Text(
                                            'Créer',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: widget.color,
                                                fontFamily: 'Spartan1'),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 4.0, bottom: 14),
                                        child: FormTextField(
                                          abscur: false,
                                          hint: "Station du Fin",
                                          validator: (value) {
                                            if (value.isNotEmpty) {
                                              return null;
                                            } else {
                                              return "Ce case ne doit pas être vide";
                                            }
                                          },
                                          function: (value) {
                                            stationAv = value;
                                          },
                                        ),
                                      ),
                                      RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(20.0),
                                        ),
                                        elevation: 8,
                                        color: Colors.white,
                                        onPressed: () async {
                                          code2 = await showModalBottomSheet(
                                            context: context,
                                            builder: (context) =>
                                                SingleChildScrollView(
                                              child: Container(
                                                child: CreateStation(
                                                  wilaya: ddValue,
                                                  transportType: ddValue2,
                                                  line: text1,
                                                  name: stationAv,
                                                  color: widget.color,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 8),
                                          child: Text(
                                            'Créer',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: widget.color,
                                                fontFamily: 'Spartan1'),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15.0),
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
              builder: (BuildContext context, AsyncSnapshot<List<DropdownMenuItem<String>>> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.0, vertical: 15),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Sélectionner La wilaya",
                          style: TextStyle(
                            fontSize: 15,
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
                                  ddValue4 = newValue;
                                  list3 = await createTheList2(ddValue4);
                                },
                                ddValue: ddValue4,
                                ddColors: widget.color,
                                items: list2)),
                        Text(
                          "Sélectionner La Ligne",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Spartan5",
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 14),
                            child: DropDownWidget(
                                function: (String newValue) {
                                  setState(() {
                                    ddValue3 = newValue;
                                  });
                                  ddValue3 = newValue;
                                },
                                ddValue: ddValue3,
                                ddColors: widget.color,
                                items: list3)),
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
                                'Supprimer',
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
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*-------------------------BottomSheet Class-----------------------*/
/*-----------------------------------------------------------------*/
class CreateStation extends StatefulWidget {
  final String wilaya;
  final String transportType;
  final String line;
  final String name;
  final Color color;

  CreateStation(
      {this.wilaya, this.transportType, this.line, this.name, this.color});

  @override
  _CreateStationState createState() => _CreateStationState();
}

class _CreateStationState extends State<CreateStation> {
  double latitude;
  double longitude;
  Future<int> myFuture;

  final GlobalKey<FormState> _formKeyTemp = GlobalKey<FormState>();
  List<StationInfo> stations = List();
  List<Location> location = List();
  List<DropdownMenuItem<String>> loc = List();
  String ddValue2 = "";

  @override
  void initState() {
    initData();
    // TODO: implement initState
    super.initState();
  }

  Future<List<StationInfo>> initS(String code) async {
    List<StationInfo> list = List();
    await Firestore.instance
        .collection("Station")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        if(element.documentID.startsWith(code)){
          StationInfo stat = StationInfo(
              element.data["NomStation"],
              element.data["GeoPoint"],
              element.documentID,
              element.data["CodeLocalite"]);
          list.add(stat);
        }

      });
    });
    return list;
  }

  String getIndex(String code) {
    String count;
    String valeur = stations.isEmpty ?code+"000":stations
        .last.codeStation; //Regele le codage
    String miniVal = valeur.substring(10);
    int val = int.parse(miniVal) + 1;
    count = val.toString();
    return count;
  }




  void showToast2() {
    Fluttertoast.showToast(
      msg: "La Station est Ajoutée Correctement",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: widget.color,
      fontSize: 16.0,
    );
  }

  Future<List<DropdownMenuItem<String>>> createList2() async {
    List<DropdownMenuItem<String>> list = List();
    location.clear();
    await Firestore.instance
        .collection("Localité")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        location.add(Location(element.documentID, element.data["NomLocalite"],
            element.data["CodeWilaya"]));
      });
    });
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

  Future<void> initData() async {
    myFuture = Future.delayed(Duration(seconds: 1)).then((value) async {
      loc = await createList2();
      return 0;
    });
  }

  void validateAndSave() async {
    final FormState form = _formKeyTemp.currentState;
    int templn = widget.line.length;
    String lineV2 = templn == 1
        ? widget.line.padLeft(3, "0")
        : templn == 2 ? widget.line.padLeft(3, "0") : widget.line;

    String transp = widget.transportType == "Bus"
        ? "LBS"
        : widget.transportType == "Tramway"
            ? "LTY"
            : widget.transportType == "Métro"
                ? "LMO"
                : widget.transportType == "Train"
                    ? "LTN"
                    : widget.transportType == "Taxi" ? "LTX" : "";
    String codeVer = widget.wilaya + transp + lineV2;
    stations = await initS(codeVer);
    String val = getIndex(codeVer) ;
   int lenth = val.length;
    String stCount = lenth == 1
        ? val.padLeft(3, "0")
        : lenth == 2 ? val.padLeft(3, "0") : val;
    GeoPoint geo = GeoPoint(latitude, longitude);
    String codeStation = codeVer + "S" + stCount;
    if (form.validate()) {
        Firestore.instance.collection("Station").document(codeStation).setData({
          "NomStation":
              "${widget.name[0].toUpperCase()}${widget.name.substring(1)}",
          "GeoPoint": geo,
          "CodeLocalite": ddValue2,
        });

      showToast2();
      Navigator.pop(context, codeStation);
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: myFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot2) {
        if (snapshot2.hasData) {
          return Container(
            height: 300,
            color: Color(0xff2e6e50),
            child: Container(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
              ),
              child: Form(
                key: _formKeyTemp,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 30.0, bottom: 1, left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 14),
                          child: DropDownWidget(
                            function: (String newValue) {
                              setState(() {
                                ddValue2 = newValue;
                              });
                              ddValue2 = newValue;
                            },
                            ddValue: ddValue2,
                            ddColors: widget.color,
                            items: loc,
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0, bottom: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: FormTextField(
                                abscur: false,
                                hint: "Latitude",
                                validator: (value) {
                                  if (value.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "Ce case ne doit pas être vide";
                                  }
                                },
                                function: (value) {
                                  latitude = double.parse(value);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: FormTextField(
                                abscur: false,
                                hint: "Longitude",
                                validator: (value) {
                                  if (value.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "Ce case ne doit pas être vide";
                                  }
                                },
                                function: (value) {
                                  longitude = double.parse(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 8,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 8),
                          child: Text(
                            'Créer',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: widget.color,
                                fontFamily: 'Spartan1'),
                          ),
                        ),
                        onPressed: validateAndSave,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
