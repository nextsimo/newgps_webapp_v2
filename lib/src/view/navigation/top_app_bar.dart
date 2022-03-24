import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../connected_device/connected_device_button.dart';
import '../connected_device/connected_device_view.dart';

class CustomAppBar extends PreferredSize {
  final double height;
  final void Function()? onTap;
  final List<Widget>? actions;

  const CustomAppBar(
      {Key? key, this.height = kToolbarHeight, this.actions, this.onTap})
      : super(
          key: key,
          child: const SizedBox(),
          preferredSize: const Size.fromHeight(kToolbarHeight),
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          actions: actions,
          backgroundColor: Colors.white,
          leading: Row(
            children: [
              Image.network('https://api.newgps.ma/api/icons/logo.svg'),
            ],
          ),
          title: Column(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const ConnectedDeviceView(),
                  );
                },
                child: SizedBox(
                  width: 140,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _BuildAccountName(),
                      SizedBox(width: 3),
                      ConnectedDeviceButton(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 3),
              MainButton(
                width: 300,
                height: 33,
                icon: Icons.call,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return Dialog(
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 12),
                              MainButton(
                                width: 260,
                                onPressed: () {
                                  launch('tel:0522304810',
                                      webOnlyWindowName: '_self');
                                },
                                icon: Icons.phone_forwarded_rounded,
                                label: '0662782694',
                              ),
                              const SizedBox(height: 12),
                              MainButton(
                                width: 260,
                                onPressed: () {
                                  launch('tel:‎0522304810',
                                      webOnlyWindowName: '_self');
                                },
                                icon: Icons.phone_forwarded_rounded,
                                label: '‎0522304810',
                              ),
                              const SizedBox(height: 12),
                              MainButton(
                                width: 260,
                                onPressed: () {
                                  launch('tel:0661599392',
                                      webOnlyWindowName: '_self');
                                },
                                icon: Icons.phone_forwarded_rounded,
                                label: '0661599392',
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                label: 'Service aprés ventes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildAccountName extends StatelessWidget {
  const _BuildAccountName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Account? account = shared.getAccount();
    String name;

    if (account!.account.userID != null && account.account.userID!.isNotEmpty) {
      name = account.account.userID ?? '';
    } else {
      name = account.account.accountId ?? '';
    }
    return Container(
      margin: EdgeInsets.only(
          bottom: 0, top: MediaQuery.of(context).padding.top * 0.2),
      padding: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppConsts.mainColor, width: 1.4),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        name.toUpperCase(),
        style:  GoogleFonts.roboto(
          color: Colors.black,
          fontSize: 10,
          //fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
