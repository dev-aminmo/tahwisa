import 'package:flutter/material.dart';
import 'package:tahwisa/src/cubits/admin_cubit/admin_cubit.dart';

class ApproveRefuseButtons extends StatelessWidget {
  final _refusePlaceMessagesCubit;
  final _adminCubit;
  final notification;

  ApproveRefuseButtons(
      this._refusePlaceMessagesCubit, this._adminCubit, this.notification);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 16,
            ),
            MaterialButton(
              onPressed: () {
                _refusePlaceMessagesCubit.getAdminRefusePlaceMessages();
              },
              child: Text(
                "Refuse",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.redAccent,
            ),
            Spacer(),
            MaterialButton(
              onPressed: () {
                if (_adminCubit.state is! AdminLoading) {
                  _adminCubit.approvePlace(notification.placeId);
                }
              },
              child: Text(
                "Approve",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.green,
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
