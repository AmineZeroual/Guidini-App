import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:transportapp/Model/Constant.dart';

class TheContainerHistorique extends StatefulWidget {
  final String pD;
  final String pA;
  final String price;
  final String distance;
  final String duree;
  final String rating;
  final int index;
  final String  date ;
  TheContainerHistorique({
    this.pD, this.pA, this.price, this.distance, this.duree, this.rating, this.index, this.color, this.date,
  }) ;

  final Color color;

  @override
  _TheContainerHistoriqueState createState() => _TheContainerHistoriqueState();
}

class _TheContainerHistoriqueState extends State<TheContainerHistorique> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 10,
            ),
          ],
          color:widget.color,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 4.0),
                child: Text(
                  "Trajectoire ${widget.index}",
                  style: Constant.kStyle4,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 4.0),
                child: Text(
                  "Station de Début: ${widget.pD}",
                  style: Constant.kStyle8,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 4.0),
                child: Text(
                  "Station d'arriveé: ${widget.pA}",
                  style: Constant.kStyle8,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 4.0),
                child: Text(
                  "Distance: ${double.parse(widget.distance).toStringAsFixed(2)} Km",
                  style: Constant.kStyle8,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 4.0),
                child: Text(
                  "Durée: ${widget.duree} Min",
                  style: Constant.kStyle8,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 4.0),
                child: Text(
                  "Prix: ${widget.price} Da",
                  style: Constant.kStyle8,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 4.0),
                child: Text(
                  "La Date: ${widget.date}",
                  style: Constant.kStyle8,
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 4.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Rating: ",
                        style: Constant.kStyle8,
                      ),
                      RatingBar(onRatingUpdate:null,
                        itemSize: 18,
                        initialRating: double.parse(widget.rating),
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                        EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
