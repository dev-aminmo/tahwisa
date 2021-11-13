import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:tahwisa/blocs/drop_down_municipal_bloc/bloc.dart';
import 'package:tahwisa/blocs/drop_down_state_bloc/bloc.dart';
import 'package:tahwisa/blocs/image_picker_bloc/bloc.dart';
import 'package:tahwisa/blocs/location_picker_bloc/bloc.dart';
import 'package:tahwisa/blocs/place_upload_bloc/bloc.dart';
import 'package:tahwisa/repositories/dropdowns_repository.dart';
import 'package:tahwisa/repositories/models/tag.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/repositories/tag_repository.dart';
import 'package:tahwisa/style/my_colors.dart';

import './views/views.dart';

class AddPlaceStepper extends StatefulWidget {
  const AddPlaceStepper({Key key}) : super(key: key);
  @override
  _AddPlaceStepperState createState() {
    return _AddPlaceStepperState();
  }
}

class _AddPlaceStepperState extends State<AddPlaceStepper> {
  var _children;
  int _position = 0;
  PageController _pageController;

  PlaceUploadBloc _placeUploadBloc;
  PlaceRepository _placeRepository;
  TagRepository _tagRepository;
  DropDownStateBloc _dropDownStateBloc;
  DropDownsMunicipalBloc _dropDownsMunicipalBloc;
  ImagePickerBloc _imagePickerBloc;
  LocationPickerBloc _locationPickerBloc;
  TextEditingController _titleEditingController;
  TextEditingController _descriptionEditingController;
  final _formKey = GlobalKey<FormState>();
  List<Tag> _selectedTags;

  @override
  void initState() {
    _selectedTags = [];
    _titleEditingController = TextEditingController();
    _descriptionEditingController = TextEditingController();
    DropDownsRepository _dropDownsRepository =
        context.read<DropDownsRepository>();
    _tagRepository = TagRepository();
    _dropDownsMunicipalBloc =
        DropDownsMunicipalBloc(dropDownsRepository: _dropDownsRepository);
    _dropDownStateBloc = DropDownStateBloc(
        dropDownsRepository: _dropDownsRepository,
        municipalBloc: _dropDownsMunicipalBloc)
      ..add(FetchStates());
    _placeRepository = RepositoryProvider.of<PlaceRepository>(context);
    _placeUploadBloc = PlaceUploadBloc(
      placeRepository: _placeRepository,
    );
    _imagePickerBloc = ImagePickerBloc();
    _locationPickerBloc = BlocProvider.of<LocationPickerBloc>(context);
    _pageController = PageController();
    _children = [
      TitleDescriptionPage(
          titleEditingController: _titleEditingController,
          descriptionEditingController: _descriptionEditingController,
          formKey: _formKey),
      LocationPage(
        dropDownStateBloc: _dropDownStateBloc,
        dropDownsMunicipalBloc: _dropDownsMunicipalBloc,
        locationPickerBloc: _locationPickerBloc,
      ),
      TagsImagesPage(
          tagRepository: _tagRepository,
          imagePickerBloc: _imagePickerBloc,
          selectedTags: _selectedTags)
    ];

    super.initState();
  }

  @override
  void dispose() {
    _selectedTags.clear();
    _titleEditingController.dispose();
    _descriptionEditingController.dispose();
    _placeUploadBloc.close();
    _dropDownsMunicipalBloc.close();
    _imagePickerBloc.close();
    _dropDownStateBloc.close();
    _locationPickerBloc.close();
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Your post will be discarded'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          // appBar: AppBar(title: const Text('Add place')),
          body: BlocListener<PlaceUploadBloc, PlaceUploadState>(
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
                              "Place added successfully",
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
                  Navigator.of(context, rootNavigator: true).pop();
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
            child: Column(
              children: [
                buildPageView(),
                KeyboardVisibilityBuilder(
                  builder: (context, isKeyboardVisible) => (isKeyboardVisible)
                      ? const SizedBox()
                      : buildBackAndNextButtons(),
                ),
                const SizedBox(height: 4)
              ],
            ),
          )),
    );
  }

  Padding buildBackAndNextButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 8, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
            onPressed: _canGoBack() ? _precedentPage : null,
            child: const Text('BACK', style: TextStyle(color: MyColors.gray)),
          ),
          MaterialButton(
            onPressed: _nextPage,
            color: MyColors.darkBlue,
            child: const Text(
              'NEXT',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildPageView() {
    return Expanded(
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        children: _children ?? [],
        onPageChanged: _positionChanged,
        controller: _pageController,
      ),
    );
  }

  void _positionChanged(position) {
    setState(() {
      _position = position;
    });
  }

  bool _canGoBack() {
    return _position > 0;
  }

  void showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text('$error')),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _nextPage() {
    FocusScope.of(context).requestFocus(FocusNode());

    void _goToNextPage() {
      _pageController.animateToPage(++_position,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }

    switch (_position) {
      case 0:
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          _goToNextPage();
        }
        break;
      case 1:
        if (_dropDownsMunicipalBloc.currentMunicipal == null) {
          showErrorSnackBar("Select the state and municipal of the place");
        } else {
          if (_locationPickerBloc.state is! LocationPicked) {
            showErrorSnackBar("Pick Location of the place");
          } else {
            _goToNextPage();
          }
        }
        break;
      case 2:
        if (_imagePickerBloc.state is! ImagesPicked) {
          showErrorSnackBar("Pick images of the place");
        } else {
          _placeUploadBloc.add(UploadPlaceButtonPressed(
              title: _titleEditingController.value.text,
              description: _descriptionEditingController.value.text,
              picture: (_imagePickerBloc.state as ImagesPicked).images,
              latitude: (_locationPickerBloc.state as LocationPicked).latitude,
              longitude:
                  (_locationPickerBloc.state as LocationPicked).longitude,
              municipalID: _dropDownsMunicipalBloc.currentMunicipal.id,
              tags: _selectedTags));
        }
        break;
      default:
        break;
    }
  }

  void _precedentPage() {
    if (_canGoBack()) {
      _pageController.animateToPage(--_position,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }
}
