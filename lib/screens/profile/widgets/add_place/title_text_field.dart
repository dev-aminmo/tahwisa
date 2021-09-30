import 'package:flutter/material.dart';
import 'package:tahwisa/style/my_colors.dart';

class TitleTextField extends StatelessWidget {
  const TitleTextField(
      {Key key,
      @required TextEditingController titleEditingController,
      String hint = "enter title of the place",
      Function onEditingComplete,
      var validator})
      : _titleEditingController = titleEditingController,
        hint = hint,
        onEditingComplete = onEditingComplete,
        validator = validator,
        super(key: key);

  final TextEditingController _titleEditingController;
  final String hint;
  final Function onEditingComplete;
  final validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _titleEditingController,
      onEditingComplete: onEditingComplete,
      maxLines: 2,
      keyboardType: TextInputType.text,
      validator: validator,
      decoration: InputDecoration(
          fillColor: MyColors.white,
          filled: true,
          hintText: hint,
          counterText: "",
          errorStyle: TextStyle(fontSize: 16),
          hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xff8FA0B3),
              fontSize: 16),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: MyColors.greenBorder, width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: MyColors.greenBorder, width: 2.5))),
      cursorColor: MyColors.lightGreen,
      style: TextStyle(
          fontWeight: FontWeight.w400, color: MyColors.darkBlue, fontSize: 20),
    );
  }
}
