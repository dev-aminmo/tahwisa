import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queen_validators/queen_validators.dart';
import 'package:tahwisa/blocs/drop_down_municipal_bloc/bloc.dart';
import 'package:tahwisa/blocs/drop_down_state_bloc/bloc.dart';
import 'package:tahwisa/blocs/image_picker_bloc/bloc.dart';
import 'package:tahwisa/blocs/notification_bloc/notification_bloc.dart';
import 'package:tahwisa/blocs/place_upload_bloc/bloc.dart';
import 'package:tahwisa/cubits/place_details_cubit/place_details_cubit.dart';
import 'package:tahwisa/cubits/refuse_place_messages/refuse_place_messages_cubit.dart';
import 'package:tahwisa/repositories/dropdowns_repository.dart';
import 'package:tahwisa/repositories/models/notification.dart' as My;
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/repositories/refuse_place_message_repository.dart';
import 'package:tahwisa/screens/profile/widgets/add_place/widgets.dart';
import 'package:tahwisa/style/my_colors.dart';

class NotificationPlaceRefused extends StatefulWidget {
  static const String routeName = '/notification/place_refused';

  static Route route(
      {@required NotificationBloc notificationBloc,
      My.Notification notification}) {
    return MaterialPageRoute(
      builder: (_) => NotificationPlaceRefused(
        notificationBloc: notificationBloc,
        notification: notification,
      ),
      settings: RouteSettings(name: routeName),
    );
  }

  final NotificationBloc notificationBloc;
  final My.Notification notification;

  const NotificationPlaceRefused({this.notificationBloc, this.notification});

  @override
  _NotificationPlaceRefusedState createState() =>
      _NotificationPlaceRefusedState();
}

class _NotificationPlaceRefusedState extends State<NotificationPlaceRefused> {
  RefusePlaceMessagesCubit _refusePlaceMessagesCubit;
  DropDownStateBloc _dropDownStateBloc;
  DropDownsMunicipalBloc _dropDownsMunicipalBloc;
  PlaceDetailsCubit _placeDetailsCubit;
  TextEditingController _titleEditingController;
  TextEditingController _descriptionEditingController;
  ImagePickerBloc _imagePickerBloc;
  PlaceUploadBloc _placeUploadBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlaceUploadBloc, PlaceUploadState>(
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
      child: Scaffold(
        body: Center(
          child:
              BlocBuilder<RefusePlaceMessagesCubit, RefusePlaceMessagesState>(
            bloc: _refusePlaceMessagesCubit,
            builder: (context, state) {
              if (state is RefusePlaceMessagesLoading) {
                return CircularProgressIndicator();
              }
              if (state is RefusePlaceMessagesSuccess) {
                //return Text("Your post has been refused for these reasons");
                print(state.refusePlaceMessages.length);
                return SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 36,
                          ),
                          Text(
                            "Your post has been refused for these reasons:",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: MyColors.darkBlue),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          ...state.refusePlaceMessages
                              .map((e) => Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("• "),
                                      Expanded(
                                        child: Text(e.name),
                                      ),
                                    ],
                                  ))
                              .toList(),
                          SizedBox(
                            height: 16,
                          ),
                          if ((widget.notification.description?.length ?? 0) >
                              0)
                            Row(
                              children: [
                                Text(
                                  "Description: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: MyColors.darkBlue),
                                ),
                                Text(widget.notification.description)
                              ],
                            ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            margin: EdgeInsets.symmetric(vertical: 24),
                            color: Colors.grey.shade200,
                            child: Text(
                                'You can update your post to be re-reviewed',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: MyColors.darkBlue)),
                          ),
                          Divider(),
                          BlocConsumer<PlaceDetailsCubit, PlaceDetailsState>(
                              bloc: _placeDetailsCubit,
                              listener: (context, state) {
                                if (state is PlaceDetailsSuccess) {
                                  final _titleValue = state.place.title;
                                  final _descriptionValue =
                                      state.place.description;
                                  _titleEditingController.value =
                                      TextEditingValue(
                                    text: _titleValue,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: _titleValue.length),
                                    ),
                                  );
                                  _descriptionEditingController.value =
                                      TextEditingValue(
                                    text: _descriptionValue,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(
                                          offset: _descriptionValue.length),
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
                                          titleEditingController:
                                              _titleEditingController,
                                          onEditingComplete: () {
                                            FocusScopeNode currentFocus =
                                                FocusScope.of(context);
                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                            }
                                          },
                                          validator: qValidator([
                                            IsRequired(
                                                msg: 'title is required'),
                                            MaxLength(191),
                                            MinLength(5),
                                          ]),
                                        ),
                                        const SizedBox(height: 36),
                                        TextFormField(
                                          controller:
                                              _descriptionEditingController,
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
                                        BlocBuilder<ImagePickerBloc,
                                                ImagePickerState>(
                                            bloc: _imagePickerBloc,
                                            builder:
                                                (context, imagePickerState) {
                                              if (imagePickerState
                                                  is ImagesPicked) {
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    GridView.builder(
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            imagePickerState
                                                                .images?.length,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 16),
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    3,
                                                                crossAxisSpacing:
                                                                    8,
                                                                childAspectRatio:
                                                                    1.4,
                                                                mainAxisSpacing:
                                                                    16),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Image(
                                                            image: ResizeImage(
                                                              FileImage(
                                                                imagePickerState
                                                                        .images[
                                                                    index],
                                                              ),
                                                              height: 100,
                                                            ),
                                                            fit: BoxFit.cover,
                                                          );
                                                        }),
                                                    SizedBox(height: 16),
                                                    MaterialButton(
                                                      color:
                                                          MyColors.lightGreen,
                                                      onPressed: () {
                                                        _imagePickerBloc
                                                            .add(PickImages());
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8,
                                                                vertical: 2),
                                                        child: Text(
                                                          "Re-Pick Images",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                              return GestureDetector(
                                                onTap: () => _imagePickerBloc
                                                    .add(PickImages()),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    GridView.builder(
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: state.place
                                                            .pictures?.length,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 16),
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    3,
                                                                crossAxisSpacing:
                                                                    8,
                                                                childAspectRatio:
                                                                    1.4,
                                                                mainAxisSpacing:
                                                                    16),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Image.network(
                                                            state.place
                                                                .pictures[index]
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
                                                      color:
                                                          MyColors.lightGreen,
                                                      onPressed: () {
                                                        _imagePickerBloc
                                                            .add(PickImages());
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: Text(
                                                          "Pick Pictures",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                        StateDropdown(
                                          dropDownStateBloc: _dropDownStateBloc,
                                          hint: state.place.state,
                                        ),
                                        MunicipalDropDown(
                                          dropDownsMunicipalBloc:
                                              _dropDownsMunicipalBloc,
                                        ),
                                        SizedBox(
                                          height: 32,
                                        ),
                                        MaterialButton(
                                          minWidth: double.infinity,
                                          color: MyColors.darkBlue,
                                          onPressed: () {
                                            /*    _imagePickerBloc
                                                .add(PickImages());*/

                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();
                                              _placeUploadBloc.add(UpdatePlaceButtonPressed(
                                                  title: _titleEditingController
                                                      .value.text,
                                                  description:
                                                      _descriptionEditingController
                                                          .value.text,
                                                  pictures: (_imagePickerBloc
                                                              .state
                                                          is ImagesPicked)
                                                      ? (_imagePickerBloc
                                                                  .state
                                                              as ImagesPicked)
                                                          .images
                                                      : null,
                                                  municipalID: (_dropDownsMunicipalBloc
                                                              .currentMunicipal !=
                                                          null)
                                                      ? _dropDownsMunicipalBloc
                                                          .currentMunicipal?.id
                                                      : null,
                                                  placeId: state.place.id));
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: Text(
                                              "Update Place",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
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
                        ]),
                  ),
                );
              }
              if (state is RefusePlaceMessagesError) {
                return Text("Error");
              }
              return Text("");
            },
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

  @override
  void initState() {
    super.initState();
    _refusePlaceMessagesCubit =
        RefusePlaceMessagesCubit(context.read<RefusePlaceMessageRepository>());
    _refusePlaceMessagesCubit.getRefusePlaceMessages(widget.notification.id);
    _titleEditingController = TextEditingController();
    _descriptionEditingController = TextEditingController();
    _placeDetailsCubit = PlaceDetailsCubit(
        placeID: widget.notification.placeId,
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
    _titleEditingController.dispose();
    _descriptionEditingController.dispose();
    _refusePlaceMessagesCubit.close();
    _dropDownsMunicipalBloc.close();
    _dropDownStateBloc.close();
    _imagePickerBloc.close();
    _placeUploadBloc.close();
    super.dispose();
  }
}
