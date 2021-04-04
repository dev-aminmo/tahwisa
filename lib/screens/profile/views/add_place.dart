import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/dropdownsBloc/bloc.dart';
import 'package:tahwisa/blocs/place_upload_bloc/bloc.dart';
import 'package:tahwisa/repositories/dropdowns_repository.dart';
import 'package:tahwisa/repositories/models/municipal.dart';
import 'package:tahwisa/repositories/models/state.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/style/my_colors.dart';

class AddPlace extends StatefulWidget {
  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  PlaceUploadBloc _placeUploadBloc;
  PlaceRepository placeRepository;
  DropDownsRepository _dropDownsRepository;
  DropDownStateBloc _dropDownStateBloc;
  DropDownsMunicipalBloc _dropDownsMunicipalBloc;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: SizedBox(
        width: width * 0.18,
        height: width * 0.18,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          onPressed: () {
            _placeUploadBloc.add(UploadPlaceButtonPressed(
              title: "hello",
              description: "jardin desssai",
              picture: "des tube qui font des tune ",
              latitude: 4.6,
              longitude: 6.7,
              municipalID: 5,
            ));
          },
          child: Icon(
            Icons.send,
            size: 36,
          ),
        ),
      ),
      backgroundColor: MyColors.white,
      resizeToAvoidBottomInset: false,
      //  resizeToAvoidBottomPadding: false,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Column(
          children: [
            SizedBox(height: height * 0.05),
            /* DropDowns(height, width),
           */
            /*BlocBuilder<DropDownsBloc, DropDownsState>(
              cubit: _dropDownsBloc..add(FetchStates()),
              builder: (context, state) {
                if (state is DropDownsStateLoading) {
                  return CircularProgressIndicator();
                }
                if (state is DropDownsStatesSuccess) {
                  return Container(
                    height: 300,
                    width: 300,
                    child: Column(
                      children: [
                        StreamBuilder<MyState>(
                            stream: _dropDownsBloc.selectedState,
                            builder: (context, item) {
                              return DropdownButton<MyState>(
                                itemHeight: height * 0.1,
                                isExpanded: true,
                                hint: Text(
                                  "State",
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
                                onChanged: (MyState newValue) {
                                  _dropDownsBloc
                                      .add(StateChosen(state: newValue));
                                },
                                items: state.states
                                    .map<DropdownMenuItem<MyState>>(
                                        (MyState val) {
                                  return DropdownMenuItem<MyState>(
                                    value: val,
                                    child: Text(val.name),
                                  );
                                }).toList(),
                              );
                            }),
                      ],
                    ),
                  );
                }
                if (state is DropDownsMunicipalLoading) {
                  return Container(
                    height: 300,
                    width: 300,
                    child: Column(
                      children: [
                        StreamBuilder<MyState>(
                            stream: _dropDownsBloc.selectedState,
                            builder: (context, item) {
                              return DropdownButton<MyState>(
                                itemHeight: height * 0.1,
                                isExpanded: true,
                                hint: Text(
                                  "State",
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
                                onChanged: (MyState newValue) {
                                  _dropDownsBloc
                                      .add(StateChosen(state: newValue));
                                },
                                items: _dropDownsBloc.states
                                    .map<DropdownMenuItem<MyState>>(
                                        (MyState val) {
                                  return DropdownMenuItem<MyState>(
                                    value: val,
                                    child: Text(val.name),
                                  );
                                }).toList(),
                              );
                            }),
                        CircularProgressIndicator()
                      ],
                    ),
                  );
                }
                if (state is DropDownsMunicipalesSuccess) {
                  return Container(
                    height: 300,
                    width: 300,
                    child: Column(
                      children: [
                        /*
                        StreamBuilder<MyState>(
                            stream: _dropDownsBloc.selectedState,
                            builder: (context, item) {
                              return DropdownButton<MyState>(
                                itemHeight: height * 0.1,
                                isExpanded: true,
                                hint: Text(
                                  "State",
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
                                onChanged: (MyState newValue) {
                                  _dropDownsBloc
                                      .add(StateChosen(state: newValue));
                                },
                                items: _dropDownsBloc.states
                                    .map<DropdownMenuItem<MyState>>(
                                        (MyState val) {
                                  return DropdownMenuItem<MyState>(
                                    value: val,
                                    child: Text(val.name),
                                  );
                                }).toList(),
                              );
                            }),*/
                        DropdownButton<Municipal>(
                          itemHeight: height * 0.1,
                          isExpanded: true,
                          hint: Text(
                            "State",
                            //  style: SharedUI.textStyle(SharedUI.gray).copyWith(fontSize: 22),
                          ),
                          // value: item.data,
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
                          onChanged: (Municipal newValue) {
                            // _dropDownsBloc.add(StateChosen(state: newValue));
                          },
                          items: state.municipales
                              .map<DropdownMenuItem<Municipal>>(
                                  (Municipal val) {
                            return DropdownMenuItem<Municipal>(
                              value: val,
                              child: Text(val.name),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  );
                }

                return Text(";");
              },
            ),*/
            BlocBuilder(
                cubit: _dropDownStateBloc..add(FetchStates()),
                builder: (context, state) {
                  if (state is DropDownsStatesSuccess)
                    return StreamBuilder<MyState>(
                        stream: _dropDownStateBloc.selectedState,
                        builder: (context, item) {
                          return DropdownButton(
                            itemHeight: height * 0.1,
                            isExpanded: true,
                            hint: Text(
                              "State",
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
                            onChanged: (state) => _dropDownStateBloc
                                .add(StateChosen(state: state)),
                            items: state.states
                                ?.map<DropdownMenuItem<MyState>>((e) {
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
            BlocBuilder(
                cubit: _dropDownsMunicipalBloc,
                builder: (context, state) {
                  if (state is DropDownsMunicipalSuccess) {
                    return StreamBuilder<Municipal>(
                        stream: _dropDownsMunicipalBloc.selectedMunicipal,
                        builder: (context, item) {
                          print(item.data?.name);
                          return DropdownButton(
                            itemHeight: height * 0.1,
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
                            onChanged:
                                _dropDownsMunicipalBloc.selectedStateEvent,
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
                    return CircularProgressIndicator();
                  }
                }),
            /*StreamBuilder<List<Municipal>>(
                stream: _dropDownsBloc.municipales,
                builder: (context, snapshot) {
                  return StreamBuilder<Municipal>(
                      stream: _dropDownsBloc.selectedMunicipal,
                      builder: (context, item) {
                        return DropdownButton(
                          itemHeight: height * 0.1,
                          isExpanded: true,
                          hint: Text(
                            "State",
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
                          onChanged: _dropDownsBloc.selectedMunicipalEvent,
                          items: snapshot?.data
                              ?.map<DropdownMenuItem<Municipal>>((e) {
                            return DropdownMenuItem<Municipal>(
                              value: e,
                              child: Text(e.name),
                            );
                          })?.toList(),
                        );
                      });
                }),*/

            /******************************

            SizedBox(height: height * 0.05),
            TextFormField(
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "enter title of the place",
                  counterText: "",
                  errorStyle: TextStyle(fontSize: 16),
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xff8FA0B3),
                      fontSize: 16),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: MyColors.greenBorder, width: 1.5)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: MyColors.greenBorder, width: 2.5))),
              cursorColor: MyColors.lightGreen,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: MyColors.darkBlue,
                  fontSize: 20),
            ),
            SizedBox(height: height * 0.05),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: MyColors.greenBorder,
                  ),
                  borderRadius: BorderRadius.circular(width * 0.03),
                  color: Colors.white),
              child: Column(
                children: [
                  TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "description",
                        counterText: "",
                        errorStyle: TextStyle(fontSize: 16),
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xff8FA0B3),
                            fontSize: 16),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 1.5)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 2.5))),
                    cursorColor: MyColors.lightGreen,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: MyColors.darkBlue,
                        fontSize: 20),
                  ),
                  Divider(
                    height: 2,
                    color: MyColors.gray,
                    indent: width * 0.05,
                    endIndent: width * 0.05,
                  ),
                  SizedBox(height: height * 0.01),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 19, vertical: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(Icons.photo_library_rounded,
                                  color: MyColors.darkBlue, size: 32),
                              SizedBox(width: width * 0.02),
                              Text("Pictures",
                                  style: TextStyle(
                                      color: MyColors.darkBlue, fontSize: 18)),
                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.location_solid,
                                  color: MyColors.darkBlue, size: 32),
                              SizedBox(width: width * 0.02),
                              Text("Location",
                                  style: TextStyle(
                                      color: MyColors.darkBlue, fontSize: 18)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
                ***********/
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _dropDownsRepository = DropDownsRepository();
    _dropDownsMunicipalBloc =
        DropDownsMunicipalBloc(dropDownsRepository: _dropDownsRepository);
    _dropDownStateBloc = DropDownStateBloc(
        dropDownsRepository: _dropDownsRepository,
        municipalBloc: _dropDownsMunicipalBloc);
    placeRepository = RepositoryProvider.of<PlaceRepository>(context);
    _placeUploadBloc = PlaceUploadBloc(
      placeRepository: placeRepository,
    );
  }

  @override
  void dispose() {
    _placeUploadBloc.close();
    super.dispose();
  }
}

class DropDowns extends StatefulWidget {
  DropDowns(
    this.height,
    this.width,
  );

  double width;
  double height;

  @override
  _DropDownsState createState() => _DropDownsState();
}

class _DropDownsState extends State<DropDowns> {
  String bloodDropDownValue;
  String stateDropDownValue;
  String municipalDropDownValue;
  String stateId;
  String municipal;
  bool valid = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            DefaultAssetBundle.of(context).loadString('assets/wilayas.json'),
        builder: (ctx, snapShotDropDown) {
          if (snapShotDropDown.connectionState == ConnectionState.done) {
            var data = json.decode(snapShotDropDown.data);
            List<String> municipals = [];
            List<String> states = [];
            for (var i = 1; i <= data[0].length; i++) {
              states.add(data[0][i.toString()]["name"]);
            }
            if (stateDropDownValue != null) {
              for (var i = 1; i <= data[0].length; i++) {
                if (data[0][i.toString()]["name"] == stateDropDownValue) {
                  stateId = i.toString();
                }
              }
              data[0][stateId]["communes"].forEach((k, v) =>
                  municipals.add(data[0][stateId]["communes"][k]["name"]));
            }

            return Column(
              children: [
                DropdownButton<String>(
                  itemHeight: widget.height * 0.12,
                  isExpanded: true,
                  hint: Text(
                    "State",
                    //  style: SharedUI.textStyle(SharedUI.gray).copyWith(fontSize: 22),
                  ),
                  value: stateDropDownValue,
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
                  onChanged: (String newValue) {
                    setState(() {
                      municipalDropDownValue = null;
                      stateDropDownValue = newValue;
                    });
                  },
                  items: states.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  itemHeight: widget.height * 0.12,
                  isExpanded: true,
                  hint: Text(
                    "Municipal",
                    //style: SharedUI.textStyle(SharedUI.gray).copyWith(fontSize: 22),
                  ),
                  value: municipalDropDownValue,
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
                  onChanged: (String newValue) {
                    setState(() {
                      municipalDropDownValue = newValue;
                    });
                  },
                  items:
                      municipals.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            );
          }
          return Flexible(child: Center(child: CircularProgressIndicator()));
        });
  }
}
