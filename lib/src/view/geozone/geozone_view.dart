import 'package:flutter/material.dart';
import 'package:newgps/src/models/geozone.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/login/login_as/save_account_provider.dart';
import 'package:newgps/src/view/navigation/top_app_bar.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:newgps/src/widgets/inputs/search_widget.dart';
import 'package:provider/provider.dart';
import 'geozone_provider.dart';

class GeozoneView extends StatelessWidget {
  const GeozoneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GeozoneProvider>(
        create: (_) => GeozoneProvider(),
        builder: (context, snapshot) {
          var droit = Provider.of<SavedAcountProvider>(context, listen: false)
              .userDroits
              .droits[5];
          GeozoneProvider provider = Provider.of<GeozoneProvider>(context);
          return Scaffold(
            appBar: const CustomAppBar(
              actions: [],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SearchWidget(
                          hint: 'Chercher…',
                          onChnaged: (_) {},
                        ),
                        const SizedBox(width: 6),
                        if (droit.write)
                          MainButton(
                            width: 300,
                            height: 35,
                            onPressed: () => provider.showAddDialog(context),
                            label: 'Ajouter une zone',
                          ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(6),
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppConsts.mainColor,
                                width: AppConsts.borderWidth),
                            borderRadius:
                                BorderRadius.circular(AppConsts.mainradius),
                          ),
                          child: Row(
                            children: [
                              const Text('Activer alerte geozone'),
                              const SizedBox(width: 6),
                              Switch(
                                  value:
                                      provider.geozoneSttingsAlert?.isActive ??
                                          false,
                                  onChanged: droit.write
                                      ? provider.updateSettings
                                      : null,
                                  activeColor: AppConsts.mainColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: AppConsts.outsidePadding),
                      child: LogoutButton(),
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 350,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: provider.geozones.length,
                      itemBuilder: (_, int index) {
                        GeozoneModel geozone =
                            provider.geozones.elementAt(index);
                        return GeozoneCard(geozone: geozone);
                      }),
                ),
              ],
            ),
          );
        });
  }
}

class GeozoneCard extends StatelessWidget {
  const GeozoneCard({
    Key? key,
    required this.geozone,
  }) : super(key: key);

  final GeozoneModel geozone;

  @override
  Widget build(BuildContext context) {
    final GeozoneProvider provider =
        Provider.of<GeozoneProvider>(context, listen: false);
    var droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[5];
    return GestureDetector(
      onTap: () => provider.onClickUpdate(geozone, context, readOnly: true),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1.5, color: AppConsts.mainColor),
          image: DecorationImage(
            image: NetworkImage(geozone.mapImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.black.withOpacity(0.4),
              ),
              child: Text(
                geozone.description,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: Colors.white),
              ),
            ),
            if (droit.write)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainButton(
                    width: 100,
                    height: 30,
                    onPressed: () {
                      provider.onClickUpdate(geozone, context);
                      //provider.selectGeoZone(context, geozone);
                    },
                    label: 'Modifier',
                  ),
                  MainButton(
                    backgroundColor: Colors.red,
                    width: 110,
                    height: 30,
                    onPressed: () {
                      provider.deleteGeozone(context, geozone.geozoneId);
                    },
                    label: 'Supprimer',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
