
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportapp/Model/Constant.dart';

class OptionsWidgets extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function function;
  final Color color;
  final String tag;

   OptionsWidgets({
    this.text,
    this.icon,
    this.function,
    this.color, this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: tag,
                transitionOnUserGestures: true,
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: Constant.kStyle7,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Icon(
                icon,
                color: Colors.white,
                size: 65,
              ),
            ],
          ),
        ),
      ),
      onTap: function,
    );
  }
}
