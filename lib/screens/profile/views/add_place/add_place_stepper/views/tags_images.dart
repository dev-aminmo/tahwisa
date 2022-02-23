import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/image_picker_bloc/bloc.dart';
import 'package:tahwisa/repositories/models/tag.dart';
import 'package:tahwisa/repositories/tag_repository.dart';
import 'package:tahwisa/screens/profile/widgets/add_place/tag_picker.dart';
import 'package:tahwisa/style/my_colors.dart';

class TagsImagesPage extends StatefulWidget {
  final TagRepository? tagRepository;
  final ImagePickerBloc? imagePickerBloc;
  final List<Tag>? selectedTags;

  const TagsImagesPage(
      {required this.tagRepository,
      required this.imagePickerBloc,
      required this.selectedTags});

  @override
  _TagsImagesPageState createState() => _TagsImagesPageState();
}

class _TagsImagesPageState extends State<TagsImagesPage>
    with AutomaticKeepAliveClientMixin<TagsImagesPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15),
      children: [
        SizedBox(height: 48),
        TagPicker(
            selectedTags: widget.selectedTags,
            tagRepository: widget.tagRepository),
        SizedBox(height: 72),
        BlocBuilder<ImagePickerBloc, ImagePickerState>(
            bloc: widget.imagePickerBloc,
            builder: (context, state) {
              if (state is ImagesPicked) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GridView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.images.length,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            childAspectRatio: 1.4,
                            mainAxisSpacing: 16),
                        itemBuilder: (context, index) {
                          return Image(
                            image: ResizeImage(
                              FileImage(
                                state.images[index],
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
                        widget.imagePickerBloc!.add(PickImages());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        child: Text(
                          "Re-Pick Images",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return GestureDetector(
                onTap: () => widget.imagePickerBloc!.add(PickImages()),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined,
                        color: MyColors.darkBlue, size: 72),
                    SizedBox(height: 12),
                    MaterialButton(
                      color: MyColors.darkBlue,
                      onPressed: () {
                        widget.imagePickerBloc!.add(PickImages());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "Pick Pictures",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })
      ],
    );
  }
}
