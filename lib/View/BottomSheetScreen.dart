
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportapp/Controller/PathsAlgorithm.dart';
import 'package:transportapp/Model/Constant.dart';
import 'package:transportapp/Model/PathsInfo.dart';
import 'package:transportapp/View/ChoicesScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportapp/Model/StationInfo.dart';
import 'package:transportapp/View/SearchBar.dart';

final cloud = Firestore.instance;

class BottomSheetScreen extends StatefulWidget {
  final Color color;
  final StationInfo stat;
  final bool isLocated ;

  const BottomSheetScreen({this.color, this.stat, this.isLocated});

  @override
  _BottomSheetScreenState createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends State<BottomSheetScreen> {
  var textResult1 = TextEditingController();
  var textResult2 = TextEditingController();
  StationInfo textR1;
  StationInfo textR2;
  PathsAlgorithm paths = PathsAlgorithm();
  List<String> startList = List();
  List<String> finishList = List();

  @override
  void initState() {
    paths.initData();
    if(widget.isLocated){
  textResult1.text=widget.stat.stationName;
  textR1 = widget.stat;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Color(0xff5f6e5f),
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: textResult1,
                onTap: () {
                  setState(() async {

                      textR1 = await showSearch(
                        context: context,
                        delegate: SearchBar(color: widget.color),
                      );

                    textResult1.text = textR1.stationName;

                  });
                },
                style: Constant.kStyle1,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  hintText: "Point de Départ",
                  hintStyle: Constant.kStyle1,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: textResult2,
                onTap: () {
                  setState(() async {
                    textR2 = await showSearch(
                      context: context,
                      delegate: SearchBar(color:widget.color),
                    );
                    textResult2.text = textR2.stationName;
                  });
                },
                style: Constant.kStyle1,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  hintText: "Point de D'arrivée",
                  hintStyle: Constant.kStyle1,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              FlatButton(
                color: Colors.white,
                shape: StadiumBorder(),
                padding:
                    EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
                child: Text(
                  "Rechercher",
                  style:Constant.kStyle12,
                ),
                onPressed: () async {
                  startList.clear();
                  finishList.clear();
                  List<PathsInfo> allPaths2 = List();
                  paths.ourGraph.forEach((element) {
                    if (element.val.stationName.contains(textR1.stationName)) {
                      startList.add(element.val.codeStation);
                    }
                    if (element.val.stationName.contains(textR2.stationName)) {
                      finishList.add(element.val.codeStation);
                    }
                  });

                  for (String i in startList) {
                    for (String j in finishList) {
                      allPaths2.addAll(paths.createAllPaths(i, j));
                    }
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FutureBuilder(
                                future: paths.setPrice(allPaths2),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasData) {
                                    return ChoicesScreen(
                                      color: widget.color, allPaths: allPaths2);
                                  } else {
                                    return Scaffold(
                                      body: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Création des Trajectoires",
                                              style: Constant.kStyle6,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      widget.color),
                                            ),
                                          ],
                                        ),
                                      ),
                                      backgroundColor: Colors.white,
                                    );
                                  }
                                },
                              )));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
