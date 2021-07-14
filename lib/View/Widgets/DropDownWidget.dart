import 'package:flutter/material.dart';

class DropDownWidget extends StatelessWidget {
  final String ddValue;
  final List<DropdownMenuItem<String>> items;
  final Color ddColors;
  final Function function;

  const DropDownWidget({ this.ddValue, this.items, this.ddColors, this.function}) ;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: ddColors,
      ),
      child: DropdownButton<String>(
        value: ddValue,
        isDense: true,

        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
        iconSize: 25,
        elevation: 8,

        style: TextStyle(
          fontSize: 15,
          fontFamily: "Spartan5",
          color: Colors.white,

        ),
        underline: Container(
          decoration:  BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white))
          ),
        ),
        items: items,
        onChanged:function,
      ),
    );
  }
}
