import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transportapp/Controller/Graphes.dart';
import 'package:transportapp/Model/Constant.dart';
import 'package:transportapp/Model/PathsInfo.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:transportapp/Model/StationInfo.dart';
import 'package:geodesy/geodesy.dart' as geoloc;

import 'BottomSheetScreen.dart';

class MapScreen extends StatefulWidget {
  final PathsInfo path;
  final Color color;

  MapScreen({this.path, this.color});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //******************Variables******************//
  GoogleMapController mapController;
  Position currentPosition;
  Set<Marker> marker = Set();
  List<LatLng> polylineCoordinates = List();
  Set<PointLatLng> listPoints = Set();
  Geolocator geoLocator;
  Firestore cloud = Firestore.instance;
  Set<Polyline> polyList = Set();
  LatLng center = LatLng(36.775055, 3.060276);
  PolylinePoints polylinePoints = PolylinePoints();
  bool reated;
  List<StationInfo> theList=List();
  double ratingPath = 0;
  geoNode nodeListFinal ;
  Graphes graphes = Graphes();
  List<Node> graph ;
  List<geoNode> nodeList = List();
  geoloc.Geodesy geodesy = geoloc.Geodesy();

  //****************Methods**********************//
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reated = false;
    initData();

  }
void initData()async{

  graph= await graphes.createGraph();


}
  geoNode getStationLocation(){
    geoNode node1;
    graph.forEach((element) async {
      double dd;
      geoloc.LatLng l1 =geoloc.LatLng(currentPosition.latitude, currentPosition.longitude);
      geoloc.LatLng l2 =geoloc.LatLng(element.val.geoPoint.latitude, element.val.geoPoint.longitude);
      dd =  geodesy.distanceBetweenTwoGeoPoints(l1
          ,l2);
      geoNode node= geoNode(element.val, dd) ;

      nodeList.add(node);
    });

    nodeList.sort((a, b) => a.distance.compareTo(b.distance));
    print(nodeList);
    node1=nodeList.first;
    return node1;
}

  void createMarkers() {
    LatLng l1 = widget.path != null
        ? LatLng(widget.path.lesStation.first.geoPoint.latitude,
            widget.path.lesStation.first.geoPoint.longitude)
        : LatLng(0, 0);
    LatLng l2 = widget.path != null
        ? LatLng(widget.path.lesStation.last.geoPoint.latitude,
            widget.path.lesStation.last.geoPoint.longitude)
        : LatLng(0, 0);
    setState(() {
      marker.add(
        Marker(
          markerId: MarkerId('sourceId'),
          position: l1,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          infoWindow: InfoWindow(
            title: widget.path != null
                ? widget.path.lesStation.first.stationName
                : "",
            snippet: "Lat :" +
                l1.latitude.toStringAsFixed(2) +
                " Lng :" +
                l1.longitude.toStringAsFixed(2),
          ),
        ),
      );
      marker.add(
        Marker(
          markerId: MarkerId('distinationId'),
          position: l2,
          infoWindow: InfoWindow(
            title: widget.path != null
                ? widget.path.lesStation.last.stationName
                : "",
            snippet: "Lat :" +
                l2.latitude.toStringAsFixed(2) +
                " Lng :" +
                l2.longitude.toStringAsFixed(2),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  Future<void> createPolyline() async {
    if (widget.path != null) {
      widget.path.lesStation.forEach((element) {
        polylineCoordinates
            .add(LatLng(element.geoPoint.latitude, element.geoPoint.longitude));
      });

      setState(() {
        Polyline polyline = Polyline(
          polylineId: PolylineId('pathId'),
          color: widget.color,
          points: polylineCoordinates,
          width: 5,
        );
        polyList.add(polyline);
      });
    }
  }

  void updateCamira()async{
    await updateLocation(
        currentPosition.latitude, currentPosition.longitude);
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    createMarkers();
    await createPolyline();
  }

  Future<void> updateLocation(double lat, double lang) async {
    await mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lang),
          zoom: 13.0,
        ),
      ),
    );
  }


  Future<void> getCurrentLocation() async {
    geoLocator = Geolocator()..forceAndroidLocationManager;

    await geoLocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: graphes.createGraph(),
      builder: (BuildContext context, AsyncSnapshot<List<Node>> snapshot) {
        if(snapshot.hasData){
          return Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: center,
                  zoom: 11.0,
                ),
                markers: widget.path != null ? marker : null,
                polylines: widget.path != null ? polyList : null,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 40, right: 10),
                  child: FloatingActionButton(
                    backgroundColor: widget.color,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    onPressed: () async {

                     await getCurrentLocation();
                      nodeListFinal = getStationLocation();
                      setState(() {
                        if (currentPosition != null) {
                         updateCamira();
                         showModalBottomSheet(
                           context: context,
                           isScrollControlled: true,
                           builder: (context) => SingleChildScrollView(
                             child: Container(
                               padding: EdgeInsets.only(
                                   bottom: MediaQuery.of(context).viewInsets.bottom),
                               child: BottomSheetScreen(color: widget.color,stat: nodeListFinal.stationInfo,isLocated: true,),
                             ),
                           ),
                         );

                        }

                      });


                    },
                  ),
                ),
              ),
              Builder(
                builder: (BuildContext context) {
                  if (widget.path != null) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 10,
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Builder(
                              builder: (BuildContext context) {
                                if (reated == false) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        "Évaluez le chemin",
                                        style: Constant.kStyle12,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      RatingBar(
                                        itemSize: 32,
                                        initialRating: 3,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            reated = true;
                                            ratingPath =rating;
                                          });
                                          DateTime now = new DateTime.now();
                                          DateTime date = new DateTime(now.year, now.month, now.day);

                                          FirebaseAuth.instance.currentUser().then((value) async {
                                            await Firestore.instance
                                                .collection('Historique Des Choix')
                                                .document()
                                                .setData({
                                              'UserId': value.isAnonymous ? "":value.uid,
                                              'PointDeDépart': widget.path.lesStation.first.stationName,
                                              'PointDarivee': widget.path.lesStation.last.stationName,
                                              'StationCode':widget.path.lesStation.first.codeStation,
                                              'Distance':widget.path.distance.toString(),
                                              'Duree': widget.path.time.toString(),
                                              'Prix':widget.path.totalPrice.toString(),
                                              'Reating':ratingPath.toString(),
                                              'Date':date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString(),
                                            });

                                          });
                                        },
                                      ),
                                    ],
                                  );
                                } else {
                                  return Text(
                                    "Merçi Pour l'évaluation",
                                    style: Constant.kStyle12,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Text("");
                  }
                },
              )
            ],
          );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },);
  }
}
class geoNode {
  StationInfo stationInfo ;
  double distance;

  @override
  String toString() {
    return 'geoNode{stationInfo: $stationInfo, distance: $distance}';
  }
  geoNode(this.stationInfo, this.distance);
}
