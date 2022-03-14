import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/app/blocs/image_picker_bloc/bloc.dart';
import 'package:tahwisa/app/blocs/location_picker_bloc/bloc.dart';
import 'package:tahwisa/app/style/my_colors.dart';

class DescriptionPicturesLocationInput extends StatelessWidget {
  const DescriptionPicturesLocationInput({
    Key? key,
    required this.width,
    required TextEditingController descriptionEditingController,
    required this.height,
    required ImagePickerBloc imagePickerBloc,
    required LocationPickerBloc locationPickerBloc,
  })  : _descriptionEditingController = descriptionEditingController,
        _imagePickerBloc = imagePickerBloc,
        _locationPickerBloc = locationPickerBloc,
        super(key: key);

  final double width;
  final TextEditingController _descriptionEditingController;
  final double height;
  final ImagePickerBloc _imagePickerBloc;
  final LocationPickerBloc _locationPickerBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: MyColors.greenBorder,
          ),
          borderRadius: BorderRadius.circular(width * 0.03),
          color: MyColors.white),
      child: Column(
        children: [
          TextFormField(
            controller: _descriptionEditingController,
            maxLines: 5,
            decoration: InputDecoration(
                fillColor: MyColors.white,
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
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 1.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 2.5))),
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
                  onTap: () => _imagePickerBloc.add(PickImages()),
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
                BlocBuilder<LocationPickerBloc, LocationPickerState>(
                  builder: (context, state) {
                    if (state is LocationPicked) {
                      return FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text("lat ${state.latitude} "),
                      );
                    }
                    return GestureDetector(
                      onTap: () => _locationPickerBloc.add(PickLocation()),
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
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
