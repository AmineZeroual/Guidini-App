import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///D:/study/PFE/appFolder/transport_app/lib/Model/Constant.dart';
import 'package:transportapp/Model/StationInfo.dart';

class SearchBar extends SearchDelegate<StationInfo> {
  Firestore cloud = Firestore.instance;
  List<StationInfo> myOldSegList = [];
  List<StationInfo> myTempList = [];
  StationInfo textChoice;
  Color color;

  SearchBar({this.color});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: color,
        ),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          color: color,
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: cloud.collection('Station').snapshots(),
        builder: (context, snapShots) {
          if (!snapShots.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: color,
              ),
            );
          } else {
            myOldSegList.clear();
            myTempList.clear();
            final ourData = snapShots.data.documents;
            ourData.forEach((element) {
              StationInfo st = StationInfo( element.data['NomStation'], element.data['GeoPoint'],element.documentID,element.data['CodeLocalite']);
              myTempList.add(st);

            }) ;



            List<StationInfo> mySegList = query.isEmpty
                ? myOldSegList
                : myTempList
                    .where((element) => element.stationName.toLowerCase().contains(query))
                    .toList();

            return Scaffold(
              backgroundColor: color,
              body: ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    textChoice = mySegList[index];
                    close(context, textChoice);
                  },
                  leading: query.isNotEmpty
                      ? Icon(
                          Icons.location_on,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                  title: RichText(
                    text: TextSpan(
                        text: mySegList[index]
                            .stationName
                            .toString()
                            .substring(0, query.length),
                        style: Constant.kStyle1,
                        children: [
                          TextSpan(
                            text: mySegList[index]
                                .stationName
                                .toString()
                                .substring(query.length),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ]),
                  ),
                ),
                itemCount: (mySegList.length),

              ),
            );
          }
        });
  }
}
