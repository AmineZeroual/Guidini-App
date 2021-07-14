
import 'package:transportapp/Controller/Graphes.dart';
import 'package:transportapp/Model/Line.dart';
import 'package:transportapp/Model/PathsInfo.dart';
import 'package:transportapp/Model/Slice.dart';
import 'package:transportapp/Model/StationInfo.dart';

class PathsAlgorithm{
  List<PathsInfo> allPaths2 = List() ;
  Graphes graphes ;
  List<Node> ourGraph;
  List<bool> isVisited = List();
  PathsInfo pathsInfo = PathsInfo();
  double price;
  String oldCode="";
  List<String> lineList1=List();
  List<String> lineList2=List();
String firstPoint;
  PathsAlgorithm();

  Future<void> initData() async {
    graphes = Graphes();
    ourGraph = await graphes.createGraph();
    graphes.createIconsForStations();
  }

  //Function One
  List<PathsInfo> createAllPaths(String startPoint,String finishPoint){
    allPaths2.clear();
    lineList1.clear();
    firstPoint=startPoint.substring(0,9);
    isVisited = List(ourGraph.length+1);
    for(int i =0;i<=ourGraph.length;i++){
      isVisited[i] = false;
    }
    PathsInfo pathsInfo = PathsInfo();
    pathsInfo.lesStation.add(getStationByCode(startPoint));
    getAllPaths(startPoint,finishPoint,pathsInfo,isVisited);

    return allPaths2;
  }

 //Function two
 void getAllPaths(String startPoint,String finishPoint,PathsInfo pathsInfo,List<bool> isVisited) async {

   isVisited[ourGraph.indexOf(getNodeByCode(startPoint))+1] = true;
   print(startPoint);
   print(finishPoint);
   print("---------------");
   if(startPoint == finishPoint){
     String code;
     PathsInfo p = PathsInfo();
     p.lesStation = List.from(pathsInfo.lesStation);
     oldCode=p.lesStation[1].codeStation.substring(0,9);
     lineList1.add(oldCode);
     for(int i = 1 ; i<p.lesStation.length-1;i++){
       code=p.lesStation[i].codeStation.substring(0,9);
       print(code);
       if(code!="000000000" && oldCode!=code){
         oldCode=code;
         lineList1.add(oldCode);
       }
     }

     int cpt = 0;
     bool isOne = false;
     lineList1.forEach((element) {
       cpt=0;
       for(int i = 0 ; i<p.lesStation.length;i++){
       if(p.lesStation[i].codeStation.substring(0,9)==element){
         cpt = cpt+1;
       }
       }
       print(cpt);
       if(cpt==1){
         isOne = true;
       }
     });


     p.distance=pathsInfo.distance;
     p.time=pathsInfo.time;
     p.totalPrice=pathsInfo.totalPrice;
     p.lineList=List.from(lineList1);
     if(isOne == false){
       allPaths2.add(p);
     }

     lineList1.clear();
     lineList1.add(firstPoint);
     isVisited[ourGraph.indexOf(getNodeByCode(startPoint))+1] = false;
     return;
   }

   for(Node n in ourGraph){
     if(n.val.codeStation==startPoint) {
       for (Slice s in n.sliceList) {
         if (!isVisited[ourGraph.indexOf(getNodeByCode(s.codeStation2)) + 1]) {

           StationInfo stationInfo=getStationByCode(s.codeStation2);

           pathsInfo.lesStation.add(stationInfo);
           var temp = double.parse(s.distance).toDouble();
           var temp2 = double.parse(s.time).toDouble();
           pathsInfo.distance += temp;
           pathsInfo.time += temp2;
           getAllPaths(stationInfo.codeStation,finishPoint,pathsInfo,isVisited);
           pathsInfo.lesStation.remove(stationInfo);
           pathsInfo.distance -= temp;
           pathsInfo.time -= temp2;




         }

       }
     }

   }

   isVisited[ourGraph.indexOf(getNodeByCode(startPoint))+1]=false;

}


Future<double> setPrice(List p)async{
    double price;
    int i = 0;

 for(PathsInfo pd in p){
   print(pd.lineList);
   i=0;
   while(i<pd.lineList.length) {

     if (pd.lineList.length > 1 && i + 1 < pd.lineList.length) {

       if (pd.lineList.elementAt(i) == 'W16LMO001' &&
           pd.lineList.elementAt(i + 1) == 'W16LTY001'
           ||
           pd.lineList.elementAt(i) == 'W16LTY001' &&
               pd.lineList.elementAt(i + 1) == 'W16LMO001'
              ) {
         i = i + 2;
         price = 70.0;
         pd.totalPrice += price;
       }
     }

     if(i<pd.lineList.length) {
       price = await Line.getPrice(pd.lineList[i]);
       pd.totalPrice += price;
       i++;
     }

   }

 }


    return price;
}


 StationInfo getStationByName(String name){
    StationInfo station;
    for(Node e in ourGraph){
      if(name == e.val.stationName)
        station = e.val;
    }
    return station;
  }

  StationInfo getStationByCode(String code){
    StationInfo station;
    for(Node e in ourGraph){
      if(code == e.val.codeStation)
        station = e.val;
    }
    return station;
  }

  StationInfo getStation(String name,String code) {
    StationInfo temStation;
    ourGraph.forEach((element) {
      if (element.val.stationName == name && element.val.codeStation.contains(code)) {
        print(element.val.stationName);
        temStation = StationInfo(
            element.val.stationName, element.val.geoPoint, element.val.codeStation,element.val.codeLocation);
      }
    });

    return temStation;
  }

  List<StationInfo> getLinesStationList(Line p,String origin,String destination){
    StationInfo s2 = getStation(destination,p.codeLine);
    StationInfo s1 = getStation(origin,p.codeLine);



    List<StationInfo> station = List();
    List<PathsInfo> list = List();
    PathsInfo pathsInfo;
    list = createAllPaths(s1.codeStation,s2.codeStation) ;
    print(list);

    pathsInfo =list.first;
    station=List.from(pathsInfo.lesStation);

    return station;
  }




  Node getNodeByName(String name){
    Node node;
    for(Node e in ourGraph){
      if(name == e.val.stationName)
        node = e;
    }
    return node;
  }
  Node getNodeByCode(String code){
    Node node;
    for(Node e in ourGraph){
      if(code == e.val.codeStation)
        node = e;
    }
    return node;
  }

}