import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocalización en Flutter',
      home: Geolocalizacion(),
    );
  }
}

class Geolocalizacion extends StatefulWidget {
  @override
  State<Geolocalizacion> createState() => GeolocalizacionState();
}

class GeolocalizacionState extends State<Geolocalizacion> {

  Completer<GoogleMapController> _controller = Completer();

  LatLng myPoint=LatLng(0,0);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _createMarkers(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToPosition,
        child: Icon(Icons.my_location),
        backgroundColor: Colors.blue,
      ),

    );
  }

  Future<void> _goToPosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    CameraPosition myPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(myPosition));
    setState(() {
      myPoint=LatLng(position.latitude, position.longitude);
    });
  }

  Set<Marker> _createMarkers(){
    var tmp = Set<Marker>();
    tmp.add(Marker(
        markerId: MarkerId("Point"),
        position: myPoint,
        infoWindow: InfoWindow(title: "Mi posición")
    ));
    return tmp;
  }
}