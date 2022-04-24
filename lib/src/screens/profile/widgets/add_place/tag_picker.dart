import 'package:flutter/material.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:tahwisa/src/repositories/models/tag.dart';
import 'package:tahwisa/src/repositories/tag_repository.dart';
import 'package:tahwisa/src/style/my_colors.dart';

class TagPicker extends StatelessWidget {
  const TagPicker({
    Key? key,
    required List<Tag>? selectedTags,
    required TagRepository? tagRepository,
  })  : _selectedTags = selectedTags,
        _tagRepository = tagRepository,
        super(key: key);

  final List<Tag>? _selectedTags;
  final TagRepository? _tagRepository;
  @override
  Widget build(BuildContext context) {
    return FlutterTagging<Tag>(
      initialItems: _selectedTags!,
      emptyBuilder: (ctx) {
        return Padding(
            padding: EdgeInsets.all(16), child: Text("No tags found"));
      },
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: MyColors.darkBlue.withAlpha(30),
          hintText: 'Search Tags',
          labelText: 'Select Tags',
        ),
      ),
      findSuggestions: _tagRepository!.getTags,
      additionCallback: (value) {
        return Tag(
          name: value,
        );
      },
      onAdded: (tag) {
        return Tag(id: tag.id, name: tag.name);
      },
      configureSuggestion: (tag) {
        return SuggestionConfiguration(
          title: Text(tag.name),
          // subtitle: Text(lang.position.toString()),
          additionWidget: Chip(
            avatar: Icon(
              Icons.add_circle,
              color: MyColors.white,
            ),
            label: Text('Add New Tag'),
            labelStyle: TextStyle(
              color: MyColors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
            ),
            backgroundColor: MyColors.darkBlue,
          ),
        );
      },
      configureChip: (tag) {
        return ChipConfiguration(
          label: Text(tag.name),
          backgroundColor: MyColors.darkBlue,
          labelStyle: TextStyle(
            color: MyColors.white,
          ),
          deleteIconColor: MyColors.white,
        );
      },
      onChanged: () {
        print(_selectedTags);
        var jsonTags = _selectedTags!.map((t) => t.toJson()).toList();
        print(jsonTags);
      },
    );
  }
}
