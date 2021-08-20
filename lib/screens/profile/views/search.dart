import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/screens/profile/widgets/search_input.dart';
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
    return ListView(
      // shrinkWrap: true,
      children: [
        SizedBox(height: height * 0.05),
        Container(
          margin: EdgeInsets.only(left: width * 0.02),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: SearchInput(height, width)),
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
        TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              decoration: InputDecoration(border: OutlineInputBorder())),
          suggestionsCallback: (pattern) async {
            await Future.delayed(Duration(milliseconds: 250));
            return (pattern.length > 1)
                ? await PlaceRepository().search(pattern)
                : [];
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text(suggestion.title),
              // subtitle: Text('\$${suggestion['price']}'),
            );
          },
          onSuggestionSelected: (suggestion) {
            /*Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductPage(product: suggestion)));
          */
            print("hello");
          },
        )
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
    );
  }
}
