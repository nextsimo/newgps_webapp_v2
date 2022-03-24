import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view/login/login_as/save_account_provider.dart';

class BadgeIcon extends StatelessWidget {
  const BadgeIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SavedAcountProvider, int>(
      selector: (_, p) => p.numberOfNotif,
      builder: (_, int count, __) {
        if (count == 0) {
          return const SizedBox();
        }

        return CircleAvatar(
          radius: 15,
          backgroundColor: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                '$count',
                style: const TextStyle(
                    color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
