import 'package:flutter/material.dart';
import 'package:tahwisa/repositories/models/tag.dart';

import 'tag_card.dart';

class TopTagsGridView extends StatelessWidget {
  const TopTagsGridView({
    Key key,
    @required this.tags,
  }) : super(key: key);

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(bottom: 16),
      child: GridView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: tags.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              childAspectRatio: 1.4,
              mainAxisSpacing: 16),
          itemBuilder: (context, index) {
            return TagCard(tags[index]);
          }),
    );
  }
}
