import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';

class BuildDivider extends StatelessWidget {
  const BuildDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConsts.borderWidth,
      color: Colors.black,
      height: 48,
    );
  }
}