import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/firebase_messaging_service.dart';
import '../../../utils/functions.dart';
import '../../../utils/styles.dart';
import '../../../widgets/buttons/main_button.dart';
import '../../../widgets/show_device_dialog.dart';
import '../../navigation/top_app_bar.dart';
import '../widgets/build_label.dart';
import 'oil_change_view_provider.dart';

class OilChangeAertView extends StatelessWidget {
  const OilChangeAertView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<FirebaseMessagingService,
            OilChangeAlertProvider>(
        create: (_) => OilChangeAlertProvider(),
        lazy: false,
        update: (_, messaging, provider) {
          return OilChangeAlertProvider(messaging);
        },
        builder: (context, __) {
          return Scaffold(
            appBar: const CustomAppBar(
              actions: [CloseButton(color: Colors.black)],
            ),
            body: SafeArea(
              right: false,
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 10),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: const Column(
                    children: [
                      SizedBox(height: 10),
                      BuildLabel(
                          label: 'Vidange', icon: Icons.verified_user_rounded),
                      SizedBox(height: 5),
                      _BuildPortraitContent(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _BuildPortraitContent extends StatelessWidget {
  const _BuildPortraitContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OilChangeAlertProvider provider =
        Provider.of<OilChangeAlertProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _buildStatusLabel(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ShowDeviceDialogWidget(
            onselectedDevice: provider.onSelectedDevice,
            label: provider.settingPerDevice.deviceId == 'all'
                ? 'Sélectionner une véhicule'
                : provider.selectedDevice.description,
          ),
        ),
        const SizedBox(height: 10),
        if (provider.settingPerDevice.deviceId != 'all')
          const _BuildDeviceSettingPortrait(),
      ],
    );
  }

  Widget _buildStatusLabel(BuildContext context) {
    OilChangeAlertProvider provider =
        Provider.of<OilChangeAlertProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Notification statut:'),
        Switch(
            value: provider.globalIsActive,
            onChanged: provider.updateGlobaleState),
      ],
    );
  }
}

class _BuildDeviceSettingPortrait extends StatelessWidget {
  const _BuildDeviceSettingPortrait({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    OilChangeAlertProvider provider =
        Provider.of<OilChangeAlertProvider>(context);
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppConsts.mainColor,
          )),
      child: Form(
        key: provider.formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Statut'),
                Switch(value: provider.isActive, onChanged: provider.onChanged),
              ],
            ),
            _BuilTextField(
              hint: 'Dérniere vidange(Km)',
              controller: provider.lastOilChangeController,
            ),
            const SizedBox(height: 10),
            _BuilTextField(
              hint: 'Prochaine vidange aprés(Km)',
              controller: provider.nextOilChangeController,
            ),
            const SizedBox(height: 10),
            _BuilTextField(
              hint: 'Alert avant(Km)',
              controller: provider.alertBeforController,
            ),
            const SizedBox(height: 20),
            MainButton(
              onPressed: provider.save,
              label: 'Modifier',
            ),
          ],
        ),
      ),
    );
  }
}

class _BuilTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const _BuilTextField({
    Key? key,
    this.hint = '',
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: SizedBox(
        child: TextFormField(
          controller: controller,
          validator: FormValidatorService.isNotEmpty,
          keyboardType: const TextInputType.numberWithOptions(
              decimal: true, signed: true),
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.done,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            labelText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
