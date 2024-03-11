import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CallServiceView extends StatelessWidget {
  const CallServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Service après vente".toUpperCase(),
          style:  GoogleFonts.roboto(
            letterSpacing: 1.25,
          ),
        ),
        const SizedBox(height: 10),
        _buildPhone(tel: '06 62 78 26 94', phone: '+212662782694'),
        const SizedBox(height: 6),
        _buildPhone(tel: '‎05 22 30 48 10', phone: '+212522304810'),
        const SizedBox(height: 6),
        _buildPhone(tel: '06 61 59 93 92', phone: '+212661599392'),
      ],
    );
  }

  Widget _buildPhone({required String tel, required String phone}) {
    return GestureDetector(
      onTap: () {
        launchUrlString('tel:$phone', webOnlyWindowName: '_self');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tel,
            style:  GoogleFonts.roboto(
              color: AppConsts.mainColor,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(width: 10),
          Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppConsts.mainColor,
              ),
              child: const Icon(
                Icons.call,
                color: Colors.white,
                size: 16,
              )),
        ],
      ),
    );
  }
}
