import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/app/repositories/maps_repository.dart';

class StaticMapView extends StatefulWidget {
  final latitude;
  final longitude;

  StaticMapView({required this.latitude, required this.longitude});

  @override
  _StaticMapViewState createState() => _StaticMapViewState();
}

class _StaticMapViewState extends State<StaticMapView> {
  String? _staticMapUrl;
  @override
  Widget build(BuildContext context) {
    return _staticMapUrl == null
        ? SizedBox()
        : SizedBox(
            width: double.infinity,
            child: Image.network(_staticMapUrl!,
                // height: 200,
                fit: BoxFit.cover,
                width: double.infinity),
          );
  }

  @override
  void initState() {
    super.initState();
    RepositoryProvider.of<MapsRepository>(context)
        .getStaticMapUrl(widget.latitude, widget.longitude)
        .then((value) => setState(() {
              _staticMapUrl = value;
            }));
  }
}
