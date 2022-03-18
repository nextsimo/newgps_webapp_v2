import 'package:flutter/material.dart';
import 'package:newgps/src/utils/device_size.dart';
import 'package:newgps/src/view/splash/splash_view_model.dart';
import 'package:provider/provider.dart';

class SplashView extends StatelessWidget {
  final bool alert;
  const SplashView({Key? key, this.alert = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceSize.init(context);
    //debugPrint('------> $alert');
    return ChangeNotifierProvider<SplashViewModel>(
        create: (_) => SplashViewModel(),
        builder: (context, snapshot) {
          SplashViewModel model =
              Provider.of<SplashViewModel>(context, listen: false);
          model.init(context, alert:alert);
          return Material(
            child: Center(
              child: Image.asset(
                'assets/logo-200.png',
              ),
            ),
          );
        });
  }
}
