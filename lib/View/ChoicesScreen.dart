
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transportapp/Model/Constant.dart';
import 'package:transportapp/Model/PathsInfo.dart';
import 'package:transportapp/View/Widgets/RadiusContainer.dart';
import 'package:transportapp/View/Widgets/TransportFiletringWidget.dart';

class ChoicesScreen extends StatefulWidget {
  final List<PathsInfo> allPaths;
  final Color color;

  ChoicesScreen({@required this.allPaths, this.color});

  @override
  _ChoicesScreenState createState() => _ChoicesScreenState();
}

class _ChoicesScreenState extends State<ChoicesScreen> {
  List<PathsInfo> allPaths2 = List();
  bool choice1 = false,
      choice2 = false,
      choice3 = false,
      choice4 = false,
      choice5 = false,
      choice7 = false,
      choice6 = false;

  void showToast() {
    Fluttertoast.showToast(
        msg: "Il n'y a pas de chemin pour ce transport",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[350],
        textColor: widget.color,
        fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: widget.color,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 8.0, top: 12, bottom: 16),
              child: Text(
                "Tous Les Chemins Possibles",
                style: Constant.kStyle5,
              ),
            ),
            Expanded(
              flex: 1,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  TransportFilteringWidget(
                    iconColor: Color(0xff4db6ac),
                    icon: Icons.tram,
                    transportName: "Tramway",
                    color: choice1 ? Colors.white70 : Colors.white,
                    function: () {
                      setState(() {
                        choice1 = !choice1;
                        choice2 = false;
                        choice3 = false;
                        choice4 = false;
                        choice5 = false;
                        choice6 = false;
                        choice7=false;
                        if (choice1 == true) {
                          allPaths2.clear();
                          widget.allPaths.forEach((element) {
                            if (element.lesStation.first.iconData ==
                                Icons.tram) {
                              allPaths2.add(element);
                            }
                          });
                          if (allPaths2.isEmpty) showToast();
                        } else {
                          allPaths2.clear();
                        }
                      });
                    },
                  ),
                  InkWell(
                    child: TransportFilteringWidget(
                      iconColor: Color(0xffe57373),
                      icon: Icons.directions_bus,
                      transportName: "Bus",
                      color: choice2 ? Colors.white70 : Colors.white,
                      function: () {
                        setState(() {
                          choice1 = false;
                          choice2 = !choice2;
                          choice3 = false;
                          choice7=false;
                          choice4 = false;
                          choice5 = false;
                          choice6 = false;
                          if (choice2 == true) {
                            allPaths2.clear();
                            widget.allPaths.forEach((element) {
                              if (element.lesStation.first.iconData ==
                                  Icons.directions_bus) {
                                allPaths2.add(element);
                              }
                            });
                            if (allPaths2.isEmpty) showToast();
                          } else {
                            allPaths2.clear();
                          }
                        });
                      },
                    ),
                  ),
                  InkWell(
                    child: TransportFilteringWidget(
                      iconColor:Color(0xfffff176),
                      icon: Icons.local_taxi,
                      transportName: "Taxi",
                      color: choice7 ? Colors.white70 : Colors.white,
                      function: () {
                        setState(() {
                          choice1 = false;
                          choice2 = false;
                          choice3 = false;
                          choice4 = false;
                          choice5 = false;
                          choice6 = false;
                          choice7=!choice7;
                          if (choice7 == true) {
                            allPaths2.clear();
                            widget.allPaths.forEach((element) {
                              if (element.lesStation.first.iconData ==
                                  Icons.local_taxi) {
                                allPaths2.add(element);
                              }
                            });
                            if (allPaths2.isEmpty) showToast();
                          } else {
                            allPaths2.clear();
                          }
                        });
                      },
                    ),
                  ),
                  InkWell(
                    child: TransportFilteringWidget(
                      iconColor: Color(0xff64b5f6),
                      icon: Icons.directions_subway,
                      transportName: "Métro",

                      function: () {
                        setState(() {
                          choice1 = false;
                          choice2 = false;
                          choice3 = !choice3;
                          choice4 = false;
                          choice5 = false;
                          choice6 = false;
                          choice7=false;
                          if (choice3 == true) {
                            allPaths2.clear();
                            widget.allPaths.forEach((element) {
                              if (element.lesStation.first.iconData ==
                                  Icons.directions_subway) {
                                allPaths2.add(element);
                              }
                            });
                            if (allPaths2.isEmpty) showToast();
                          } else {
                            allPaths2.clear();
                          }
                        });
                      },
                      color: choice3 ? Colors.white70 : Colors.white,
                    ),
                  ),

                  InkWell(
                    child: TransportFilteringWidget(
                      iconColor:Color(0xffffb74d),
                      icon: Icons.directions_railway,
                      transportName: "Train",
                      color: choice4 ? Colors.white70 : Colors.white,
                      function: () {
                        setState(() {
                          choice1 = false;
                          choice2 = false;
                          choice3 = false;
                          choice4 = !choice4;
                          choice5 = false;
                          choice7=false;
                          choice6 = false;
                          if (choice4 == true) {
                            allPaths2.clear();
                            widget.allPaths.forEach((element) {
                              if (element.lesStation.first.iconData ==
                                  Icons.subway) {
                                allPaths2.add(element);
                              }
                            });
                            if (allPaths2.isEmpty) showToast();
                          } else {
                            allPaths2.clear();
                          }
                        });
                      },
                    ),
                  ),
                  InkWell(
                    child: TransportFilteringWidget(
                      iconColor: Colors.pinkAccent,
                      icon: Icons.monetization_on,
                      transportName: "Moins Cher",
                      color: choice5 ? Colors.white70 : Colors.white,
                      function: () {
                        setState(() {
                          choice1 = false;
                          choice2 = false;
                          choice3 = false;
                          choice4 = false;
                          choice7 = false;
                          choice5 = !choice5;
                          choice6 = false;
                          if(choice5 == true){
                            allPaths2.clear();
                            widget.allPaths.sort((a, b) => a.totalPrice.compareTo(b.totalPrice));
                            allPaths2.add(widget.allPaths.first);
                          }else
                            allPaths2.clear();
                        });
                      },
                    ),
                  ),
                  InkWell(
                    child: TransportFilteringWidget(
                      iconColor:Colors.purpleAccent,
                      icon: Icons.timer,
                      transportName: "Chemin Rapide",
                      color: choice6 ? Colors.white70 : Colors.white,
                      function: () {
                        setState(() {
                          choice1 = false;
                          choice2 = false;
                          choice7=false;
                          choice3 = false;
                          choice4 = false;
                          choice5 = false;
                          choice6 = !choice6;
                          if(choice6 == true){
                            allPaths2.clear();
                            widget.allPaths.sort((a, b) => a.time.compareTo(b.time));
                            allPaths2.add(widget.allPaths.first);
                          }else
                            allPaths2.clear();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 7,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return RadiusContainer(
                    color :widget.color,
                      path: allPaths2.isEmpty
                          ? widget.allPaths[index]
                          : allPaths2[index]);
                },
                itemCount: allPaths2.isEmpty
                    ? widget.allPaths.length
                    : allPaths2.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
