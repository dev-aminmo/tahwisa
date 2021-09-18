import 'package:flutter/material.dart';
import 'package:tahwisa/repositories/models/place.dart';

import 'tag_chip.dart';

class TagsList extends StatelessWidget {
  const TagsList({
    Key key,
    @required this.place,
  }) : super(key: key);

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: place.tags.map((tag) => TagChip(tag.name)).toList(),
    );
  }
}
