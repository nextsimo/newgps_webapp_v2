import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:newgps/src/models/user_droits.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/login/login_as/save_account_provider.dart';
import 'package:newgps/src/view/navigation/top_app_bar.dart';
import 'package:provider/provider.dart';
import '../widgets/build_label.dart';

class CapoView extends StatefulWidget {
  const CapoView({Key? key}) : super(key: key);

  @override
  State<CapoView> createState() => _CapoViewState();
}

class _CapoViewState extends State<CapoView> {
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        actions: [CloseButton(color: Colors.black)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConsts.outsidePadding),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const BuildLabel(label: 'capot', icon: Icons.radar),
            const SizedBox(height: 20),
            _buildStatusLabel(),
            const SizedBox(height: 20),
            _buildHistoric(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoric() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Historiques:'),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppConsts.outsidePadding),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 2.8,
                crossAxisSpacing: AppConsts.outsidePadding,
                maxCrossAxisExtent: 400,
                mainAxisSpacing: AppConsts.outsidePadding,
              ),
              itemCount: 0,
              itemBuilder: (_, int index) {
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildStatusLabel() {
    Droit droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[3];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Notification statut:'),
        Switch(
            value: _isActive,
            onChanged: droit.write
                ? (_) {
                    setState(() {
                      _isActive = !_isActive;
                    });
                  }
                : null),
      ],
    );
  }
}
