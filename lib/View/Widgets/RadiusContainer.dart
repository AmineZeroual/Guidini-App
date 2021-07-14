import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportapp/Model/Constant.dart';
import 'package:transportapp/Model/PathsInfo.dart';
import 'package:transportapp/View/MainAppScreen.dart';

class RadiusContainer extends StatelessWidget {
  final PathsInfo path;
  final Color color;


  RadiusContainer({this.path, this.color});
  static int idNumber = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      child: Container(
          width: 310,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 10,
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Trajectoire",
                  style:Constant.kStyle6,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(children: <Widget>[
                  Icon(
                    path.lesStation.first.iconData,
                    color: path.lesStation.first.iconColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    path.lesStation.first.stationName,
                    style:Constant. kStyle12,
                  ),
                ]),
                Icon(
                  Icons.more_vert,
                  color: color,
                ),
                Row(children: <Widget>[
                  Icon(
                    path.lesStation.last.iconData,
                    color:path.lesStation.last.iconColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    path.lesStation.last.stationName,
                    style: Constant.kStyle12,
                  ),
                ]),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Détail",
                  style: Constant.kStyle6,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Distance: " + path.distance.toStringAsFixed(2) + " Km",
                  style: Constant.kStyle2,
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  "Durée: " + path.time.toString() + " Min",
                  style: Constant.kStyle2,
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    width: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 10,
                        ),
                      ],
                      color: color,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Les Stations",
                              style: Constant.kStyle7,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(top:2.0,bottom: 2.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        path.lesStation[index].iconData,
                                        color: path.lesStation[index].iconColor
                                      ),
                                      Text(
                                        path.lesStation[index].stationName,
                                        style: Constant.kStyle8,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: path.lesStation.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Prix:"+path.totalPrice.toString()+"Da",
                      style: Constant.kStyle6,
                    ),
                    FlatButton(
                      color: color,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 12,
                        bottom: 12,
                      ),
                      child: Text("Démarrer", style: Constant.kStyle1),
                      onPressed: () async {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MainAppScreen(path:path,color:color,),
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
