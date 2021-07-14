
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportapp/Model/Constant.dart';
import 'package:transportapp/Model/PathsInfo.dart';
import 'package:transportapp/View/OptionsScreen.dart';
import 'BottomSheetScreen.dart';
import 'MapScreen.dart';

class MainAppScreen extends StatefulWidget {
  final PathsInfo path;
  final Color color;

  MainAppScreen({this.path, this.color}) ;
  @override
  _MainAppScreenState createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  List<Widget> widgetList =List() ;

  int pageIndex = 0;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widgetList = [MapScreen(path: widget.path,color:widget.color), OptionScreen(widget.color)];

  }
  void getSelectedIndex(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:widgetList[pageIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: RaisedButton(
          shape: StadiumBorder(),
        elevation: 12,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: BottomSheetScreen(color: widget.color,stat: null,isLocated: false,),
              ),
            ),
          );
        },
        color: Colors.white,
        child: Padding(
          padding:  EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.search,
                color:widget.color,
              ),
              Padding(
                padding:  EdgeInsets.only(bottom :4.0,top: 4),
                child: Text("Rechercher",
                style: Constant.kStyle12,),
              )
            ],
          ),
        )
      ),
      bottomNavigationBar: BottomNavigationBar(

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              size: 35,
              color: Colors.white,
            ),
            title: Text(
              "Carte",
              style: Constant.kStyle1,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              size: 35,
              color: Colors.white,
            ),
            title: Text(
              "Options",
              style: Constant.kStyle1,
            ),
          ),
        ],
        backgroundColor: widget.color,
        currentIndex: pageIndex,
        onTap: getSelectedIndex,
      ),
    );
  }
}
