import 'package:flutter/material.dart';

class BuildTextCell extends StatelessWidget {
  final String content;
  final Color? color;
  final int flex;

  const BuildTextCell(this.content, {Key? key, this.color, this.flex = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 48,
        color: color,
        child: Center(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              content.isEmpty ? '     ' : content,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
