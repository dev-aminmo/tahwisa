import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/src/blocs/location_picker_bloc/bloc.dart';

import './add_place_stepper/add_place_stepper.dart';
import '../LocationPickerScreen.dart';

class AddPlaceNavigator extends StatefulWidget {
  @override
  _AddPlaceNavigatorState createState() => _AddPlaceNavigatorState();
}

class _AddPlaceNavigatorState extends State<AddPlaceNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LocationPickerBloc(),
        child: BlocBuilder<LocationPickerBloc, LocationPickerState>(
            builder: ((context, state) {
          return WillPopScope(
            //this will override the back button behavior so when the button is clicked onPopPage will be called
            onWillPop: () async =>
                !await _navigatorKey.currentState!.maybePop(),

            child: Navigator(
              key: _navigatorKey,
              pages: [
                MaterialPage(child: AddPlaceStepper()),
                if (state is LocationPickerLoading)
                  MaterialPage(child: LocationPickerScreen())
              ],
              onPopPage: (route, result) {
                //in case of the user doesn't select a location the location bloc will yield initial state
                BlocProvider.of<LocationPickerBloc>(context)
                    .add(PickCanceled());
                return route.didPop(result);
              },
            ),
          );
        })),
      ),
    );
  }
}
