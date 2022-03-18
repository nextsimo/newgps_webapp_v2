import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';

class MainInput extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  final String hint;
  final double? width;
  final bool autofocus;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onchanged;
  final void Function()? onEditeComplete;
  final TextInputType? textInputType;

  const MainInput(
      {Key? key,
      this.icon,
      this.hint = '',
      this.controller,
      this.validator,
      this.onEditeComplete,
      this.onchanged,
      this.color,
      this.textInputType,
      this.width, this.autofocus = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        autofocus: autofocus,
        onEditingComplete: onEditeComplete,
        controller: controller,
        validator: validator,
        onChanged: onchanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: color ?? Colors.grey[300],
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          prefixIconConstraints: const BoxConstraints(),
          prefixIcon: icon == null
              ? const SizedBox()
              : Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppConsts.mainColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(icon, color: Colors.white)
                  ),
                ),
        ),
      ),
    );
  }
}
