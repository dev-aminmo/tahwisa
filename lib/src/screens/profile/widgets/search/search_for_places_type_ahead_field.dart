import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tahwisa/src/repositories/models/place.dart';
import 'package:tahwisa/src/repositories/models/tag.dart';
import 'package:tahwisa/src/style/my_colors.dart';

class SearchForPlacesTypeAheadField extends StatelessWidget {
  const SearchForPlacesTypeAheadField({
    Key? key,
    required TextEditingController? searchEditingController,
    required this.width,
    required this.height,
    required this.onEditingComplete,
    required this.onSuggestionSelected,
    required this.suggestionsCallback,
  })  : _searchEditingController = searchEditingController,
        super(key: key);

  final TextEditingController? _searchEditingController;
  final double? width;
  final double? height;
  final Function onEditingComplete;
  final void Function(dynamic) onSuggestionSelected;
  final Function suggestionsCallback;

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
        hideOnEmpty: true,
        hideOnLoading: true,
        debounceDuration: const Duration(milliseconds: 150),
        hideOnError: true,
        textFieldConfiguration: TextFieldConfiguration(
          textInputAction: TextInputAction.search,
          onEditingComplete: onEditingComplete as void Function()?,
          controller: _searchEditingController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: width! * 0.07,
                top: height! * 0.025,
                bottom: height! * 0.025,
              ),
              hintText: "search for a place",
              counterText: "",
              errorStyle: TextStyle(fontSize: 16),
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff8FA0B3),
                  fontSize: 20),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(width! * 0.1),
                  borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.8), width: 1.5)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(width! * 0.1),
                  borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.8), width: 2.5))),
          cursorColor: MyColors.lightGreen,
          style: DefaultTextStyle.of(context).style.copyWith(
              color: MyColors.darkBlue,
              fontWeight: FontWeight.w400,
              fontSize: 20),
        ),
        suggestionsCallback: (pattern) async {
          return await suggestionsCallback(pattern);
        },
        itemBuilder: (context, dynamic suggestion) {
          if (suggestion is Place) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.place),
                  SizedBox(width: 20),
                  Flexible(
                      child: Text(
                    suggestion.title ?? '',
                    softWrap: true,
                  )),
                  SizedBox(width: 5),
                ],
              ),
            );
          }
          if (suggestion is Tag) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.tag),
                  SizedBox(width: 20),
                  Flexible(
                      child: Text(
                    suggestion.name ?? '',
                    softWrap: true,
                  )),
                  SizedBox(width: 5),
                ],
              ),
            );
          }
          return SizedBox();
        },
        onSuggestionSelected: onSuggestionSelected);
  }
}
