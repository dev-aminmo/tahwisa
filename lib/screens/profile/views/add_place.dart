import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tahwisa/screens/auth/widgets/auth_input.dart';
import 'package:tahwisa/style/my_colors.dart';
import 'dart:convert';

class AddPlace extends StatefulWidget {
  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: SizedBox(
        width: width * 0.2,
        height: width * 0.2,
        child: FloatingActionButton(
          backgroundColor: MyColors.darkBlue,
          onPressed: () {},
          child: Icon(
            Icons.send,
            size: 36,
          ),
        ),
      ),
      backgroundColor: MyColors.white,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Column(
          children: [
            SizedBox(height: height * 0.05),
            DropDowns(height, width),
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
          ],
        ),
      ),
    );
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
