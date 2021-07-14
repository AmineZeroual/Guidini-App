import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class StationInfo {
  String stationName;
  String codeLocation;
  String codeStation;
  GeoPoint geoPoint;
  IconData iconData;
  Color iconColor;
  String code;


  StationInfo(this.stationName, this.geoPoint, this.codeStation,this.codeLocation);

  @override
  String toString() {
    return 'StationInfo{stationName: $codeStation}';
  }

}
