import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:transportapp/Model/Constant.dart';
import 'package:transportapp/Model/HistoriqueInfo.dart';

import 'Widgets/TheContainerHistorique.dart';

class HistoryScreen extends StatefulWidget {
  final Color color;
  final FirebaseUser user;

   HistoryScreen({ this.color, this.user}) ;
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Firestore cloud = Firestore.instance;
  List<HistoriqueInfo> list1 =List();
  List<TheContainerHistorique> theContList = List();
  Future<List<HistoriqueInfo>> listItems() async{
    list1.clear();
    List<HistoriqueInfo> list2 =List();

   await cloud.collection("Historique Des Choix").getDocuments().then((QuerySnapshot snapshot) {
     snapshot.documents.forEach((element) {
if(widget.user != null){
  if(widget.user.uid==element.data["UserId"] ){
    HistoriqueInfo histo = HistoriqueInfo(element.documentID,element.data["PointDeDépart"],
        element.data["PointDarivee"],element.data["Prix"], element.data["Distance"],
        element.data["Duree"], element.data["Reating"], element.data["UserId"],element.data['StationCode']
        ,element.data["Date"]);

    list2.add(histo);
  }

}else{
  HistoriqueInfo histo = HistoriqueInfo(element.documentID,element.data["PointDeDépart"],
      element.data["PointDarivee"],element.data["Prix"], element.data["Distance"],
      element.data["Duree"], element.data["Reating"], element.data["UserId"],
      element.data['StationCode'],element.data["Date"]);

  list2.add(histo);

}


     });
   });
   print(list2);
    return list2;
  }

  void initData()async
  {
    list1 = await listItems();
    print(list1);

  }
  @override
  void initState() {
    list1.clear();
       initData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:FutureBuilder(
        future: listItems(),
        builder: (BuildContext context, AsyncSnapshot<List<HistoriqueInfo>> snapshot) {
          if(snapshot.hasData){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding:  EdgeInsets.only(top:45,left:15 ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Hero(
                      tag: "history",
                      transitionOnUserGestures: true,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text("Historique",
                          style: Constant.kStyle9,),
                      ),
                    ),
                  ),
                ),
               Expanded(
                 flex: 1,
                 child: ListView.builder(
                   shrinkWrap: true,
                   itemCount: list1.length,
                   itemBuilder: (BuildContext context, int index) {
                     return TheContainerHistorique(
                       color: widget.color,
                       pA: list1[index].pA,
                       pD: list1[index].pD,
                       distance: list1[index].distance,
                       duree:list1[index].duree,
                       price: list1[index].price,
                       rating: list1[index].rating,
                       index: index+1,
                       date: list1[index].date ,
                     );



                   },



                 ),
               ),
              ],
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },)
    );
  }
}

