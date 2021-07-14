import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:transportapp/Controller/PathsAlgorithm.dart';
import 'package:transportapp/Model/City.dart';
import 'package:transportapp/Model/Constant.dart';
import 'package:transportapp/Model/Line.dart';
import 'package:transportapp/Model/Location.dart';
import 'package:transportapp/Model/StationInfo.dart';
import 'package:transportapp/View/ConfigurationScreen.dart';

import 'Widgets/DropDownWidget.dart';
import 'Widgets/TabWidget.dart';

class DataScreen extends StatefulWidget {
  final Color color;
  final bool isUser;

  const DataScreen({this.color, this.isUser});

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  Firestore cloud = Firestore.instance;
  String ddValue = "";
  String ddValue2 = "";
  String ddValue3 = "";
  String ddValue4 = "";
  String detail = "Plus de Détails";
  bool show = false;
  bool show2 = false;
  bool isLine = false;
  Line tempLine;
  City tempCity;
  bool isMetro = false;
  List<City> city = List();
  List<Line> line = List();
  List<StationInfo> station = List();
  List<StationInfo> metroStation = List();
  List<Location> location = List();
  List<DropdownMenuItem<String>> list2 = List();
  List<DropdownMenuItem<String>> list3 = List();
  PathsAlgorithm p = PathsAlgorithm();
  bool isTransport = false;
  bool isWilaya = false;

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

  Future<List<DropdownMenuItem<String>>> createTheList2(String value) async {
    line.clear();
    await cloud
        .collection("Ligne")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        print(value);
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
    print(line);

    List<DropdownMenuItem<String>> list = List();
    list.add(DropdownMenuItem(
      child: Text("Aucune"),
      value: "",
    ));
    line.forEach((element) {
      print(element.codeLine);
      list.add(DropdownMenuItem(
          child: Text(
            element.origin + "-" + element.destination,
          ),
          value: element.codeLine));
    });
    return list;
  }

  Future<void> getLocationList(String code) async {
    await cloud
        .collection("Localité")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        if (element.documentID.contains(code)) {
          location.add(Location(element.documentID, element.data["NomLocalite"],
              element.data["CodeWilaya"]));
        }
      });
    });
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

  City getWilaya(String code) {
    City tempCity;
    city.forEach((element) {
      if (element.codeState == code) {
        tempCity = City(element.codeState, element.stateName,
            element.codeState.substring(1));
      }
    });
    return tempCity;
  }

  void initList() async {
    list2.addAll(await createTheList());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    p.initData();
    initList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: widget.color,
        appBar: AppBar(
          backgroundColor: widget.color,
          title: Hero(
            tag: "data",
            transitionOnUserGestures: true,
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                "Les Données",
                style: Constant.kStyle10,
              ),
            ),
          ),
          bottom: TabBar(indicatorColor: widget.color, tabs: <Widget>[
            TabWidgets(
              icon: Icons.calendar_view_day,
              text: "Lignes",
              color: Colors.white,
            ),
            TabWidgets(
              icon: Icons.flag,
              text: "Wilayas",
              color: Colors.white,
            ),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            FutureBuilder(
              future: createTheList(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropDownWidget(
                              function: (String newValue) async {
                                setState(() {
                                  ddValue2 = "";
                                  ddValue = newValue;
                                });
                                ddValue = newValue;
                              },
                              ddValue: ddValue,
                              ddColors: widget.color,
                              items: list2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Sélectionner Le Moyen de Transport",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Spartan5",
                                color: Colors.white,
                              ),
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
                                  list3 = await createTheList2(
                                      "$ddValue$ddValue4");
                                },
                                ddValue: ddValue4,
                                ddColors: widget.color,
                                items: [
                                  DropdownMenuItem(
                                    child: Text("Aucune"),
                                    value: "",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Bus"),
                                    value: "LBS",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Tramway"),
                                    value: "LTY",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Métro"),
                                    value: "LMO",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Train"),
                                    value: "LTN",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Taxi"),
                                    value: "LTX",
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 15,
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropDownWidget(
                                function: (String newValue) async {
                                  ddValue2 = newValue;
                                  setState(() {
                                    ddValue2 = newValue;
                                    station.clear();
                                    tempLine = getLine(ddValue2);
                                    station = p.getLinesStationList(tempLine,
                                        tempLine.origin, tempLine.destination);
                                    if (tempLine.codeLine == "W16LMO001") {
                                      isMetro = true;
                                      metroStation = p.getLinesStationList(
                                          tempLine,
                                          tempLine.origin,
                                          "Ain Naadja");
                                    } else {
                                      isMetro = false;
                                    }
                                  });
                                },
                                ddValue: ddValue2,
                                ddColors: widget.color,
                                items: list3),
                          ),
                          Builder(
                            builder: (BuildContext context) {
                              if (isLine) {
                                return Column(
                                  children: <Widget>[],
                                );
                              } else {
                                return Text("");
                              }
                            },
                          ),
                          Builder(
                            builder: (BuildContext context) {
                              if (ddValue2 != "") {
                                return Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 10,
                                        ),
                                      ],
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              "Origine: ${tempLine.origin}",
                                              style: Constant.kStyle12,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              "Destination: ${tempLine.destination}",
                                              style: Constant.kStyle12,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              "N° Ligne: ${tempLine.codeLine.substring(6)}",
                                              style: Constant.kStyle12,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              "Type De Transport: ${tempLine.codeTransport}",
                                              style: Constant.kStyle12,
                                            ),
                                          ),
                                          Builder(
                                            builder: (BuildContext context) {
                                              if (show == false) {
                                                return Text("");
                                              } else {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4.0),
                                                      child: Text(
                                                        "Les Stations : ",
                                                        style: Constant.kStyle12
                                                            .copyWith(
                                                                fontSize: 18),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Flexible(
                                                          fit: FlexFit.loose,
                                                          child: Container(
                                                            height: 150,
                                                            child: ListView
                                                                .builder(
                                                              shrinkWrap: true,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: 2.0,
                                                                      bottom:
                                                                          2.0),
                                                                  child: Text(
                                                                    "${station[index].stationName}",
                                                                    style: Constant
                                                                        .kStyle12,
                                                                  ),
                                                                );
                                                              },
                                                              itemCount: station
                                                                  .length,
                                                            ),
                                                          ),
                                                        ),
                                                        Builder(
                                                          builder: (BuildContext
                                                              context) {
                                                            if (isMetro ==
                                                                true) {
                                                              return Flexible(
                                                                fit: FlexFit
                                                                    .loose,
                                                                child:
                                                                    Container(
                                                                  height: 150,
                                                                  child: ListView
                                                                      .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                2.0,
                                                                            bottom:
                                                                                2.0),
                                                                        child:
                                                                            Text(
                                                                          "${metroStation[index].stationName}",
                                                                          style:
                                                                              Constant.kStyle12,
                                                                        ),
                                                                      );
                                                                    },
                                                                    itemCount:
                                                                        metroStation
                                                                            .length,
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              return Text("");
                                                            }
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: RichText(
                                                text: TextSpan(
                                                    text: "$detail",
                                                    style: TextStyle(
                                                      fontFamily: 'Spartan1',
                                                      color: Colors.blue,
                                                      fontSize: 13,
                                                    ),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            setState(() {
                                                              if (show ==
                                                                  false) {
                                                                show = true;
                                                                detail =
                                                                    "Moins de Details";
                                                              } else {
                                                                show = false;
                                                                detail =
                                                                    "Plus de Details";
                                                              }
                                                            });
                                                          }),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Text("");
                              }
                            },
                          ),
                          Builder(
                            builder: (BuildContext context) {
                              if (widget.isUser == true) {
                                return Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: RichText(
                                      text: TextSpan(
                                          text:
                                              "Voulez-vous mettre à jour les données?",
                                          style: TextStyle(
                                            fontFamily: 'Spartan5',
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    "\nLa Gestion des Données.",
                                                style: TextStyle(
                                                  fontFamily: 'Spartan1',
                                                  color: Colors.blue,
                                                  fontSize: 14,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ConfigurationScreen(
                                                              color:
                                                                  widget.color,
                                                            ),
                                                          ),
                                                        );
                                                      })
                                          ]),
                                    ),
                                  ),
                                );
                              } else {
                                return Text("");
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                }
              },
            ),
            FutureBuilder(
              future: createTheList(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 4.0),
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
                                ddValue3 = newValue;
                                location.clear();
                                getLocationList(ddValue3);
                                tempCity = getWilaya(ddValue3);
                              });
                              ddValue3 = newValue;
                            },
                            ddValue: ddValue3,
                            ddColors: widget.color,
                            items: list2,
                          ),
                          Builder(
                            builder: (BuildContext context) {
                              if (ddValue3 != "") {
                                return Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 10,
                                        ),
                                      ],
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              "Nom Wilaya: ${tempCity.stateName}",
                                              style: Constant.kStyle12,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              "N° de Wilaya: ${tempCity.stateNumber}",
                                              style: Constant.kStyle12,
                                            ),
                                          ),
                                          Builder(
                                            builder: (BuildContext context) {
                                              if (show2 == false) {
                                                return Text("");
                                              } else {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4.0),
                                                      child: Text(
                                                        "Les Localités : ",
                                                        style: Constant.kStyle12
                                                            .copyWith(
                                                                fontSize: 18),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Flexible(
                                                          fit: FlexFit.loose,
                                                          child: Container(
                                                            height: 150,
                                                            child: ListView
                                                                .builder(
                                                              shrinkWrap: true,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: 2.0,
                                                                      bottom:
                                                                          2.0),
                                                                  child: Text(
                                                                    "${location[index].locationName}",
                                                                    style: Constant
                                                                        .kStyle12,
                                                                  ),
                                                                );
                                                              },
                                                              itemCount:
                                                                  location
                                                                      .length,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: RichText(
                                                text: TextSpan(
                                                    text: "$detail",
                                                    style: TextStyle(
                                                      fontFamily: 'Spartan1',
                                                      color: Colors.blue,
                                                      fontSize: 13,
                                                    ),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            setState(() {
                                                              if (show2 ==
                                                                  false) {
                                                                show2 = true;
                                                                detail =
                                                                    "Moins de Details";
                                                              } else {
                                                                show2 = false;
                                                                detail =
                                                                    "Plus de Details";
                                                              }
                                                            });
                                                          }),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Text("");
                              }
                            },
                          ),
                          Builder(
                            builder: (BuildContext context) {
                              if (widget.isUser == true) {
                                return Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: RichText(
                                      text: TextSpan(
                                          text:
                                              "Voulez-vous mettre à jour les données?",
                                          style: TextStyle(
                                            fontFamily: 'Spartan5',
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    "\nLa Gestion des Données.",
                                                style: TextStyle(
                                                  fontFamily: 'Spartan1',
                                                  color: Colors.blue,
                                                  fontSize: 14,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ConfigurationScreen(
                                                              color:
                                                                  widget.color,
                                                            ),
                                                          ),
                                                        );
                                                      })
                                          ]),
                                    ),
                                  ),
                                );
                              } else {
                                return Text("");
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
