import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';

class SearchWidget extends StatelessWidget {
  final bool autoFocus;
  final void Function(String str)? onChnaged;
  final String? hint;
  const SearchWidget({Key? key, this.onChnaged, this.hint, this.autoFocus=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
        borderSide: const BorderSide(
            width: AppConsts.borderWidth, color: AppConsts.mainColor));
    return Padding(
      padding: const EdgeInsets.all(AppConsts.outsidePadding),
      child: SizedBox(
        width: 300,
        height: 35,
        child: TextField(
          autofocus: autoFocus,
          onChanged: onChnaged,
          expands: true,
          maxLines: null,
          minLines: null,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(
              Icons.search,
              color: AppConsts.mainColor,
              size: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            enabledBorder: outlineInputBorder,
          ),
        ),
      ),
    );
  }
}
