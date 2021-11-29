import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/device_size.dart';
import 'package:newgps/src/view/login/login_as/save_account_provider.dart';
import 'package:provider/provider.dart';

import 'bottom_app_bar/bottom_navigatiom_bar.dart';
import 'bottom_app_bar/user_bottom_navigation_bar.dart';

class CustomNavigationView extends StatelessWidget {
  CustomNavigationView({Key? key}) : super(key: key);

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    DeviceSize.init(context);
    SavedAcountProvider pro =
        Provider.of<SavedAcountProvider>(context, listen: false);
    Account? account = shared.getAccount();
    return Provider<FirebaseMessagingService>(
        lazy: false,
        create: (_) => FirebaseMessagingService(),
        builder: (context, snapshot) {
          return Scaffold(
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: pro.buildPages(),
            ),
            bottomNavigationBar: account!.account.userID == null
                ? CustomBottomNavigatioBar(
                    pageController: _pageController,
                  )
                : UserCustomBottomNavigatioBar(
                    pageController: _pageController,
                  ),
          );
        });
  }
}
