import 'package:flutter/material.dart';
import 'package:transportapp/Model/Constant.dart';
import 'LineSettingScreen.dart';
import 'LocaliteSettingScreen.dart';
import 'StationSettingScreen.dart';
import 'Widgets/OptionsWidget.dart';
import 'WiliayaSettingScreen.dart';
class ConfigurationScreen extends StatefulWidget {
   final Color color;

  ConfigurationScreen({this.color});
  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
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
                  child: Hero(
                    tag: "gestion",
                    child: Text("Gestion Des Données",
                      style: Constant.kStyle9,),
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 16),
                  children: <Widget>[
                    OptionsWidgets(
                      color: Color(0xff311b92),
                      icon: Icons.departure_board,
                      text: "Les Stations",
                      tag:"station",
                      function: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>StationSetting(color:Color(0xff311b92)),
                          ),
                        );
                      },
                    ),
                    OptionsWidgets(
                      color: Color(0xffc62828),
                      icon: Icons.calendar_view_day,
                      text: "Les Lignes",
                      tag: "line",
                      function: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LineSetting(color:Color(0xffc62828),),
                          ),
                        );
                      },
                    ),
                    OptionsWidgets(
                      color: Color(0xffe57373),
                      icon: Icons.location_city,
                      text: "Les Localités",
                      tag:"loca",
                      function: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocaliteSettings(color:Color(0xffe57373),),
                          ),
                        );
                      },
                    ),
                    OptionsWidgets(
                      color: Color(0xff607d8b),
                      icon: Icons.flag,
                      text: "Les Wilayas",
                      tag: "wilaya",
                      function: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  WilayaSetting(color:Color(0xff607d8b),),
                          ),
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
