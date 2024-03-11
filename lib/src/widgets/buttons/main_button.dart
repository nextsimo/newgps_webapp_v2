import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/utils/styles.dart';

class MainButton extends StatefulWidget {
  final String label;
  final Color backgroundColor;
  final double? width;
  final Color textColor;
  final dynamic Function() onPressed;
  final double height;
  final Color? borderColor;
  final IconData? icon;
  const MainButton(
      {super.key,
      this.label = '',
      required this.onPressed,
      this.backgroundColor = AppConsts.mainColor,
      this.width,
      this.height = 48,
      this.borderColor,
      this.textColor = Colors.white,
      this.icon});

  @override
  // ignore: library_private_types_in_public_api
  _MainButtonState createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  bool _loding = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConsts.mainradius),
                  side: BorderSide(
                      color: widget.borderColor ?? widget.backgroundColor))),
          backgroundColor: MaterialStateColor.resolveWith(
              (states) => widget.backgroundColor),
        ),
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
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(widget.icon, color: Colors.white, size: 21),
                    ),
                  Text(widget.label, style: GoogleFonts.roboto(color: widget.textColor, fontWeight: FontWeight.w400)),
                ],
              ),
      ),
    );
  }
}
