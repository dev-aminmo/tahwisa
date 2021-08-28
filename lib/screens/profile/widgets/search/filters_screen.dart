import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tahwisa/blocs/drop_down_municipal_bloc/bloc.dart';
import 'package:tahwisa/blocs/drop_down_state_bloc/bloc.dart';
import 'package:tahwisa/repositories/dropdowns_repository.dart';
import 'package:tahwisa/screens/profile/widgets/add_place/municipal_dorpdown.dart';
import 'package:tahwisa/screens/profile/widgets/add_place/state_dropdown.dart';
import 'package:tahwisa/style/my_colors.dart';

import 'range_slider_view.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  RangeValues _values = const RangeValues(0, 5);
  double distValue = 50.0;
  double width;
  double height;
  DropDownsRepository _dropDownsRepository;
  DropDownStateBloc _dropDownStateBloc;
  DropDownsMunicipalBloc _dropDownsMunicipalBloc;

  @override
  void initState() {
    super.initState();
    _dropDownsRepository = DropDownsRepository();
    _dropDownsMunicipalBloc =
        DropDownsMunicipalBloc(dropDownsRepository: _dropDownsRepository);
    _dropDownStateBloc = DropDownStateBloc(
        dropDownsRepository: _dropDownsRepository,
        municipalBloc: _dropDownsMunicipalBloc)
      ..add(FetchStates());
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
/*
                  decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25))),*/
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Column(
                      children: <Widget>[
                        //  getAppBarUI(),
                        SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: <Widget>[
                                priceBarFilter(),
                                const Divider(
                                  height: 1,
                                ),
                                buildDropDowns(),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 32, top: 8),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: MyColors.lightGreen,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24.0)),
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
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(24.0)),
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
                        )
                      ],
                    ),
                  ),
                )));
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
                dropDownStateBloc: _dropDownStateBloc, height: height),
            MunicipalDropDown(
                dropDownsMunicipalBloc: _dropDownsMunicipalBloc,
                height: height),
          ],
        ));
  }

  Widget priceBarFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
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
            onChangeRangeValues: (RangeValues values) {
              _values = values;
            },
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Filters',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
}
