import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/device_size.dart';
import 'package:newgps/src/view/login/login_as/save_account_provider.dart';
import 'package:provider/provider.dart';

import 'bottom_app_bar/bottom_navigatiom_bar.dart';
import 'bottom_app_bar/user_bottom_navigation_bar.dart';

class CustomNavigationView extends StatefulWidget {
  final bool alert;
  const CustomNavigationView({Key? key, this.alert = false}) : super(key: key);

  @override
  State<CustomNavigationView> createState() => _CustomNavigationViewState();
}

class _CustomNavigationViewState extends State<CustomNavigationView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    NewgpsService.resumeRepportProvider.fetchDataFromOutside();
    if (widget.alert) {
      _pageController = PageController(initialPage: 3);
      deviceProvider.initAlertRoute = 'historics';
    }
  }

  @override
  Widget build(BuildContext context) {
    DeviceSize.init(context);
    SavedAcountProvider pro =
        Provider.of<SavedAcountProvider>(context, listen: false);
    NewgpsService.messaging.init();

    Account? account = shared.getAccount();
    return Provider.value(
        value: NewgpsService.messaging,
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
                    alert: widget.alert,
                  )
                : UserCustomBottomNavigatioBar(
                    pageController: _pageController,
                  ),
          );
        });
  }
}
