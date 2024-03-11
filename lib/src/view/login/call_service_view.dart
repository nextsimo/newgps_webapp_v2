import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/styles.dart';

class CallServiceView extends StatelessWidget {
  const CallServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showCallService(context),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConsts.mainradius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.call_end,
              color: Colors.green,
              size: 15,
            ),
            const SizedBox(width: 12),
            Text(
              'Appeler Service Après Vente',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );

/*     return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.call_end,
                size: 26,
              ),
              const SizedBox(width: 10),
              Text(
                "Service après vente".toUpperCase(),
                style: const TextStyle(
                  letterSpacing: 1.25,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildPhone(tel: '06 62 78 26 94'),
          const SizedBox(height: 4),
          _buildPhone(tel: '‎05 22 30 48 10'),
          const SizedBox(height: 4),
          _buildPhone(tel: '06 61 59 93 92'),
        ],
      ),
    ); */
  }
}

// show call service
void showCallService(BuildContext context) {
  showDialog(
    barrierColor: Colors.transparent,
    context: context,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConsts.mainradius),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConsts.mainradius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              MainButton(
                width: 260,
                onPressed: () => call('0661599392'),
                // icon for service technique
                icon: Icons.miscellaneous_services_rounded,
                label: '06 61 59 93 92',
              ),
              const SizedBox(height: 12),
              MainButton(
                width: 260,
                onPressed: () => call('0661786787'),
                icon: Icons.phone_iphone_rounded,
                label: '06 61 78 67 87',
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );
}

void call(String phoneNumber) async {
  try {
    launchUrl(Uri.parse('tel:$phoneNumber'), mode: LaunchMode.inAppBrowserView);
  } catch (e) {
    launchUrl(Uri.parse('tel:$phoneNumber'), mode: LaunchMode.inAppBrowserView);

    log(e.toString());
  }
}
