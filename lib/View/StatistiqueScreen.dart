import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportapp/Model/Constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:transportapp/Model/HistoriqueInfo.dart';
import 'package:transportapp/View/Widgets/Inducator.dart';

class StatisticScreen extends StatefulWidget {
  final Color color;

  StatisticScreen({this.color}) ;
  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  List<HistoriqueInfo> list1 = List();
  List<StatistiqueNode> liteDatastat = List();
  List<double> transportDegree = [0,0,0,0,0];
  int touchedIndex = 0;

  Future<List<HistoriqueInfo>> listItems() async {
    list1.clear();
    List<HistoriqueInfo> list2 = List();


    await Firestore.instance
        .collection("Historique Des Choix")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        HistoriqueInfo histo = HistoriqueInfo(
            element.documentID,
            element.data["PointDeDépart"],
            element.data["PointDarivee"],
            element.data["Prix"],
            element.data["Distance"],
            element.data["Duree"],
            element.data["Reating"],
            element.data["UserId"],
            element.data['StationCode'],
           element.data["Date"],
        );


        list2.add(histo);
      });
    });

    return list2;
  }


 List<StatistiqueNode> getStatData(){
   List<StatistiqueNode> liteData = List();
   int i =0,j=0;
   List<HistoriqueInfo> listTemp = List();
listTemp.add(list1.first);
   list1.forEach((element1) {
     i=0;
     listTemp.forEach((element2) {
       if(element1.pD==element2.pD && element1.pA==element2.pA){
         i++;
       }


     });

     if(i<1){
       listTemp.add(element1);
     }

   });


   listTemp.forEach((element1) {
     i=0;
     list1.forEach((element2) {
       if(element1.pD==element2.pD && element1.pA==element2.pA){
         i++;
       }
     });
     j=j+i;
     StatistiqueNode node = StatistiqueNode(element1.pD+"-"+element1.pA,i, j);
     liteData.add(node);
   });

   list1.forEach((element) {
     switch(element.stationCode.substring(3,6)){
       case 'LBS' :
         transportDegree[0]=transportDegree[0]+1;
         break;
       case 'LMO' :
         transportDegree[1]=transportDegree[1]+1;
         break;
       case 'LTX' :
         transportDegree[2]=transportDegree[2]+1;
         break;
       case 'LTN' :
         transportDegree[3]=transportDegree[3]+1;
         break;
       case 'LTY' :
         transportDegree[4]=transportDegree[4]+1;
     }
   });
   print(transportDegree);


   return liteData;
 }
 double percentageVal (int val , int max){
    return double.parse(((val*100)/max).toStringAsFixed(1));
 }


  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          double val1= percentageVal(liteDatastat[0].totalOccu, liteDatastat.last.currentOccur);
          return PieChartSectionData(
            color: Color(0xffe57373),
            value: val1,
            title: '$val1 %',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          double val1= percentageVal(liteDatastat[1].totalOccu, liteDatastat.last.currentOccur);
          return PieChartSectionData(
            color:Color(0xff4db6ac),
            value: val1,
            title: '$val1 %',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          double val1= percentageVal(liteDatastat[2].totalOccu, liteDatastat.last.currentOccur);
          return PieChartSectionData(
            color:Color(0xff64b5f6),
            value: val1,
            title: '$val1 %',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          double val1= percentageVal(liteDatastat[3].totalOccu, liteDatastat.last.currentOccur);
          return PieChartSectionData(
            color: Color(0xffffb74d),
            value: val1,
            title: '$val1 %',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }

  void initData() async {
    list1 = await listItems();
    liteDatastat = getStatData();
    print(liteDatastat);
  }



  @override
  void initState() {
    initData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.color,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 45, left: 15, bottom: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Hero(
                    tag: "stat",
                    transitionOnUserGestures: true,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        "Statistique",
                        style: Constant.kStyle10,
                      ),
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                future: listItems(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical:15),
                            child: Text(
                              "Moyene de Transport",
                              style: Constant.kStyle7,
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 15,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              color:  Colors.white,
                              child: Padding(
                                padding:  EdgeInsets.all(20.0),
                                child: BarChart(
                                  BarChartData(
                                    alignment: BarChartAlignment.spaceAround,
                                    maxY: 20,
                                    barTouchData: BarTouchData(
                                      enabled: false,
                                      touchTooltipData: BarTouchTooltipData(
                                        tooltipBgColor: Colors.transparent,
                                        tooltipPadding: const EdgeInsets.all(0),
                                        tooltipBottomMargin: 8,
                                        getTooltipItem: (
                                            BarChartGroupData group,
                                            int groupIndex,
                                            BarChartRodData rod,
                                            int rodIndex,
                                            ) {
                                          return BarTooltipItem(
                                            rod.y.round().toString(),
                                            TextStyle(
                                              color: widget.color,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    titlesData: FlTitlesData(

                                      show: true,
                                      bottomTitles: SideTitles(

                                        showTitles: true,
                                        textStyle: TextStyle(
                                            color:  widget.color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                        margin: 25,
                                        getTitles: (double value) {
                                          switch (value.toInt()) {
                                            case 0:
                                              return 'Bus';
                                            case 1:
                                              return 'Métro';
                                            case 2:
                                              return 'Taxi';
                                            case 3:
                                              return 'Train';
                                            case 4:
                                              return 'Tramway';
                                            default:
                                              return '';
                                          }
                                        },
                                      ),
                                      leftTitles: SideTitles(showTitles: false),

                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    barGroups: [
                                      BarChartGroupData(x: 0, barRods: [
                                        BarChartRodData(
                                            y: transportDegree[0], color: Color(0xffe57373),)
                                      ], showingTooltipIndicators: [
                                        0
                                      ]),
                                      BarChartGroupData(x: 1, barRods: [
                                        BarChartRodData(
                                            y: transportDegree[1], color:  Color(0xffe57373),)
                                      ], showingTooltipIndicators: [
                                        0
                                      ]),
                                      BarChartGroupData(x: 1, barRods: [
                                        BarChartRodData(
                                            y: transportDegree[2], color:  Color(0xffe57373),)
                                      ], showingTooltipIndicators: [
                                        0
                                      ]),
                                      BarChartGroupData(x: 3, barRods: [
                                        BarChartRodData(
                                            y: transportDegree[3], color: Color(0xffe57373),)
                                      ], showingTooltipIndicators: [
                                        0
                                      ]),
                                      BarChartGroupData(x: 3, barRods: [
                                        BarChartRodData(
                                            y: transportDegree[4], color:  Color(0xffe57373),)
                                      ], showingTooltipIndicators: [
                                        0
                                      ]),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top:30,bottom: 10),
                            child: Text(
                              "Les Chemins",
                              style: Constant.kStyle7,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              PieChart(
                                PieChartData(
                                    pieTouchData: PieTouchData(
                                        touchCallback: (pieTouchResponse) {
                                          setState(() {
                                            if (pieTouchResponse.touchInput
                                            is FlLongPressEnd ||
                                                pieTouchResponse.touchInput
                                                is FlPanEnd) {
                                              touchedIndex = -1;
                                            } else {
                                              touchedIndex = pieTouchResponse
                                                  .touchedSectionIndex;
                                            }
                                          });
                                        }),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 60,
                                    sections: showingSections()),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Indicator(
                                    color:Color(0xffe57373),
                                    text: liteDatastat[0].name,
                                    isSquare: true,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Indicator(
                                    color: Color(0xff4db6ac),
                                    text: liteDatastat[1].name,
                                    isSquare: true,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Indicator(
                                    color: Color(0xff64b5f6),
                                    text: liteDatastat[2].name,
                                    isSquare: true,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Indicator(
                                    color: Color(0xffffb74d),
                                    text: liteDatastat[3].name,
                                   size: 20,
                                    isSquare: true,
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                ],
                              ),
                            ],

                          )
                        ],
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            ],
          ),
        )



        );
  }
}



class StatistiqueNode{
  String name;
  int totalOccu;
  int currentOccur;

  @override
  String toString() {
    return 'StatistiqueNode{pathName: $name, totalOccu: $totalOccu, currentOccur: $currentOccur}';
  }

  StatistiqueNode(this.name, this.totalOccu, this.currentOccur);

}