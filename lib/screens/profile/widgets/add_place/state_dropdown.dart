import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/drop_down_state_bloc/bloc.dart';
import 'package:tahwisa/repositories/models/state.dart';
import 'package:tahwisa/style/my_colors.dart';

class StateDropdown extends StatelessWidget {
  const StateDropdown({
    Key key,
    @required DropDownStateBloc dropDownStateBloc,
  })  : _dropDownStateBloc = dropDownStateBloc,
        super(key: key);

  final DropDownStateBloc _dropDownStateBloc;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: BlocBuilder(
          bloc: _dropDownStateBloc,
          builder: (context, state) {
            if (state is DropDownsStatesSuccess)
              return StreamBuilder<MyState>(
                  stream: _dropDownStateBloc.selectedState,
                  builder: (context, item) {
                    return DropdownButton(
                      itemHeight: 72,
                      isExpanded: true,
                      hint: Text(
                        "State",
                      ),
                      value: item.data,
                      icon: Icon(
                        Icons.expand_more,
                        color: MyColors.greenBorder,
                      ),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: MyColors.greenBorder,
                      ),
                      onChanged: (state) =>
                          _dropDownStateBloc.add(StateChosen(state: state)),
                      items: state.states?.map<DropdownMenuItem<MyState>>((e) {
                        return DropdownMenuItem<MyState>(
                          value: e,
                          child: Text(e.name),
                        );
                      })?.toList(),
                    );
                  });
            else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
