import 'package:flutter/material.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/view/geozone/geozone_dialog/geozone_action_view.dart';
import 'package:newgps/src/view/geozone/geozone_view.dart';
import 'package:provider/provider.dart';

import 'geozone_provider.dart';

class GeozoneNavigation extends StatelessWidget {
  const GeozoneNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<FirebaseMessagingService,
            GeozoneProvider>(
        update: (_, m, u) => GeozoneProvider(m: m),
        create: (_) => GeozoneProvider(),
        builder: (context, snapshot) {
          return Navigator(
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case '/geozonemap':
                  return MaterialPageRoute(
                      builder: (_) => GeozoneActionView(
                            geozoneDialogProvider:
                                Provider.of<GeozoneProvider>(context)
                                    .geozoneDialogProvider,
                          ));
                default:
                  return MaterialPageRoute(builder: (_) => const GeozoneView());
              }
            },
          );
        });
  }
}
