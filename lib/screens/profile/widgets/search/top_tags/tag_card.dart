import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tahwisa/repositories/models/tag.dart';
import 'package:tahwisa/style/my_colors.dart';

class TagCard extends StatelessWidget {
  final Tag tag;
  final Function onTap;

  const TagCard(this.tag, this.onTap);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(tag.picture),
              fit: BoxFit.cover,
            ),
          ),
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            child: BackdropFilter(
              // filter: ImageFilter.blur(sigmaX: .8, sigmaY: .4),
              filter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1), BlendMode.hardLight),

              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  //   color: Colors.black.withOpacity(0.05),

                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text("${tag.name}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: MyColors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w600)),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
