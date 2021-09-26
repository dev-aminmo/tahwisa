import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/drop_down_municipal_bloc/bloc.dart';
import 'package:tahwisa/repositories/models/municipal.dart';
import 'package:tahwisa/style/my_colors.dart';

class MunicipalDropDown extends StatelessWidget {
  const MunicipalDropDown({
    Key key,
    @required DropDownsMunicipalBloc dropDownsMunicipalBloc,
  })  : _dropDownsMunicipalBloc = dropDownsMunicipalBloc,
        super(key: key);

  final DropDownsMunicipalBloc _dropDownsMunicipalBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        cubit: _dropDownsMunicipalBloc,
        builder: (context, state) {
          if (state is DropDownsMunicipalSuccess) {
            return StreamBuilder<Municipal>(
                stream: _dropDownsMunicipalBloc.selectedMunicipal,
                builder: (context, item) {
                  return DropdownButton(
                    itemHeight: 72,
                    isExpanded: true,
                    hint: Text(
                      "Municipal",
                      //  style: SharedUI.textStyle(SharedUI.gray).copyWith(fontSize: 22),
                    ),
                    value: item.data,
                    icon: Icon(
                      Icons.expand_more,
                      color: MyColors.greenBorder,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    //style: SharedUI.textStyle(Colors.black).copyWith(fontSize: 20),
                    underline: Container(
                      height: 2,
                      color: MyColors.greenBorder,
                    ),
                    onChanged: _dropDownsMunicipalBloc.selectedStateEvent,
                    items: state.municipales
                        ?.map<DropdownMenuItem<Municipal>>((e) {
                      return DropdownMenuItem<Municipal>(
                        value: e,
                        child: Text(e.name),
                      );
                    })?.toList(),
                  );
                });
          } else if (state is DropDownMunicipalInitial) {
            return SizedBox();
          } else {
            return Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator());
          }
        });
  }
}
