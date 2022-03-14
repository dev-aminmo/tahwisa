import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/app/blocs/drop_down_municipal_bloc/bloc.dart';
import 'package:tahwisa/app/blocs/drop_down_state_bloc/bloc.dart';
import 'package:tahwisa/app/blocs/location_picker_bloc/bloc.dart';
import 'package:tahwisa/app/screens/profile/widgets/add_place/municipal_dorpdown.dart';
import 'package:tahwisa/app/screens/profile/widgets/add_place/state_dropdown.dart';
import 'package:tahwisa/app/screens/profile/widgets/static_map_view.dart';
import 'package:tahwisa/app/style/my_colors.dart';

class LocationPage extends StatefulWidget {
  final DropDownStateBloc? dropDownStateBloc;
  final DropDownsMunicipalBloc? dropDownsMunicipalBloc;
  final LocationPickerBloc? locationPickerBloc;

  const LocationPage(
      {required this.dropDownStateBloc,
      required this.dropDownsMunicipalBloc,
      required this.locationPickerBloc});

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage>
    with AutomaticKeepAliveClientMixin<LocationPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15),
      children: [
        SizedBox(height: 48),
        StateDropdown(dropDownStateBloc: widget.dropDownStateBloc),
        MunicipalDropDown(
          dropDownsMunicipalBloc: widget.dropDownsMunicipalBloc,
        ),
        SizedBox(height: 48),
        BlocBuilder<LocationPickerBloc, LocationPickerState>(
          builder: (context, state) {
            if (state is LocationPicked) {
              return Column(
                children: [
                  StaticMapView(
                      latitude: state.latitude, longitude: state.longitude),
                  SizedBox(height: 12),
                  MaterialButton(
                    color: MyColors.lightGreen,
                    onPressed: () {
                      widget.locationPickerBloc!.add(PickLocation());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      child: Text(
                        "Re-Pick Location",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              );
            }
            return GestureDetector(
              onTap: () => widget.locationPickerBloc!.add(PickLocation()),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_location_rounded,
                      color: MyColors.darkBlue, size: 72),
                  SizedBox(height: 12),
                  MaterialButton(
                    color: MyColors.darkBlue,
                    onPressed: () {
                      widget.locationPickerBloc!.add(PickLocation());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "Pick Location",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
