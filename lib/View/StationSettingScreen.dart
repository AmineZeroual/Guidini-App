import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transportapp/Controller/PathsAlgorithm.dart';
import 'package:transportapp/Model/City.dart';
import 'package:transportapp/Model/Constant.dart';
import 'package:transportapp/Model/Line.dart';
import 'package:transportapp/Model/Location.dart';
import 'package:transportapp/Model/Slice.dart';
import 'package:transportapp/Model/StationInfo.dart';
import 'package:transportapp/View/Widgets/DropDownWidget.dart';
import 'package:transportapp/View/Widgets/FormTextField.dart';
import 'package:transportapp/View/Widgets/TabWidget.dart';

class StationSetting extends StatefulWidget {
  final Color color;

  StationSetting({this.color});

  @override
  _StationSettingState createState() => _StationSettingState();
}

class _StationSettingState extends State<StationSetting> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();


  Firestore cloud = Firestore.instance;

  String ddValue = "";
  String ddValue2 = "";
  String ddValue4 = "";
  String ddValueSup1 = "";
  String ddValueSup2 = "";
  String ddValueSup3 = "";
  String ddValueMod1 = "";
  String ddValueMod2 = "";
  String ddValueMod3 = "";
  String ddValueMod4 = "";
  String ddValueT1 = "";
  String ddValueT2 = "";
  String station = "";
  String stationMod = "";
  String codStation = "";
  String latitude;
  String latitudeMod;
  bool localite = false, position = false, nom = false;

  String longitude;
  String longitudeMod;
  StationInfo tempStation1;

  StationInfo tempStation2;

  PathsAlgorithm pathAlgo = PathsAlgorithm();

  List<DropdownMenuItem<String>> list2 = List();
  List<DropdownMenuItem<String>> list4 = List();
  List<DropdownMenuItem<String>> list3 = List();
  List<DropdownMenuItem<String>> list1 = List();
  List<DropdownMenuItem<String>> list5 = List();
  List<DropdownMenuItem<String>> list6 = List();
  List<DropdownMenuItem<String>> list7 = List();
  List<DropdownMenuItem<String>> list8 = List();
  List<DropdownMenuItem<String>> list9 = List();
  List<City> city = List();
  List<Line> line = List();
  List<Location> location = List();
  List<StationInfo> stationInfo = List();
  List<Slice> sliceL = List();
  Line tempLine, tempLine2, tempLine3;

  Future<List<DropdownMenuItem<String>>> createTheList() async {
    List<DropdownMenuItem<String>> list = List();
    city.clear();
    list.clear();
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

  Future<List<DropdownMenuItem<String>>> createTheList3(Line l) async {
    List<StationInfo> station2 = List();
    stationInfo.clear();
    await cloud
        .collection("Station")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        if (element.documentID.startsWith(l.codeLine)) {
          final StationInfo satation =StationInfo(
              element.data["NomStation"],
              element.data["GeoPoint"],
              element.documentID,
              element.data["CodeLocalite"],);
          stationInfo.add(satation);
        }
      });
    });

    if (l.codeLine == "W16LMO001") {
      List<StationInfo> tempStatList = List();
      station2 = pathAlgo.getLinesStationList(l, l.origin, "Ain Naadja");
      tempStatList = pathAlgo.getLinesStationList(l, l.origin, l.destination);
      station2.addAll(tempStatList.sublist(12));
    } else {
      station2 = pathAlgo.getLinesStationList(l, l.origin, l.destination);
    }



    List<DropdownMenuItem<String>> list = List();
    list.add(DropdownMenuItem(
      child: Text("Aucune"),
      value: "",
    ));
    station2.forEach((element) {
      list.add(DropdownMenuItem(
          child: Text(
            element.stationName,
          ),
          value: element.codeStation));
    });
    return list;
  }

  Future<List<DropdownMenuItem<String>>> createTheList2(String value) async {
    line.clear();
    await cloud
        .collection("Ligne")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        if (element.documentID.startsWith(value)) {
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

  Future<List<DropdownMenuItem<String>>> createTheList4(String code) async {
    List<DropdownMenuItem<String>> list = List();
    location.clear();
    await Firestore.instance
        .collection("Localité")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        if (element.data["CodeWilaya"] == code) {
          location.add(Location(element.documentID, element.data["NomLocalite"],
              element.data["CodeWilaya"]));
        }
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

  void initList() async {
    list2.addAll(await createTheList());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initList();
    pathAlgo.initData();
  }

  int getIndex(String code) {
    int count = 0;
    stationInfo.forEach((element) {
      if (element.codeStation.startsWith(code)) {
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
      textColor: widget.color,
      fontSize: 16.0,
    );
  }

  void showToast2() {
    Fluttertoast.showToast(
      msg: "La Station est Supprimée Correctement",
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
    StationInfo stOrig = getStation2(tempLine.origin);
    StationInfo stDist = getStation2(tempLine.destination);

    if (form.validate()) {
      cloud.collection("Station").document(codStation).setData({
        "CodeLocalite": ddValue4,
        "NomStation": "${station[0].toUpperCase()}${station.substring(1)}",
        "GeoPoint": GeoPoint(double.parse(latitude).toDouble(),
            double.parse(longitude).toDouble()),
      });
      if (ddValueT1 != "" && ddValueT2 != "") {
        cloud
            .collection("Tronçon")
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((element) {
            if (element.data["CodeStation1"] == ddValueT1 &&
                element.data["CodeStation2"] == ddValueT2) {
              cloud.collection("Tronçon").document(element.documentID).delete();
            }
          });
        });

          cloud
              .collection("Tronçon")
              .getDocuments()
              .then((QuerySnapshot snapshot) {
            snapshot.documents.forEach((element) {
              if (element.data["CodeStation2"] == ddValueT1 &&
                  element.data["CodeStation1"] == ddValueT2) {
                cloud.collection("Tronçon").document(element.documentID).delete();
              }
            });
          });



      } else if (ddValueT1 ==stDist.codeStation && ddValueT2 == "" ||
          ddValueT1 == "" && ddValueT2 == stOrig.codeStation) {
        if (ddValueT1 ==stDist.codeStation && ddValueT2 == "" ) {
          if (tempStation1.stationName == stDist.stationName) {
            cloud.collection("Ligne").document(ddValue2).updateData({
              "Destination": "${station[0].toUpperCase()}${station.substring(1)}",
            });
          }
        } else {
          StationInfo tempStation2 = getStation(ddValueT2);
          if (tempStation2.stationName == stOrig.stationName) {
            cloud.collection("Ligne").document(ddValue2).updateData({
              "Origine": "${station[0].toUpperCase()}${station.substring(1)}",
            });
          }
        }
      }else {
        showToast('Choisir les station correctement ');
      }
      showToast("La Station est Ajoutée Correctement");
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  Line getLine(String code) {
    Line tempLine;
    line.forEach((element) {
      if (element.codeLine == code) {
        tempLine = Line(element.codeLine, element.codeWilaya,
            element.codeTransport, element.destination, element.origin);
      }
    });
    return tempLine;
  }

  StationInfo getStation(String code) {
    StationInfo temStation;
    stationInfo.forEach((element) {
      if (element.codeStation == code) {
        temStation = StationInfo(element.stationName, element.geoPoint,
            element.codeStation, element.codeLocation);
      }
    });
    return temStation;
  }
  StationInfo getStation2(String name) {
    StationInfo temStation;
    stationInfo.forEach((element) {
      if (element.stationName == name) {
        temStation = StationInfo(element.stationName, element.geoPoint,
            element.codeStation, element.codeLocation);
      }
    });
    return temStation;
  }

  /*--------------------------------------------------------------------*/

  Future<void> validateAndSave2() async {


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
                onPressed: () async{
                  List<Slice> sliceSupp = List();
                  Slice sliceExtra1;
                  Slice sliceExtra2;
                  Slice sliceFin;

                  Slice slice3;
                  sliceSupp.clear();
                  await cloud
                      .collection("Tronçon")
                      .getDocuments()
                      .then((QuerySnapshot snapshot) {
                    sliceL.clear();
                    snapshot.documents.forEach((element) {
                      if (element.documentID.startsWith(ddValueSup2)) {
                        slice3 = Slice(
                            element.documentID,
                            element.data['CodeStation1'],
                            element.data['CodeStation2'],
                            element.data['CodeLigne'],
                            element.data['Distance'],
                            element.data['Duree']);
                        sliceL.add(slice3);
                      }

                    });
                  });

                  sliceL.forEach((element) {
                    if (element.codeStation1 == ddValueSup3){
                      sliceSupp.add(element);
                    }
                    if(element.codeStation2 == ddValueSup3){
                      sliceFin=element;
                    }
                  });
                  sliceExtra1 = sliceSupp.first;
                  sliceExtra2 = sliceSupp.last;



                  Line tempLine = getLine(ddValueSup2);
                  StationInfo temStation = getStation(ddValueSup3);
                  if (temStation.stationName == tempLine.origin ||
                      temStation.stationName == tempLine.destination) {
                    if (temStation.stationName == tempLine.origin) {
                      String nvOrigine = sliceExtra1.codeStation2;
                      StationInfo nvStat = getStation(nvOrigine);
                      cloud.collection("Ligne").document(ddValueSup2).updateData({
                        "Origine": nvStat.stationName,
                      }).then((value) {
                        cloud.collection("Tronçon").document(sliceExtra1.codeSlice).delete();
                        cloud.collection("Tronçon").where(sliceExtra1.codeStation1,isEqualTo:"CodeStation2")
                            .getDocuments().then((value) {
                          value.documents.forEach((element) {
                            cloud.collection("Tronçon").document(element.documentID).delete();
                          });
                        });
                      });
                    } else {
                      String nvdestination = sliceFin.codeStation1;
                      StationInfo nvStat = getStation(nvdestination);
                      cloud.collection("Ligne").document(ddValueSup2).updateData({
                        "Destination": nvStat.stationName,
                      }).then((value) {
                        cloud.collection("Tronçon").document(sliceFin.codeSlice).delete();
                        cloud.collection("Tronçon").where(sliceFin.codeStation2,isEqualTo:"CodeStation1")
                            .getDocuments().then((value) {
                          value.documents.forEach((element) {
                            cloud.collection("Tronçon").document(element.documentID).delete();
                          });
                        });
                      });
                    }
                  } else {
                    sliceL.forEach((element) {
                      if(element.codeStation1==sliceExtra1.codeStation2 &&
                          element.codeStation2==sliceExtra1.codeStation1
                          ||
                          element.codeStation1 == sliceExtra2.codeStation2 &&
                              element.codeStation2==sliceExtra2.codeStation1){
                        cloud.collection("Tronçon").document(element.codeSlice).delete();

                      }
                    });
                    double disTot =
                        double.parse(sliceExtra1.distance) + double.parse(sliceExtra2.distance);
                    double durTot = double.parse(sliceExtra1.time) + double.parse(sliceExtra2.time);
                    Firestore.instance
                        .collection("Tronçon")
                        .document(sliceExtra1.codeSlice)
                        .updateData({
                      "CodeLigne": ddValueSup2,
                      "CodeStation1": sliceExtra1.codeStation2,
                      "CodeStation2": sliceExtra2.codeStation2,
                      "Distance": disTot.toString(),
                      "Duree": durTot.toString(),
                    });
                    Firestore.instance
                        .collection("Tronçon")
                        .document(sliceExtra2.codeSlice)
                        .updateData({
                      "CodeLigne": ddValueSup2,
                      "CodeStation1": sliceExtra2.codeStation2,
                      "CodeStation2": sliceExtra1.codeStation2,
                      "Distance": disTot.toString(),
                      "Duree": durTot.toString(),
                    });
                  }

                  cloud.collection("Station").document(ddValueSup3).delete();

                  showToast2();
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
              onPressed: () async{
                List<Slice> sliceSupp = List();
                Slice sliceExtra1;
                Slice sliceExtra2;
                Slice sliceFin;

                Slice slice3;
                sliceSupp.clear();
                await cloud
                    .collection("Tronçon")
                    .getDocuments()
                    .then((QuerySnapshot snapshot) {
                  sliceL.clear();
                  snapshot.documents.forEach((element) {
                    if (element.documentID.startsWith(ddValueSup2)) {
                      slice3 = Slice(
                          element.documentID,
                          element.data['CodeStation1'],
                          element.data['CodeStation2'],
                          element.data['CodeLigne'],
                          element.data['Distance'],
                          element.data['Duree']);
                      sliceL.add(slice3);
                    }

                  });
                });

                sliceL.forEach((element) {
                  if (element.codeStation1 == ddValueSup3){
                    sliceSupp.add(element);
                  }
                  if(element.codeStation2 == ddValueSup3){
                    sliceFin=element;
                  }
                });
                sliceExtra1 = sliceSupp.first;
                sliceExtra2 = sliceSupp.last;



                Line tempLine = getLine(ddValueSup2);
                StationInfo temStation = getStation(ddValueSup3);
                if (temStation.stationName == tempLine.origin ||
                    temStation.stationName == tempLine.destination) {
                  if (temStation.stationName == tempLine.origin) {
                    String nvOrigine = sliceExtra1.codeStation2;
                    StationInfo nvStat = getStation(nvOrigine);
                    cloud.collection("Ligne").document(ddValueSup2).updateData({
                      "Origine": nvStat.stationName,
                    }).then((value) {
                      cloud.collection("Tronçon").document(sliceExtra1.codeSlice).delete();
                      cloud.collection("Tronçon").where(sliceExtra1.codeStation1,isEqualTo:"CodeStation2")
                          .getDocuments().then((value) {
                        value.documents.forEach((element) {
                          cloud.collection("Tronçon").document(element.documentID).delete();
                        });
                      });
                    });
                  } else {
                    String nvdestination = sliceFin.codeStation1;
                    StationInfo nvStat = getStation(nvdestination);
                    cloud.collection("Ligne").document(ddValueSup2).updateData({
                      "Destination": nvStat.stationName,
                    }).then((value) {
                      cloud.collection("Tronçon").document(sliceFin.codeSlice).delete();
                      cloud.collection("Tronçon").where(sliceFin.codeStation2,isEqualTo:"CodeStation1")
                          .getDocuments().then((value) {
                        value.documents.forEach((element) {
                          cloud.collection("Tronçon").document(element.documentID).delete();
                        });
                      });
                    });
                  }
                } else {
                  sliceL.forEach((element) {
                    if(element.codeStation1==sliceExtra1.codeStation2 &&
                        element.codeStation2==sliceExtra1.codeStation1
                        ||
                        element.codeStation1 == sliceExtra2.codeStation2 &&
                            element.codeStation2==sliceExtra2.codeStation1){
                      cloud.collection("Tronçon").document(element.codeSlice).delete();

                    }
                  });
                  double disTot =
                      double.parse(sliceExtra1.distance) + double.parse(sliceExtra2.distance);
                  double durTot = double.parse(sliceExtra1.time) + double.parse(sliceExtra2.time);
                  Firestore.instance
                      .collection("Tronçon")
                      .document(sliceExtra1.codeSlice)
                      .updateData({
                    "CodeLigne": ddValueSup2,
                    "CodeStation1": sliceExtra1.codeStation2,
                    "CodeStation2": sliceExtra2.codeStation2,
                    "Distance": disTot.toString(),
                    "Duree": durTot.toString(),
                  });
                  Firestore.instance
                      .collection("Tronçon")
                      .document(sliceExtra2.codeSlice)
                      .updateData({
                    "CodeLigne": ddValueSup2,
                    "CodeStation1": sliceExtra2.codeStation2,
                    "CodeStation2": sliceExtra1.codeStation2,
                    "Distance": disTot.toString(),
                    "Duree": durTot.toString(),
                  });
                }

                cloud.collection("Station").document(ddValueSup3).delete();

                showToast2();

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








    /*******************************************************/
    /********************************************************/



  }

  void validateAndSave3() {
    if(localite){
      cloud.collection("Station").document(ddValueMod3).updateData({
        "CodeLocalite":ddValueMod4
      });
    }
    if(position){
      final FormState form = _formKey2.currentState;
      if(form.validate()){
        GeoPoint g = GeoPoint(double.parse(latitudeMod), double.parse(longitudeMod));
        cloud.collection("Station").document(ddValueMod3).updateData({
          "GeoPoint":g,
        });
      }

    }
    if(nom){
      final FormState form = _formKey3.currentState;
      if(form.validate()){
        Line l = getLine(ddValueMod2);
        StationInfo s = getStation(ddValueMod3);
        if(l.destination==s.stationName || l.origin==s.stationName){
          if(l.destination==s.stationName){
            cloud.collection("Ligne").document(ddValueMod2).updateData({
              "Destination":stationMod,
            });
          }else{
            cloud.collection("Ligne").document(ddValueMod2).updateData({
              "Origine":stationMod,
            });
          }

        }
        cloud.collection("Station").document(ddValueMod3).updateData({
          "NomStation":stationMod,
        });




      }
    }
 showToast("La Station est Modifie");

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: widget.color,
        appBar: AppBar(
          title: Hero(
            transitionOnUserGestures: true,
            tag: "station",
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                "Station",
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
            TabWidgets(
              icon: Icons.delete_forever,
              text: "Supprimer",
              color: Colors.white,
            ),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            //Add
            FutureBuilder(
              future: createTheList(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15.0, left: 4, right: 4),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:  EdgeInsets.only(top: 4.0,bottom: 4),
                              child: Text(
                                "La Wilaya",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Spartan5",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0,bottom: 4),
                              child: DropDownWidget(
                                function: (String newValue) async {
                                  setState(() {
                                    ddValue2 = "";
                                    ddValue4 = "";
                                    ddValueT1 = "";
                                    ddValueT2 = "";
                                    ddValue = newValue;
                                  });
                                  ddValue = newValue;
                                  list3 = await createTheList2(ddValue);
                                },
                                ddValue: ddValue,
                                ddColors: widget.color,
                                items: list2,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0,bottom: 4),
                              child: Text(
                                "La Ligne",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Spartan5",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0,bottom: 4),
                              child: DropDownWidget(
                                  function: (String newValue) async {
                                    ddValue2 = newValue;
                                    list4 = await createTheList4(ddValue);
                                    setState(() {
                                      ddValue2 = newValue;
                                    });
                                    tempLine = getLine(ddValue2);
                                  },
                                  ddValue: ddValue2,
                                  ddColors: widget.color,
                                  items: list3),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0,bottom: 4),
                              child: Text(
                                "La Localité",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Spartan5",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding:EdgeInsets.only(top: 4.0,bottom: 4),
                              child: DropDownWidget(
                                function: (String newValue) async {
                                  ddValue4 = newValue;
                                  list1 = await createTheList3(tempLine);
                                  setState(() {
                                    ddValue4 = newValue;
                                  });
                                },
                                ddValue: ddValue4,
                                ddColors: widget.color,
                                items: list4,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0, bottom: 14),
                              child: FormTextField(
                                abscur: false,
                                hint: "Écrire le Nom de Station",
                                validator: (value) {
                                  if (value.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "Ce case ne doit pas être vide";
                                  }
                                },
                                function: (value) {
                                  station = value;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0, bottom: 14),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                        latitude = value;
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
                                        longitude = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0, right: 8),
                                  child: Text(
                                    "Tronçon",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Spartan5",
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 14.0),
                              child: Text(
                                "Où se trouve cette nouvelle station ?",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Spartan5",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: Text(
                                "Entre",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Spartan5",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            DropDownWidget(
                              function: (String newValue) {
                                setState(() {
                                  ddValueT1 = newValue;
                                });
                                ddValueT1 = newValue;
                                tempStation1 = getStation(ddValueT1);
                                String valeur = stationInfo.last.codeStation; //Regele le codage
                                String miniVal= valeur.substring(10);
                                String val =(int.parse(miniVal)+1).toString();

                                int lenth = val.length;
                                String secondCount = lenth == 1
                                    ? val.padLeft(3, "0")
                                    : lenth == 2
                                    ? val.padLeft(3, "0")
                                    : val;

                                codStation = ddValue2 + "S" + secondCount;
                                StationInfo tempStat = StationInfo(
                                    station,
                                    GeoPoint(double.parse(latitude).toDouble(),
                                        double.parse(longitude).toDouble()),
                                    codStation,ddValue4);
                                stationInfo.add(tempStat);

                              },
                              ddValue: ddValueT1,
                              ddColors: widget.color,
                              items: list1,
                            ),
                            Builder(
                              builder: (BuildContext context) {
                                if(ddValueT1 == ""){
                                  return Text("");

                                }else{
                                  return RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(20.0),
                                    ),
                                    elevation: 8,
                                    color: Colors.white,
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => SingleChildScrollView(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: CreateTroncon(
                                              sDepart: ddValueT1,
                                              sArivee: codStation,
                                              stationInfo: stationInfo,
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
                                        'Créer Tronçon',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: widget.color,
                                            fontFamily: 'Spartan1'),
                                      ),
                                    ),
                                  );
                                }
                              },),

                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: Text(
                                "Et",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Spartan5",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            DropDownWidget(
                                function: (String newValue) {
                                    setState(() {
                                      ddValueT2 = newValue;
                                    });
                                    ddValueT2 = newValue;

                                  tempStation2 = getStation(ddValueT2);

                                },
                                ddValue: ddValueT2,
                                ddColors: widget.color,
                                items: list1),
                            Builder(
                              builder: (BuildContext context) {
                                if(ddValueT2 == ""){
                                  return Text("");

                                }else{
                                  return RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(20.0),
                                    ),
                                    elevation: 8,
                                    color: Colors.white,
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => SingleChildScrollView(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: CreateTroncon(
                                              color: widget.color,
                                              sDepart: codStation,
                                              sArivee: ddValueT2,
                                              stationInfo: stationInfo,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 8),
                                      child: Text(
                                        'Créer Tronçon',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: widget.color,
                                            fontFamily: 'Spartan1'),
                                      ),
                                    ),
                                  );
                                }
                              },),

                            Padding(
                              padding: EdgeInsets.only(top: 20.0, bottom: 15),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
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

            // modify
            FutureBuilder(
              future: createTheList(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                    child: SingleChildScrollView(
                      child: Column(
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
                            function: (String newValue) async {
                              setState(() {
                                ddValueMod1 = "";
                                ddValueMod2 = "";
                                ddValueMod3 = "";
                                ddValueMod1 = newValue;
                              });
                              ddValueMod1 = newValue;
                              list7 = await createTheList2(ddValueMod1);
                            },
                            ddValue: ddValueMod1,
                            ddColors: widget.color,
                            items: list2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "La Ligne",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Spartan5",
                                color: Colors.white,
                              ),
                            ),
                          ),
                          DropDownWidget(
                              function: (String newValue) async {
                                setState(() {
                                  ddValueMod2 = newValue;
                                });
                                ddValueMod2 = newValue;
                                tempLine3 = getLine(ddValueMod2);
                                list8 = await createTheList3(tempLine3);
                              },
                              ddValue: ddValueMod2,
                              ddColors: widget.color,
                              items: list7),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "Les Stations",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Spartan5",
                                color: Colors.white,
                              ),
                            ),
                          ),
                          DropDownWidget(
                            function: (String newValue) async {
                              setState(() {
                                ddValueMod3 = newValue;
                              });
                              ddValueMod3 = newValue;
                              list9 = await createTheList4(ddValueMod1);
                            },
                            ddValue: ddValueMod3,
                            ddColors: widget.color,
                            items: list8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0,bottom: 6),
                            child: Text(
                              "Que voulez-vous modifier?",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Spartan5",
                                color: Colors.white,
                              ),
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
                                      "Localité",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Spartan5",
                                        color: Colors.white,
                                      ),
                                    ),
                                    Checkbox(
                                        checkColor: widget.color,
                                        activeColor: Colors.white,
                                        value: localite,
                                        onChanged: (value) {
                                          setState(() {
                                            localite = value;
                                          });
                                        }),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Positionment",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Spartan5",
                                        color: Colors.white,
                                      ),
                                    ),
                                    Checkbox(

                                        checkColor: widget.color,
                                        activeColor: Colors.white,
                                        value: position,
                                        onChanged: (value) {
                                          setState(() {
                                            position = value;
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
                            if(localite){
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      "La Localité",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Spartan5",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DropDownWidget(
                                    function: (String newValue) async {
                                      ddValueMod4 = newValue;
                                      setState(() {
                                        ddValueMod4 = newValue;
                                      });
                                    },
                                    ddValue: ddValueMod4,
                                    ddColors: widget.color,
                                    items: list9,
                                  ),
                                ],
                              ) ;
                            }else{
                              return Text("");
                            }
                          },),
                          Builder(builder: (BuildContext context) {
                            if(position){
                              return Form(
                                key: _formKey2,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
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
                                            latitudeMod = value;
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
                                            longitudeMod = value;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ) ;
                            }else{
                              return Text("");
                            }
                          },),
                          Builder(builder: (BuildContext context) {
                            if(nom){
                              return Form(
                                key:_formKey3 ,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 4.0, bottom: 14),
                                  child: FormTextField(
                                    abscur: false,
                                    hint: "Écrire le Nom de Station",
                                    validator: (value) {
                                      if (value.isNotEmpty) {
                                        return null;
                                      } else {
                                        return "Ce case ne doit pas être vide";
                                      }
                                    },
                                    function: (value) {
                                      stationMod = value;
                                    },
                                  ),
                                ),
                              ) ;
                            }else{
                              return Text("");
                            }
                          },),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
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
                              onPressed: validateAndSave3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),

            FutureBuilder(
              future: createTheList(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                    child: SingleChildScrollView(
                      child: Column(
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
                            function: (String newValue) async {
                              setState(() {
                                ddValueSup1 = "";
                                ddValueSup2 = "";
                                ddValueSup3 = "";
                                ddValueSup1 = newValue;
                              });
                              ddValueSup1 = newValue;
                              list5 = await createTheList2(ddValueSup1);
                            },
                            ddValue: ddValueSup1,
                            ddColors: widget.color,
                            items: list2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "La Ligne",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Spartan5",
                                color: Colors.white,
                              ),
                            ),
                          ),
                          DropDownWidget(
                              function: (String newValue) async {
                                setState(() {
                                  ddValueSup2 = newValue;
                                });
                                ddValueSup2 = newValue;
                                tempLine2 = getLine(ddValueSup2);
                                list6 = await createTheList3(tempLine2);
                              },
                              ddValue: ddValueSup2,
                              ddColors: widget.color,
                              items: list5),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "Les Stations",
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
                                ddValueSup3 = newValue;
                              });
                              ddValueSup3 = newValue;
                            },
                            ddValue: ddValueSup3,
                            ddColors: widget.color,
                            items: list6,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
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
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

/*-------------------------BottomSheet Class-----------------------*/
/*-----------------------------------------------------------------*/
class CreateTroncon extends StatefulWidget {
  final String sDepart;
  final String sArivee;
  final List<StationInfo> stationInfo;
  final Color color;

  const CreateTroncon(
      {this.sDepart, this.sArivee, this.stationInfo, this.color});

  @override
  _CreateTronconState createState() => _CreateTronconState();
}

class _CreateTronconState extends State<CreateTroncon> {
  String distance;
  String duree;
  Firestore cloud = Firestore.instance;
  List<Slice> sliceList = List();
  final GlobalKey<FormState> _formKeybottom = GlobalKey<FormState>();
  String codeLigne;

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

  void showToast() {
    Fluttertoast.showToast(
      msg: "Le Tronçon est Ajouté Correctement",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: widget.color,
      fontSize: 16.0,
    );
  }

  String getStationName(String code) {
    String name = "";
    if(code!=""){widget.stationInfo.forEach((element) {
      if (element.codeStation == code) {
        name = element.stationName;
      }
    });}

    return name;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.sDepart != ""){
      codeLigne = widget.sDepart.substring(0, 9);
      createList(widget.sDepart.substring(0, 9));
    }
  }

  void validateAndSave() async {
    final FormState form = _formKeybottom.currentState;
    if (form.validate()) {
      String valeur = sliceList.last.codeSlice; //Regele le codage
      String miniVal = valeur.substring(10);
      String val = (int.parse(miniVal) + 1).toString();
      int lenth = val.length;
      String secondCount = lenth == 1
          ? val.padLeft(3, "0")
          : lenth == 2 ? val.padLeft(3, "0") : val;
      Firestore.instance
          .collection("Tronçon")
          .document(codeLigne + 'T' + secondCount)
          .setData({
        "CodeLigne": codeLigne,
        "CodeStation1": widget.sDepart,
        "CodeStation2": widget.sArivee,
        "Distance": distance.toString(),
        "Duree": duree.toString(),
      });
        String valeur2 = sliceList.last.codeSlice; //Regele le codage
        String miniVal2 = valeur2.substring(10);
        String val2 = (int.parse(miniVal2) + 2).toString();
        int secondlenth = val2.length;
        String countnew = secondlenth == 1
            ? val2.padLeft(3, "0")
            : secondlenth == 2 ? val2.padLeft(3, "0") : val2;
        Firestore.instance
            .collection("Tronçon")
            .document(codeLigne + 'T' + countnew)
            .setData({
          "CodeLigne": codeLigne,
          "CodeStation1": widget.sArivee,
          "CodeStation2": widget.sDepart,
          "Distance": distance.toString(),
          "Duree": duree.toString(),
        });



      showToast();
      Navigator.pop(context);
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      color: Color(0xff140042),
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        child: Form(
          key: _formKeybottom,
          child: Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 1, left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, top: 8),
                  child: Text(
                    getStationName(widget.sDepart) +
                        ' - ' +
                        getStationName(widget.sArivee),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Spartan5",
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0, bottom: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: FormTextField(
                          abscur: false,
                          hint: "Distance",
                          validator: (value) {
                            if (value.isNotEmpty) {
                              return null;
                            } else {
                              return "Ce case ne doit pas être vide";
                            }
                          },
                          function: (value) {
                            setState(() {
                              distance = value;
                            });
                            distance = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: FormTextField(
                          abscur: false,
                          hint: "Durée",
                          validator: (value) {
                            if (value.isNotEmpty) {
                              return null;
                            } else {
                              return "Ce case ne doit pas être vide";
                            }
                          },
                          function: (value) {
                            setState(() {
                              duree = value;
                            });
                            duree = value;
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
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
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
  }
}
