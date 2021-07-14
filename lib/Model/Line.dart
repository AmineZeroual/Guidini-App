import 'package:cloud_firestore/cloud_firestore.dart';

class Line{
  String codeLine;
  String codeWilaya;
  String codeTransport;
  String destination;
  String origin;


  Line(this.codeLine, this.codeWilaya, this.codeTransport, this.destination,
      this.origin);

  static Future<double> getPrice(String codeLine) async {
    String transportType;
    double transportPrice;
  await Firestore.instance.collection("Ligne").getDocuments().then((QuerySnapshot snapshot){
    snapshot.documents.forEach((element) {
      if(element.documentID==codeLine){
        transportType=element.data["CodeMoyenDeTransport"];
      }
    });
  });
  await Firestore.instance.collection("Moyen De Transport").getDocuments().then((QuerySnapshot snapshot){
    snapshot.documents.forEach((element){
      if(transportType==element.documentID){
        transportPrice=double.parse(element.data["tarif"]) ;

      }
    });
  });

  return transportPrice;
  }

}