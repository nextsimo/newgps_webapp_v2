import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/navigation/top_app_bar.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';
import 'package:newgps/src/widgets/inputs/auto_search_wigdet.dart';
import 'package:provider/provider.dart';

import 'driver_provider.dart';

class DriverView extends StatelessWidget {
  const DriverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DriverViewProvider>(
        create: (_) => DriverViewProvider(),
        builder: (context, __) {
          final DriverViewProvider provider =
              Provider.of<DriverViewProvider>(context);
          return Scaffold(
            appBar: const CustomAppBar(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSearchWithAllWidget(
                      clearTextController: provider.auto.clear,
                      controller: provider.auto.controller,
                      handleSelectDevice: provider.auto.handleSelectDevice,
                      initController: provider.auto.initController,
                      onClickAll: provider.auto.onClickAll,
                      onSelectDevice: provider.auto.onTapDevice,
                    ),
                    Row(
                      children: const [
                        LogoutButton(),
                        SizedBox(width: AppConsts.outsidePadding),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: SafeArea(
                    bottom: false,
                    top: false,
                    right: false,
                    child: GridView.builder(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: provider.devices.length,
/*                       padding: const EdgeInsets.fromLTRB(
                          AppConsts.outsidePadding,
                          AppConsts.outsidePadding,
                          AppConsts.outsidePadding,
                          160), */
                      itemBuilder: (_, int index) => _BuildDriverCard(
                        device: provider.devices.elementAt(index),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _BuildDriverCard extends StatelessWidget {
  final DataDevice device;
  _BuildDriverCard({
    Key? key,
    required this.device,
  }) : super(key: key);

  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: device.color, width: 1.8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 22, offset: Offset(0, 12)),
          ]),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            device.description,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          _buildRichText(device.note)
        ],
      ),
    );
  }

  RichText _buildRichText(int note) {
    return RichText(
      text: TextSpan(
          text: '$note',
          style:  GoogleFonts.amiri(
            fontSize: 55,
            color: AppConsts.mainColor,
            fontWeight: FontWeight.w500,

          ),
          children:  [
            TextSpan(
              text: '/20',
              style: GoogleFonts.amiri(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ]),
    );
  }
}
