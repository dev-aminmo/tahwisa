import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tahwisa/blocs/location_picker_bloc/bloc.dart';
import 'package:tahwisa/repositories/maps_repository.dart';
import 'package:tahwisa/style/my_colors.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  State<LocationPickerScreen> createState() => LocationPickerScreenState();
}

class LocationPickerScreenState extends State<LocationPickerScreen> {
  LocationPickerBloc _locationPickerBloc;
  Completer<GoogleMapController> _controller = Completer();
  Marker _marker;
  MapsRepository _mapsRepository;
  bool _textFieldHasFocus = false;
  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(36.73838289080758, 3.0847137703306404),
    zoom: 10,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildTypeAheadTextField(context),
        actions: [_buildActions(context)],
      ),
      body: buildGoogleMap(),
    );
  }

  Widget buildTypeAheadTextField(BuildContext context) {
    return buildTextFieldFocusMonitor(
        child: TypeAheadField(
      hideOnEmpty: true,
      hideOnLoading: true,
      debounceDuration: const Duration(milliseconds: 150),
      hideOnError: true,
      textFieldConfiguration: TextFieldConfiguration(
        decoration: const InputDecoration(
            hintText: "search for a place",
            counterText: "",
            errorStyle: const TextStyle(fontSize: 16),
            hintStyle: const TextStyle(
                fontWeight: FontWeight.w400, color: Colors.white, fontSize: 16),
            border: InputBorder.none),
        cursorColor: MyColors.white,
        style: DefaultTextStyle.of(context).style.copyWith(
            color: MyColors.white, fontWeight: FontWeight.w400, fontSize: 16),
      ),
      suggestionsCallback: (pattern) async {
        print(pattern);
        return (pattern.length > 1)
            ? await _mapsRepository.autocomplete(pattern)
            : [];
      },
      onSuggestionSelected: (suggestion) async {
        var location =
            await _mapsRepository.getLocationByPlaceId(suggestion?.placeId);
        if (location != null) {
          var latLng = LatLng(location.lat, location.lng);

          setState(() {
            _marker = Marker(position: latLng, markerId: MarkerId("1"));
          });

          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newLatLng(latLng));
        }
      },
      itemBuilder: (context, suggestion) {
        return suggestion != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Text(
                      suggestion?.description ?? '',
                      softWrap: true,
                    )),
                  ],
                ),
              )
            : SizedBox();
      },
    ));
  }

  Focus buildTextFieldFocusMonitor({@required child}) {
    return Focus(
      onFocusChange: (focus) {
        print(focus);
        setState(() {
          _textFieldHasFocus = focus;
        });
      },
      child: child,
    );
  }

  Widget _buildActions(BuildContext context) {
    return _textFieldHasFocus
        ? SizedBox(
            width: 8,
          )
        : IconButton(
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
            ));
  }

  GoogleMap buildGoogleMap() {
    return GoogleMap(
      markers: (_marker != null) ? {_marker} : {},
      mapType: MapType.normal,
      initialCameraPosition: _initialPosition,
      onTap: (latLng) {
        setState(() {
          _marker = Marker(
              position: LatLng(latLng.latitude, latLng.longitude),
              markerId: MarkerId("1"));
        });
      },
      mapToolbarEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _locationPickerBloc = BlocProvider.of<LocationPickerBloc>(context);
    _mapsRepository = RepositoryProvider.of<MapsRepository>(context);
  }

  @override
  void dispose() {
    _controller.future.then((value) => value.dispose());
    super.dispose();
  }
}
