import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tahwisa/blocs/drop_down_municipal_bloc/bloc.dart';
import 'package:tahwisa/blocs/image_picker_bloc/bloc.dart';
import 'package:tahwisa/blocs/location_picker_bloc/bloc.dart';
import 'package:tahwisa/blocs/place_upload_bloc/bloc.dart';

class FAB extends StatelessWidget {
  const FAB({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required DropDownsMunicipalBloc dropDownsMunicipalBloc,
    @required ImagePickerBloc imagePickerBloc,
    @required LocationPickerBloc locationPickerBloc,
    @required PlaceUploadBloc placeUploadBloc,
    @required TextEditingController titleEditingController,
    @required TextEditingController descriptionEditingController,
  })  : _formKey = formKey,
        _dropDownsMunicipalBloc = dropDownsMunicipalBloc,
        _imagePickerBloc = imagePickerBloc,
        _locationPickerBloc = locationPickerBloc,
        _placeUploadBloc = placeUploadBloc,
        _titleEditingController = titleEditingController,
        _descriptionEditingController = descriptionEditingController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final DropDownsMunicipalBloc _dropDownsMunicipalBloc;
  final ImagePickerBloc _imagePickerBloc;
  final LocationPickerBloc _locationPickerBloc;
  final PlaceUploadBloc _placeUploadBloc;
  final TextEditingController _titleEditingController;
  final TextEditingController _descriptionEditingController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  final location = _locationPickerBloc.state as LocationPicked;
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
          /*final image = _imagePickerBloc.state as ImagesPicked;
          _placeUploadBloc.add(UploadPlaceButtonPressed(
            title: "hello",
            description: "Mister johnson",
            picture: image.images,
            latitude: 4.1,
            longitude: 3.1,
            municipalID: 24,
          ));*/
        },
        child: Icon(
          Icons.send,
          size: 36,
        ),
      ),
    );
  }
}
