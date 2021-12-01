import 'package:flutter/material.dart';

class BuildClickableTextCell extends StatelessWidget {
  final void Function(int? index)? ontap;
  final String content;
  final Color color;
  final int flex;
  final bool isSlected;
  final bool isUp;
  final int? index;
  const BuildClickableTextCell(this.content,
      {Key? key,
      this.color = Colors.black,
      this.flex = 1,
      this.ontap,
      this.isSlected = false,
      this.isUp = true,
      this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () => ontap!(index),
        child: Container(
          color: isSlected ? Colors.white : Colors.transparent,
          height: 48,
          child: Stack(
            children: [
              Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    content,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                    isUp && isSlected
                        ? Icons.arrow_drop_down_outlined
                        : Icons.arrow_drop_up_outlined,
                    size: 17),
              )
            ],
          ),
        ),
      ),
    );
  }
}
