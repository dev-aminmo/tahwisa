import 'package:flutter/material.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/style/my_colors.dart';

class UserRow extends StatelessWidget {
  const UserRow({
    Key? key,
    required this.place,
  }) : super(key: key);

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      CircleAvatar(
        minRadius: 28,
        backgroundColor: MyColors.gray,
        backgroundImage: NetworkImage(
          place.user!.profilePicture!.replaceFirstMapped(
              "image/upload/", (match) => "image/upload/w_150,f_auto/"),
        ),
      ),
      const SizedBox(width: 16),
      Flexible(
        child: Text(
          place.user!.name!,
          textAlign: TextAlign.left,
          softWrap: true,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: MyColors.darkBlue),
        ),
      ),
    ]);
  }
}
