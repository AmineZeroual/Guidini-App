import 'package:flutter/material.dart';


class TabWidgets extends StatelessWidget {
  final Color color;

  final IconData icon;
  final Function function;
  final String text;

  TabWidgets({this.color, this.icon, this.function, this.text});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Column(
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              color: color,
              fontFamily: "Spartan5",
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Icon(
            icon,
            color: color,
          ),
        ],
      ),
    );
  }
}
