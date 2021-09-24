import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDisplayScreen extends StatefulWidget {
  final latitude;
  final longitude;

  @override
  State<LocationDisplayScreen> createState() => LocationDisplayScreenState();

  LocationDisplayScreen({@required this.latitude, @required this.longitude});
}

class LocationDisplayScreenState extends State<LocationDisplayScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Marker _marker;
  CameraPosition _initialPosition;

  @override
  void initState() {
    _marker = Marker(
        position: LatLng(widget.latitude, widget.longitude),
        markerId: MarkerId("1"));
    _initialPosition = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 10,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("latitude ${widget.latitude}");
    return new Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Transform.translate(
          offset: Offset(4, 0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(125),
              color: Colors.black26,
            ),
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
        ),
      ),
      body: GoogleMap(
        markers: (_marker != null) ? {_marker} : {},
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition,
        onTap: (l) {
          /*print(l.latitude);
          print(l.longitude);
          setState(() {
            _marker = Marker(
                position: LatLng(l.latitude, l.longitude),
                markerId: MarkerId("1"));
          });*/
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
