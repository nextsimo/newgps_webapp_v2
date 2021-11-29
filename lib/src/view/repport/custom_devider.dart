import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';

class BuildDivider extends StatelessWidget {
  const BuildDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConsts.borderWidth,
      color: AppConsts.mainColor,
      height: 48,
    );
  }
}