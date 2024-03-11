import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:provider/provider.dart';
import '../../services/newgps_service.dart';
import '../../utils/device_size.dart';
import '../login/login_as/save_account_provider.dart';
import 'bottom_app_bar/bottom_navigatiom_bar.dart';
import 'bottom_app_bar/user_bottom_navigation_bar.dart';

class CustomNavigationView extends StatelessWidget {
  CustomNavigationView({super.key});
  final PageController myController = PageController();
  @override
  Widget build(BuildContext context) {
    DeviceSize.init(context);

    navigationViewProvider.pageController = myController;
    Account? account = shared.getAccount();
    NewgpsService.resumeRepportProvider.fetchDataFromOutside();

    NewgpsService.messaging.init();


    return MultiProvider(
      providers: [
        Provider.value(value: NewgpsService.messaging),
        Provider.value(value: navigationViewProvider),
      ],
      builder: (BuildContext context, __) {
        SavedAcountProvider pro =
            Provider.of<SavedAcountProvider>(context, listen: false);
        pro.checkNotifcation();
        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: myController,
            children: pro.buildPages(),
          ),
          bottomNavigationBar: (account!.account.userID == null ||
                  account.account.userID!.isEmpty)
              ? CustomBottomNavigatioBar(
                  pageController: myController,
                )
              : UserCustomBottomNavigatioBar(
                  pageController: myController,
                ),
        );
      },
    );
  }
}
