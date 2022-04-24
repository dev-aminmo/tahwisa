import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queen_validators/queen_validators.dart';
import 'package:tahwisa/src/blocs/drop_down_municipal_bloc/bloc.dart';
import 'package:tahwisa/src/blocs/drop_down_state_bloc/bloc.dart';
import 'package:tahwisa/src/blocs/image_picker_bloc/bloc.dart';
import 'package:tahwisa/src/blocs/place_upload_bloc/bloc.dart';
import 'package:tahwisa/src/cubits/place_details_cubit/place_details_cubit.dart';
import 'package:tahwisa/src/repositories/dropdowns_repository.dart';
import 'package:tahwisa/src/repositories/place_repository.dart';
import 'package:tahwisa/src/screens/profile/widgets/add_place/widgets.dart';
import 'package:tahwisa/src/style/my_colors.dart';

class UpdatePlaceScreen extends StatefulWidget {
  static const String routeName = '/place/update';

  static Route route({var placeId}) {
    return MaterialPageRoute(
      builder: (_) => UpdatePlaceScreen(placeId: placeId),
      settings: RouteSettings(name: routeName),
    );
  }

  final placeId;
  const UpdatePlaceScreen({this.placeId});

  @override
  _UpdatePlaceScreenState createState() => _UpdatePlaceScreenState();
}

class _UpdatePlaceScreenState extends State<UpdatePlaceScreen> {
  PlaceDetailsCubit? _placeDetailsCubit;
  DropDownStateBloc? _dropDownStateBloc;
  DropDownsMunicipalBloc? _dropDownsMunicipalBloc;
  TextEditingController? _titleEditingController;
  TextEditingController? _descriptionEditingController;
  ImagePickerBloc? _imagePickerBloc;
  PlaceUploadBloc? _placeUploadBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _placeDetailsCubit = PlaceDetailsCubit(
        placeID: widget.placeId,
        placeRepository: context.read<PlaceRepository>());
    _titleEditingController = TextEditingController();
    _descriptionEditingController = TextEditingController();
    _placeDetailsCubit = PlaceDetailsCubit(
        placeID: widget.placeId,
        placeRepository: context.read<PlaceRepository>());
    _imagePickerBloc = ImagePickerBloc();
    DropDownsRepository _dropDownsRepository =
        context.read<DropDownsRepository>();
    _dropDownsMunicipalBloc =
        DropDownsMunicipalBloc(dropDownsRepository: _dropDownsRepository);
    _dropDownStateBloc = DropDownStateBloc(
        dropDownsRepository: _dropDownsRepository,
        municipalBloc: _dropDownsMunicipalBloc)
      ..add(FetchStates());

    _placeUploadBloc = PlaceUploadBloc(
      placeRepository: context.read<PlaceRepository>(),
    );
  }

  @override
  void dispose() {
    _placeDetailsCubit!.close();

    _titleEditingController!.dispose();
    _descriptionEditingController!.dispose();
    _dropDownsMunicipalBloc!.close();
    _dropDownStateBloc!.close();
    _imagePickerBloc!.close();
    _placeUploadBloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update place')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            BlocListener<PlaceUploadBloc, PlaceUploadState>(
              bloc: _placeUploadBloc,
              listener: (context, state) {
                if (state is PlaceUploadLoading) {
                  showDialog<void>(
                      context: context,
                      useRootNavigator: false,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) => WillPopScope(
                          onWillPop: () async => false,
                          child: AlertDialog(
                              backgroundColor: Colors.white,
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [CircularProgressIndicator()]))));
                }
                if (state is PlaceUploadSuccess) {
                  Navigator.of(context).pop();
                  showDialog<void>(
                      context: context,
                      useRootNavigator: false,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Colors.white,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle_outlined,
                                color: Colors.green,
                                size: 72,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Place updated successfully",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22,
                                    color: MyColors.darkBlue),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "your publication will be reviewed by an admin to valid it",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: MyColors.gray),
                              )
                            ],
                          ))).then((value) {
                    //Todo clean
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                }
                if (state is PlaceUploadFailure) {
                  Navigator.of(context).pop();
                  showDialog<void>(
                      context: context,
                      useRootNavigator: false,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Colors.white,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red,
                                size: 72,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "An error has occurred",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                  fontSize: 18,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "You can retry",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                    fontSize: 16,
                                    color: MyColors.darkBlue),
                              ),
                            ],
                          )));
                }
              },
              child: BlocConsumer<PlaceDetailsCubit, PlaceDetailsState>(
                  bloc: _placeDetailsCubit,
                  listener: (context, state) {
                    if (state is PlaceDetailsSuccess) {
                      final _titleValue = state.place!.title;
                      final _descriptionValue = state.place!.description;
                      _titleEditingController!.value = TextEditingValue(
                        text: _titleValue,
                        selection: TextSelection.fromPosition(
                          TextPosition(offset: _titleValue.length),
                        ),
                      );
                      _descriptionEditingController!.value = TextEditingValue(
                        text: _descriptionValue,
                        selection: TextSelection.fromPosition(
                          TextPosition(offset: _descriptionValue.length),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is PlaceDetailsSuccess) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TitleTextField(
                              titleEditingController: _titleEditingController,
                              onEditingComplete: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
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
                              controller: _descriptionEditingController,
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
                            SizedBox(
                              height: 36,
                            ),
                            BlocBuilder<ImagePickerBloc, ImagePickerState>(
                                bloc: _imagePickerBloc,
                                builder: (context, imagePickerState) {
                                  if (imagePickerState is ImagesPicked) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GridView.builder(
                                            physics: BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                imagePickerState.images.length,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    crossAxisSpacing: 8,
                                                    childAspectRatio: 1.4,
                                                    mainAxisSpacing: 16),
                                            itemBuilder: (context, index) {
                                              return Image(
                                                image: ResizeImage(
                                                  FileImage(
                                                    imagePickerState
                                                        .images[index],
                                                  ),
                                                  height: 100,
                                                ),
                                                fit: BoxFit.cover,
                                              );
                                            }),
                                        SizedBox(height: 16),
                                        MaterialButton(
                                          color: MyColors.lightGreen,
                                          onPressed: () {
                                            _imagePickerBloc!.add(PickImages());
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            child: Text(
                                              "Re-Pick Images",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: () =>
                                        _imagePickerBloc!.add(PickImages()),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GridView.builder(
                                            physics: BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                state.place!.pictures?.length,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    crossAxisSpacing: 8,
                                                    childAspectRatio: 1.4,
                                                    mainAxisSpacing: 16),
                                            itemBuilder: (context, index) {
                                              return Image.network(
                                                state.place!.pictures![index]!
                                                    .replaceFirstMapped(
                                                        "image/upload/",
                                                        (match) =>
                                                            "image/upload/w_150,f_auto/"),
                                                height: 100,
                                                fit: BoxFit.cover,
                                              );
                                            }),
                                        SizedBox(height: 8),
                                        MaterialButton(
                                          color: MyColors.lightGreen,
                                          onPressed: () {
                                            _imagePickerBloc!.add(PickImages());
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              "Pick Pictures",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            SizedBox(
                              height: 16,
                            ),
                            StateDropdown(
                              dropDownStateBloc: _dropDownStateBloc,
                              hint: state.place!.state,
                            ),
                            MunicipalDropDown(
                              dropDownsMunicipalBloc: _dropDownsMunicipalBloc,
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            MaterialButton(
                              minWidth: double.infinity,
                              color: MyColors.darkBlue,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  _placeUploadBloc!.add(
                                      UpdatePlaceButtonPressed(
                                          title: _titleEditingController!
                                              .value.text,
                                          description:
                                              _descriptionEditingController!
                                                  .value.text,
                                          pictures: (_imagePickerBloc!.state
                                                  is ImagesPicked)
                                              ? (_imagePickerBloc!.state
                                                      as ImagesPicked)
                                                  .images
                                              : null,
                                          municipalID: (_dropDownsMunicipalBloc!
                                                      .currentMunicipal !=
                                                  null)
                                              ? _dropDownsMunicipalBloc!
                                                  .currentMunicipal?.id
                                              : null,
                                          placeId: state.place!.id));
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  "Update Place",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                          ],
                        ),
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ],
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
