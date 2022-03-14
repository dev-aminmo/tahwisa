import 'package:flutter/material.dart';
import 'package:queen_validators/queen_validators.dart';
import 'package:tahwisa/app/screens/profile/widgets/add_place/title_text_field.dart';
import 'package:tahwisa/app/screens/profile/widgets/hide_keyboard_ontap.dart';
import 'package:tahwisa/app/style/my_colors.dart';

class TitleDescriptionPage extends StatefulWidget {
  final TextEditingController? titleEditingController;
  final TextEditingController? descriptionEditingController;
  final formKey;

  TitleDescriptionPage({
    required this.titleEditingController,
    required this.descriptionEditingController,
    required this.formKey,
  });

  @override
  _TitleDescriptionPageState createState() => _TitleDescriptionPageState();
}

class _TitleDescriptionPageState extends State<TitleDescriptionPage>
    with AutomaticKeepAliveClientMixin<TitleDescriptionPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HideKeyboardOnTap(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: widget.formKey,
            child: Column(
              children: [
                const SizedBox(height: 48),
                TitleTextField(
                  titleEditingController: widget.titleEditingController,
                  onEditingComplete: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  validator: qValidator([
                    IsRequired('title is required'),
                    MaxLength(191),
                    MinLength(5),
                  ]),
                ),
                const SizedBox(height: 36),
                TextFormField(
                  controller: widget.descriptionEditingController,
                  maxLines: 5,
                  decoration: buildInputDecoration(),
                  validator: qValidator([
                    IsOptional(),
                    MaxLength(2000),
                    //  MinLength(3),
                  ]),
                  cursorColor: MyColors.lightGreen,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: MyColors.darkBlue,
                      fontSize: 16),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
        fillColor: MyColors.white,
        filled: true,
        hintText: "Introduce this place (optional)",
        counterText: "",
        errorStyle: const TextStyle(fontSize: 16),
        hintStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Color(0xff8FA0B3),
            fontSize: 16),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: MyColors.greenBorder, width: 1.5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: MyColors.greenBorder, width: 2.5)));
  }
}
