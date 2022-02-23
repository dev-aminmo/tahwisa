import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tahwisa/utilities/map_utils.dart';

class LocationDisplayScreen extends StatefulWidget {
  final latitude;
  final longitude;
  final title;

  @override
  State<LocationDisplayScreen> createState() => LocationDisplayScreenState();

  LocationDisplayScreen(
      {required this.latitude,
      required this.longitude,
      required this.title});
}

class LocationDisplayScreenState extends State<LocationDisplayScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Marker? _marker;
  late CameraPosition _initialPosition;

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
    return new Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FittedBox(
        child: FloatingActionButton.extended(
          onPressed: () {
            try {
              MapUtils.openMap(widget.latitude, widget.longitude);
            } catch (e) {
              print(e);
            }
          },
          label: FittedBox(
            child: Text(
              "Open in maps",
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
          icon: Icon(Icons.directions, size: 36, color: Colors.white),
          isExtended: true,
          elevation: 10,
        ),
      ),
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
        markers: (_marker != null) ? {_marker!} : {},
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
