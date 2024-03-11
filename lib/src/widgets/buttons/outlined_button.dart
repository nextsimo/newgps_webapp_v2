
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/utils/styles.dart';

class CustomOutlinedButton extends StatefulWidget {
  final String label;
  final double? width;
  final dynamic Function() onPressed;
  const CustomOutlinedButton(
      {super.key, this.label = '', required this.onPressed, this.width});

  @override
  // ignore: library_private_types_in_public_api
  _CustomOutlinedButtonState createState() => _CustomOutlinedButtonState();
}

class _CustomOutlinedButtonState extends State<CustomOutlinedButton> {
  bool _loding = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: 48,
      child: OutlinedButton(
        onPressed: () async {
          try {
            setState(() => _loding = true);
            await widget.onPressed();
            setState(() => _loding = false);
          } catch (e) {
            //log('-->${widget.label}', error: '$e');
            setState(() => _loding = false);
          }
        },
        child: _loding
            ? const SizedBox(
                width: 19,
                height: 19,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                widget.label,
                style: GoogleFonts.roboto(color: AppConsts.mainColor),
              ),
      ),
    );
  }
}
