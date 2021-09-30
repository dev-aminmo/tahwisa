import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/drop_down_municipal_bloc/bloc.dart';
import 'package:tahwisa/blocs/drop_down_state_bloc/bloc.dart';
import 'package:tahwisa/blocs/image_picker_bloc/bloc.dart';
import 'package:tahwisa/blocs/location_picker_bloc/bloc.dart';
import 'package:tahwisa/blocs/place_upload_bloc/bloc.dart';
import 'package:tahwisa/repositories/dropdowns_repository.dart';
import 'package:tahwisa/repositories/models/tag.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/repositories/tag_repository.dart';
import 'package:tahwisa/screens/profile/widgets/add_place/widgets.dart';
import 'package:tahwisa/style/my_colors.dart';

class AddPlace extends StatefulWidget {
  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  PlaceUploadBloc _placeUploadBloc;
  PlaceRepository _placeRepository;
  TagRepository _tagRepository;
  DropDownsRepository _dropDownsRepository;
  DropDownStateBloc _dropDownStateBloc;
  DropDownsMunicipalBloc _dropDownsMunicipalBloc;
  ImagePickerBloc _imagePickerBloc;
  LocationPickerBloc _locationPickerBloc;
  TextEditingController _titleEditingController;
  TextEditingController _descriptionEditingController;
  final _formKey = GlobalKey<FormState>();
  List<Tag> _selectedTags;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        floatingActionButton: FAB(
            formKey: _formKey,
            dropDownsMunicipalBloc: _dropDownsMunicipalBloc,
            imagePickerBloc: _imagePickerBloc,
            locationPickerBloc: _locationPickerBloc,
            placeUploadBloc: _placeUploadBloc,
            titleEditingController: _titleEditingController,
            descriptionEditingController: _descriptionEditingController),
        backgroundColor: MyColors.white,
        resizeToAvoidBottomInset: false,
        //  resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  SizedBox(height: height * 0.1),
                  TagPicker(
                      selectedTags: _selectedTags,
                      tagRepository: _tagRepository),
                  SizedBox(height: height * 0.05),
                  StateDropdown(dropDownStateBloc: _dropDownStateBloc),
                  MunicipalDropDown(
                      dropDownsMunicipalBloc: _dropDownsMunicipalBloc),
                  SizedBox(height: height * 0.05),
                  TitleTextField(
                      titleEditingController: _titleEditingController),
                  SizedBox(height: height * 0.05),
                  DescriptionPicturesLocationInput(
                      width: width,
                      descriptionEditingController:
                          _descriptionEditingController,
                      height: height,
                      imagePickerBloc: _imagePickerBloc,
                      locationPickerBloc: _locationPickerBloc),
                  SizedBox(height: height * 0.2),
                  Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                  )
                ]),
              )),
        ));
  }

  @override
  void initState() {
    super.initState();
    _selectedTags = [];
    _titleEditingController = TextEditingController();
    _descriptionEditingController = TextEditingController();
    _dropDownsRepository = DropDownsRepository();
    _tagRepository = TagRepository();
    _dropDownsMunicipalBloc =
        DropDownsMunicipalBloc(dropDownsRepository: _dropDownsRepository);
    _dropDownStateBloc = DropDownStateBloc(
        dropDownsRepository: _dropDownsRepository,
        municipalBloc: _dropDownsMunicipalBloc)
      ..add(FetchStates());
    _placeRepository = RepositoryProvider.of<PlaceRepository>(context);
    _placeUploadBloc = PlaceUploadBloc(
      placeRepository: _placeRepository,
    );
    _imagePickerBloc = ImagePickerBloc();
    _locationPickerBloc = BlocProvider.of<LocationPickerBloc>(context);
  }

  @override
  void dispose() {
    _selectedTags.clear();
    _titleEditingController.dispose();
    _descriptionEditingController.dispose();
    _placeUploadBloc.close();
    _dropDownsMunicipalBloc.close();
    _imagePickerBloc.close();
    _dropDownStateBloc.close();
    _locationPickerBloc.close();
    super.dispose();
  }
}
