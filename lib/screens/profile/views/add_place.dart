import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/drop_down_municipal_bloc/bloc.dart';
import 'package:tahwisa/blocs/drop_down_state_bloc/bloc.dart';
import 'package:tahwisa/blocs/image_picker_bloc/bloc.dart';
import 'package:tahwisa/blocs/location_picker_bloc/bloc.dart';
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
  String path;
  PlaceUploadBloc _placeUploadBloc;
  PlaceRepository _placeRepository;
  DropDownsRepository _dropDownsRepository;
  DropDownStateBloc _dropDownStateBloc;
  DropDownsMunicipalBloc _dropDownsMunicipalBloc;
  ImagePickerBloc _imagePickerBloc;
  LocationPickerBloc _locationPickerBloc;
  TextEditingController _titleEditingController;
  TextEditingController _descriptionEditingController;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        floatingActionButton: SizedBox(
          width: 80,
          height: 80,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onPressed: () async {
              print("pressed***********************");
              // var municipal = await _dropDownsMunicipalBloc.selectedMunicipal.first;
              // print(municipal);
              var errors = [];
              if (_formKey.currentState.validate()) {
                print("form valid***********************");
                var municipal =
                    await _dropDownsMunicipalBloc.selectedMunicipal.first;
                if (municipal != null) {
                  if (_imagePickerBloc.state is ImagesPicked) {
                    print("image ***********************");
                    if (_locationPickerBloc.state is LocationPicked) {
                      print("location ***********************");
                      final image = _imagePickerBloc.state as ImagesPicked;
                      final location =
                          _locationPickerBloc.state as LocationPicked;
                      _placeUploadBloc.add(UploadPlaceButtonPressed(
                        title: _titleEditingController.value.text,
                        description: _descriptionEditingController.value.text,
                        picture: image.images,
                        latitude: location.latitude,
                        longitude: location.longitude,
                        municipalID: municipal.id,
                      ));
                    } else {
                      print("please pick location ***********************");
                    }
                  } else {
                    print("please pick images***********************");
                  }
                } else {
                  print("municipal not chosen ***********************");
                }
              }
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
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  SizedBox(height: height * 0.05),
                  Align(
                    alignment: Alignment.topCenter,
                    child: BlocBuilder(
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
                  ),
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
                                  onChanged: _dropDownsMunicipalBloc
                                      .selectedStateEvent,
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
                  SizedBox(height: height * 0.05),
                  TextFormField(
                    controller: _titleEditingController,
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
                            borderSide: BorderSide(
                                color: MyColors.greenBorder, width: 1.5)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: MyColors.greenBorder, width: 2.5))),
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
                          controller: _descriptionEditingController,
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
                          margin: EdgeInsets.symmetric(
                              horizontal: 19, vertical: 12),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => _imagePickerBloc.add(PickImages()),
                                child: Row(
                                  children: [
                                    Icon(Icons.photo_library_rounded,
                                        color: MyColors.darkBlue, size: 32),
                                    SizedBox(width: width * 0.02),
                                    Text("Pictures",
                                        style: TextStyle(
                                            color: MyColors.darkBlue,
                                            fontSize: 18)),
                                  ],
                                ),
                              ),
                              Spacer(),
                              BlocBuilder<LocationPickerBloc,
                                  LocationPickerState>(
                                builder: (context, state) {
                                  if (state is LocationPicked) {
                                    return FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text("lat ${state.latitude} "),
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: () =>
                                        _locationPickerBloc.add(PickLocation()),
                                    child: Row(
                                      children: [
                                        Icon(CupertinoIcons.location_solid,
                                            color: MyColors.darkBlue, size: 32),
                                        SizedBox(width: width * 0.02),
                                        Text("Location",
                                            style: TextStyle(
                                                color: MyColors.darkBlue,
                                                fontSize: 18)),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ]),
              )),
        ));
  }

  @override
  void initState() {
    super.initState();
    _titleEditingController = TextEditingController();
    _descriptionEditingController = TextEditingController();
    _dropDownsRepository = DropDownsRepository();
    _dropDownsMunicipalBloc =
        DropDownsMunicipalBloc(dropDownsRepository: _dropDownsRepository);
    _dropDownStateBloc = DropDownStateBloc(
        dropDownsRepository: _dropDownsRepository,
        municipalBloc: _dropDownsMunicipalBloc);
    _placeRepository = RepositoryProvider.of<PlaceRepository>(context);
    _placeUploadBloc = PlaceUploadBloc(
      placeRepository: _placeRepository,
    );
    _imagePickerBloc = ImagePickerBloc();
    _locationPickerBloc = BlocProvider.of<LocationPickerBloc>(context);
  }

  @override
  void dispose() {
    _placeUploadBloc.close();
    _dropDownsMunicipalBloc.close();
    super.dispose();
  }
}
