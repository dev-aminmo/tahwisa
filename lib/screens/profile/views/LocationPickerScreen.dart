import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tahwisa/blocs/location_picker_bloc/bloc.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  State<LocationPickerScreen> createState() => LocationPickerScreenState();
}

class LocationPickerScreenState extends State<LocationPickerScreen> {
  LocationPickerBloc _locationPickerBloc;
  Completer<GoogleMapController> _controller = Completer();
  Marker _marker;

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(36.73838289080758, 3.0847137703306404),
    zoom: 10,
  );
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              if (_marker == null) {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Column(children: [
                            Icon(
                              Icons.warning_rounded,
                              color: Colors.yellow.shade600,
                              size: 96,
                            ),
                            SizedBox(height: 36),
                            Text('Please pick a location')
                          ]),
                        ));
              } else {
                _locationPickerBloc.add(LocationChosen(
                  latitude: _marker.position.latitude,
                  longitude: _marker.position.longitude,
                ));
              }
            },
            icon: Icon(
              Icons.check,
            ))
      ]),
      body: GoogleMap(
        markers: (_marker != null) ? {_marker} : {},
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition,
        onTap: (l) {
          print(l.latitude);
          print(l.longitude);
          setState(() {
            _marker = Marker(
                position: LatLng(l.latitude, l.longitude),
                markerId: MarkerId("1"));
          });
        },
        mapToolbarEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _locationPickerBloc = BlocProvider.of<LocationPickerBloc>(context);
  }
}
