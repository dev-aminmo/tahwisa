import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/screens/profile/widgets/hide_keyboard_ontap.dart';
import 'package:tahwisa/style/my_colors.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return HideKeyboardOnTap(
        child: ListView(
      // shrinkWrap: true,
      children: [
        SizedBox(height: height * 0.05),
        Container(
          margin: EdgeInsets.only(left: width * 0.02),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: TypeAheadField(
                hideOnEmpty: true,
                hideOnLoading: true,
                textFieldConfiguration: TextFieldConfiguration(
                  autofocus: true,
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
                              color: MyColors.lightGreen, width: 1.5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(width * 0.03),
                          borderSide: BorderSide(
                              color: MyColors.lightGreen, width: 2.5))),
                  cursorColor: MyColors.lightGreen,
                  style: DefaultTextStyle.of(context).style.copyWith(
                      color: MyColors.darkBlue,
                      fontWeight: FontWeight.w400,
                      fontSize: 20),
                ),
                suggestionsCallback: (pattern) async {
                  await Future.delayed(Duration(milliseconds: 250));
                  return (pattern.length > 1)
                      ? await PlaceRepository().search(pattern)
                      : [];
                },
                itemBuilder: (context, suggestion) {
                  return Row(
                    children: [
                      Image.network(
                          suggestion.pictures[0].replaceFirstMapped(
                              "image/upload/",
                              (match) =>
                                  "image/upload/w_${(width * 0.1).round()},f_auto/"),
                          height: height * 0.1,
                          fit: BoxFit.cover,
                          width: width * 0.1),
                      SizedBox(width: 20),
                      Text(suggestion.title),
                      SizedBox(width: 5),
                    ],
                  );
                },
                onSuggestionSelected: (suggestion) {
                  /*Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductPage(product: suggestion)));
          */
                  print("hello");
                },
              )),
              RawMaterialButton(
                onPressed: () {},
                padding: EdgeInsets.all(12),
                fillColor: MyColors.lightGreen,
                child: Icon(Icons.search, color: Colors.white),
                shape: CircleBorder(),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.025),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("14 places found",
                  style: TextStyle(
                    color: MyColors.darkBlue,
                  )),
              Expanded(
                child: SizedBox(),
              ),
              Row(
                children: [
                  Text("Filters",
                      style: TextStyle(
                        color: MyColors.darkBlue,
                      )),
                  Icon(
                    Icons.filter_list_sharp,
                    color: MyColors.lightGreen,
                  )
                ],
              )
            ],
          ),
        ),

        /*  SingleChildScrollView(
          child: ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 20,
            itemBuilder: (ctx, index) {
              return PlaceCard(
                height: height,
                width: width,
                index: index,
              );
            },
          ),
        )
      */
      ],
    ));
  }
}
