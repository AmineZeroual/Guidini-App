import 'package:transportapp/Model/StationInfo.dart';

class PathsInfo{
  String codePath="";
  double totalPrice=0.0;
  List<StationInfo> lesStation = List();
  double distance=0;
  double time=0;
  List<String> lineList=List();

  @override
  String toString() {
    return 'PathsInfo{lesStation: $lesStation}';
  }



}