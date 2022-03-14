import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/app/blocs/drop_down_municipal_bloc/bloc.dart';
import 'package:tahwisa/app/repositories/models/municipal.dart';
import 'package:tahwisa/app/style/my_colors.dart';

class MunicipalDropDown extends StatelessWidget {
  const MunicipalDropDown(
      {Key? key,
      required DropDownsMunicipalBloc? dropDownsMunicipalBloc,
      this.hint = "Municipal"})
      : _dropDownsMunicipalBloc = dropDownsMunicipalBloc,
        super(key: key);

  final DropDownsMunicipalBloc? _dropDownsMunicipalBloc;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _dropDownsMunicipalBloc,
        builder: (context, dynamic state) {
          if (state is DropDownsMunicipalSuccess) {
            return StreamBuilder<Municipal?>(
                stream: _dropDownsMunicipalBloc!.selectedMunicipal,
                builder: (context, item) {
                  return DropdownButton(
                    itemHeight: 72,
                    isExpanded: true,
                    hint: Text(
                      hint,
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
                    onChanged: _dropDownsMunicipalBloc!.selectedStateEvent,
                    items: state.municipales
                        ?.map<DropdownMenuItem<Municipal>>((e) {
                      return DropdownMenuItem<Municipal>(
                        value: e,
                        child: Text(e.name!),
                      );
                    }).toList(),
                  );
                });
          } else if (state is DropDownMunicipalInitial) {
            return SizedBox();
          } else {
            return Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator()),
            );
          }
        });
  }
}
