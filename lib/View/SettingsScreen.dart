import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportapp/Model/Constant.dart';
import 'package:transportapp/View/ConfigurationScreen.dart';
import 'package:transportapp/View/DataScreen.dart';
import 'package:transportapp/View/HistoriqueScreen.dart';
import 'package:transportapp/View/NotificationScreen.dart';
import 'package:transportapp/View/StatistiqueScreen.dart';
import 'Widgets/OptionsWidget.dart';


class SettingsScreen extends StatefulWidget {
  final Color color;
  final bool isUser;
   SettingsScreen({ this.color, this.isUser}) ;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}



class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [
                0.10,
                0.95
              ],
              colors: [
                Colors.white,
                widget.color,

              ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,

       body: Column(
         children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(left:12.0,top: 50),
             child: Align(
               alignment: Alignment.topLeft,
               child: Text("La Page D'Admin",
                 style: Constant.kStyle9,),
             ),
           ),
           Expanded(
             child: GridView.count(
               crossAxisCount: 2,
               padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 16),
               children: <Widget>[
                 OptionsWidgets(
                   color: Color(0xff00838f),
                   icon: Icons.settings,
                   text: "La Gestion Des Données",
                   tag:"gestion",
                   function: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) =>ConfigurationScreen(color: widget.color,),
                       ),
                     );
                   },
                 ),
                 OptionsWidgets(
                   color: Color(0xffc62828),
                   icon: Icons.rate_review,
                   text: "Consultation",
                   tag: "data",
                   function: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => DataScreen(color: widget.color,isUser: widget.isUser,),
                       ),
                     );
                   },
                 ),
                 OptionsWidgets(
                   color: Color(0xffafb42b),
                   icon: Icons.assessment,
                   text: "Statistique",
                   tag:"stat",
                   function: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => StatisticScreen(color: widget.color,),
                       ),
                     );
                   },
                 ),
                 OptionsWidgets(
                   color:Color(0xff7b1fa2),
                   icon: Icons.notifications_active,
                   text: "Notification",
                   tag: "notif",
                   function: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) =>  NotificationScreen(color: widget.color,),
                       ),
                     );

                   },
                 ),
                 OptionsWidgets(
                   color:Color(0xff004ba0),
                   icon: Icons.star_half,
                   text: "Les Avis",
                   tag: "history",
                   function: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) =>  HistoryScreen(color: widget.color,user: null,),
                       ),
                     );

                   },
                 ),
                 OptionsWidgets(
                   color: Color(0xffe64a19),
                   icon: Icons.arrow_back,
                   text: "Quitter",
                   tag: "",
                   function: () {
                     Navigator.pop(
                       context,
                     );

                   },
                 )
               ],
             ),
           ),
         ],
       )

      ),
    );
  }
}




