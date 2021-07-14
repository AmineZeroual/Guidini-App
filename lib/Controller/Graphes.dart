import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transportapp/Model/PathsInfo.dart';
import 'package:transportapp/Model/Slice.dart';
import 'package:transportapp/Model/StationInfo.dart';

class Graphes{
  List<Node> graph = List() ;
  Firestore cloud = Firestore.instance;
  List<Slice> sList = List();
  List<Slice> sList2 = List();
  List<Slice> sList3 = List();

  Future<List<Node>>createGraph() async{
    graph.clear();
    await cloud.collection("Tronçon").getDocuments().then((QuerySnapshot snapshot){
      snapshot.documents.forEach((S) {
        Slice slice = Slice(S.documentID,S.data["CodeStation1"],S.data["CodeStation2"]
            ,S.data["CodeLigne"],S.data["Distance"],S.data["Duree"]);
        sList.add(slice);
      });
    });
    await cloud.collection("Station").getDocuments().then((QuerySnapshot snapshot){
      snapshot.documents.forEach((element) {
        StationInfo station = StationInfo(element.data["NomStation"],element.data["GeoPoint"],element.documentID,element.data["CodeLocalite"]);
        for(Slice se in sList){
          if(se.codeStation1==station.codeStation){
            sList2.add(se);
          }
        }
        sList3 = List.from(sList2);
        Node node = Node(station,sList3);
        graph.add(node);
        sList2.clear();
      });
    });
   sList.clear();
   return graph;
  }

  void createIconsForStations()async{
    String typeTransport;
  for(Node element in graph){
    for(Slice element2 in element.sliceList){
       await Firestore
           .instance
           .collection("Ligne")
           .getDocuments()
           .then((QuerySnapshot snapshot) {
         snapshot
             .documents
             .forEach((element3) {
           if(element2.codeLine==element3.documentID)
             typeTransport=element3.data["CodeMoyenDeTransport"];
         });
       });
     }

     if(typeTransport=="Tramway"){
       element.val.iconData = Icons.tram;
       element.val.iconColor=Color(0xff4db6ac);
     }else if (typeTransport=="Bus"){
       element.val.iconData = Icons.directions_bus;
       element.val.iconColor=Color(0xffe57373);
     }else if (typeTransport=="Métro"){
       element.val.iconData = Icons.directions_subway;
       element.val.iconColor= Color(0xff64b5f6);
     }else if (typeTransport=="A Pied"){
       element.val.iconData = Icons.directions_walk;
       element.val.iconColor=Color(0xff00c853);
     }else if (typeTransport=="Taxi"){
       element.val.iconData = Icons.local_taxi;
       element.val.iconColor=Color(0xfffff176);
     }else if (typeTransport=="Train"){
       element.val.iconData = Icons.directions_railway;
       element.val.iconColor=Color(0xffffb74d);
     }




   }








  }



















}
class Node{
  StationInfo val;
  List<Slice> sliceList;
  Node(this.val, this.sliceList);

  @override
  String toString() {
    return 'Node{val: ${val.codeStation}}';
  }

}