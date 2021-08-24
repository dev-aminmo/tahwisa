import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/style/my_colors.dart';

class SearchForPlacesTypeAheadField extends StatelessWidget {
  const SearchForPlacesTypeAheadField({
    Key key,
    @required TextEditingController searchEditingController,
    @required this.width,
    @required this.height,
    @required this.onEditingComplete,
  })  : _searchEditingController = searchEditingController,
        super(key: key);

  final TextEditingController _searchEditingController;
  final double width;
  final double height;
  final Function onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      hideOnEmpty: true,
      hideOnLoading: true,

      //Todo  hideOnError: true, in production
      textFieldConfiguration: TextFieldConfiguration(
        onEditingComplete: onEditingComplete,
        controller: _searchEditingController,
        //autofocus: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
              left: width * 0.07,
              top: height * 0.025,
              bottom: height * 0.025,
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
                borderRadius: BorderRadius.circular(width * 0.1),
                borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.8), width: 1.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(width * 0.1),
                borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.8), width: 2.5))),
        cursorColor: MyColors.lightGreen,
        style: DefaultTextStyle.of(context).style.copyWith(
            color: MyColors.darkBlue,
            fontWeight: FontWeight.w400,
            fontSize: 20),
      ),
      suggestionsCallback: (pattern) async {
        await Future.delayed(Duration(milliseconds: 150));
        return (pattern.length > 1)
            ? await PlaceRepository().search(pattern)
            : [];
      },
      itemBuilder: (context, suggestion) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(width: 20),
              Text(suggestion.title),
              SizedBox(width: 5),
            ],
          ),
        );
      },
      onSuggestionSelected: (suggestion) {
        /*Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductPage(product: suggestion)));
          */
        _searchEditingController.text = suggestion.title;
        //   print("hello");
      },
    );
  }
}
