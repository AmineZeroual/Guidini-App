import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportapp/Model/Constant.dart';

class TransportFilteringWidget extends StatelessWidget {
  final IconData icon;
  final String transportName;
  final Color color;
  final Color iconColor;
  final Function function;
  TransportFilteringWidget({
    @required this.icon,
    @required this.transportName, this.color, this.function, this.iconColor
  }) ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 0,horizontal: 8),
      child: GestureDetector(
        onTap: function,
        child: Container(
          width: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top:6.0,bottom: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  size: 40,
                  color: iconColor,
                ),
                Text(
                  "$transportName",
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 16,
                    fontFamily: 'Spartan1',
                  ),
                )
              ],

            ),
          ),
        ),
      ),
    );
  }
}
