import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tahwisa/blocs/drop_down_municipal_bloc/bloc.dart';
import 'package:tahwisa/blocs/drop_down_state_bloc/bloc.dart';
import 'package:tahwisa/cubits/search_filter_cubit/search_filter_cubit.dart';
import 'package:tahwisa/repositories/models/SearchFilter.dart';
import 'package:tahwisa/screens/profile/widgets/add_place/municipal_dorpdown.dart';
import 'package:tahwisa/screens/profile/widgets/add_place/state_dropdown.dart';
import 'package:tahwisa/style/my_colors.dart';

import 'range_slider_view.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
  final SearchFilterCubit searchFilterCubit;
  final DropDownStateBloc _dropDownStateBloc;
  final DropDownsMunicipalBloc _dropDownsMunicipalBloc;

  const FiltersScreen(this.searchFilterCubit, this._dropDownStateBloc,
      this._dropDownsMunicipalBloc);
}

class _FiltersScreenState extends State<FiltersScreen> {
  SearchFilterCubit searchFilterCubit;
  RangeValues _values;
  double width;
  double height;

  @override
  void initState() {
    super.initState();
    searchFilterCubit = widget.searchFilterCubit;
    _initSliderValues();
  }

  Widget makeDismissible({Widget child}) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(
        onTap: () {},
        child: child,
      ));
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return makeDismissible(
        child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.7,
            maxChildSize: 1,
            builder: (BuildContext context,
                    ScrollController scrollController) =>
                Container(
                  color: MyColors.white,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        _buildFiltersList(scrollController),
                        const Divider(
                          height: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 9,
                              child: ApplyButton(),
                            ),
                            Expanded(
                              flex: 6,
                              child: ResetButton(
                                callback: () {
                                  widget._dropDownStateBloc.add(ClearState());
                                  _values = const RangeValues(0, 5);
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )));
  }

  Expanded _buildFiltersList(ScrollController scrollController) {
    return Expanded(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        controller: scrollController,
        child: Column(
          children: <Widget>[
            _buildRatingSlider(),
            const Divider(
              height: 1,
            ),
            buildDropDowns(),
          ],
        ),
      ),
    );
  }

  Padding buildDropDowns() {
    return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                  fontWeight: FontWeight.normal),
            ),
            StateDropdown(
                dropDownStateBloc: widget._dropDownStateBloc, height: height),
            Center(
              child: MunicipalDropDown(
                  dropDownsMunicipalBloc: widget._dropDownsMunicipalBloc,
                  height: height),
            ),
          ],
        ));
  }

  Widget _buildRatingSlider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16, left: 32),
          child: Text(
            'Reviews average',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: RangeSliderView(
            values: _values,
            onChangeRangeValues: _setValuesFilter,
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  void _initSliderValues() {
    if (searchFilterCubit.state is FilterLoadedState) {
      _values = RangeValues(
          ((searchFilterCubit.state) as FilterLoadedState).filter.ratingMin,
          ((searchFilterCubit.state) as FilterLoadedState).filter.ratingMax);
    } else {
      _values = const RangeValues(0, 5);
    }
  }

  _setValuesFilter(RangeValues values) {
    if (searchFilterCubit.state is FilterLoadedState) {
      searchFilterCubit.setFilter(
          ((searchFilterCubit.state) as FilterLoadedState).filter.copyWith(
                ratingMin: values.start,
                ratingMax: values.end,
              ));
    } else {
      searchFilterCubit.setFilter(SearchFilter(
        ratingMin: values.start,
        ratingMax: values.end,
      ));
    }
  }
}

class ApplyButton extends StatelessWidget {
  const ApplyButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, bottom: 32, top: 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: MyColors.lightGreen,
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: Text(
                'Apply',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResetButton extends StatelessWidget {
  final Function callback;
  const ResetButton({
    Key key,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 16, bottom: 32, top: 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(
              color: MyColors.darkBlue,
              width: 1.5,
            )),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            highlightColor: Colors.transparent,
            onTap: callback,
            child: Center(
              child: Text(
                'Reset',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: MyColors.darkBlue),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
