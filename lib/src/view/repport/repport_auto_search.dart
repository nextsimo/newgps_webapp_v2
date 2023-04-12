import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/repport/rapport_provider.dart';
import 'package:provider/provider.dart';

class AutoSearchField extends StatelessWidget {
  const AutoSearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppConsts.mainradius,
        ),
        borderSide: const BorderSide(
            color: AppConsts.mainColor, width: AppConsts.borderWidth));
    final RepportProvider repportProvider =
        Provider.of<RepportProvider>(context, listen: false);
    if (repportProvider.devices.isEmpty) return const SizedBox();
    return GestureDetector(
      onTap: () => repportProvider.handleSelectDevice(),
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.topLeft,
        child: Container(
          width: 290,
          margin: const EdgeInsets.fromLTRB(0, AppConsts.outsidePadding,
              AppConsts.outsidePadding, AppConsts.outsidePadding),
          child: Autocomplete<Device>(
            initialValue: const TextEditingValue(text: 'Toutes les vehicules'),
            fieldViewBuilder: (BuildContext context, TextEditingController _,
                FocusNode focusNode, Function onFieldSubmitted) {
              repportProvider.autoSearchTextController = _;
              return _BuildTextField(
                  repportProvider: repportProvider,
                  outlineInputBorder: outlineInputBorder,
                  focus: focusNode);
            },
            displayStringForOption: (d) => d.description,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return repportProvider.devices;
              }
              return repportProvider.devices.where(
                (device) {
                  return device.description
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                },
              );
            },
            optionsViewBuilder: (BuildContext context,
                void Function(Device device) deviceFunc, devices) {
              return OptionViewBuilderWidget(
                devices: devices.toList(),
                onSelectRepportResumeModel: deviceFunc,
                repportProvider: repportProvider,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BuildTextField extends StatefulWidget {
  const _BuildTextField({
    Key? key,
    required this.repportProvider,
    required this.outlineInputBorder,
    required this.focus,
  }) : super(key: key);

  final RepportProvider repportProvider;
  final OutlineInputBorder outlineInputBorder;
  final FocusNode focus;

  @override
  State<_BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<_BuildTextField> {
  @override
  void initState() {
    super.initState();

    widget.focus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextFormField(
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        showCursor: true,
        textInputAction: TextInputAction.done,
        scrollPadding: EdgeInsets.zero,
        maxLines: 1,
        onTap: () async {
          widget.repportProvider.autoSearchTextController.text = '';
          widget.repportProvider.handleRepportType();
          //repportProvider.handleSelectDevice(only: true);
        },
        onFieldSubmitted: widget.repportProvider.ontapEnterRepportDevice,
        decoration: InputDecoration(
          fillColor: Colors.white,
          suffixText: widget.focus.hasFocus
              ? ''
              : '${widget.repportProvider.devices.length}',
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          filled: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          border: widget.outlineInputBorder,
          focusedBorder: widget.outlineInputBorder,
          enabledBorder: widget.outlineInputBorder,
        ),
        controller: widget.repportProvider.autoSearchTextController,
        focusNode: widget.focus,
      ),
    );
  }
}

class OptionViewBuilderWidget extends StatelessWidget {
  final List<Device> devices;
  final RepportProvider repportProvider;
  final void Function(Device) onSelectRepportResumeModel;

  const OptionViewBuilderWidget({
    Key? key,
    required this.devices,
    required this.onSelectRepportResumeModel,
    required this.repportProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        repportProvider.handleSelectDevice();
      },
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 290,
            constraints: BoxConstraints(
              maxHeight: size.height * 0.75,
            ),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: AppConsts.mainColor, width: AppConsts.borderWidth),
                borderRadius: BorderRadius.circular(AppConsts.mainradius)),
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: devices.map<Widget>((device) {
                  return OptionItem(
                    onSelectRepportResumeModel: onSelectRepportResumeModel,
                    repportProvider: repportProvider,
                    device: device,
                  );
                }).toList()
                  ..insert(0, _buildToutsWidget(repportProvider, context))),
          ),
        ),
      ),
    );
  }

  Widget _buildToutsWidget(RepportProvider provider, BuildContext context) {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        repportProvider.selectAllDevices = true;
                provider.handleSelectDevice();


        if (provider.selectedRepport.index != 0 &&
            provider.selectedRepport.index != 4) {
          provider.selectedRepport = provider.repportsType.first;
        }
      },
      child: Container(
        height: 45,
        padding:
            const EdgeInsets.symmetric(horizontal: AppConsts.outsidePadding),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: AppConsts.mainColor, width: AppConsts.borderWidth),
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Touts les véhicules'),
            Text('${repportProvider.devices.length}'),
          ],
        ),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final Device device;
  const OptionItem({
    Key? key,
    required this.onSelectRepportResumeModel,
    required this.repportProvider,
    required this.device,
  }) : super(key: key);

  final void Function(Device p1) onSelectRepportResumeModel;
  final RepportProvider repportProvider;

  @override
  Widget build(BuildContext context) {
    return ListTile(
/*       trailing: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Color.fromRGBO(device.colorR, device.colorG, device.colorB, 1),
        ),
        child: Text(
          device.statut,
          style: const GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ), */
      title: Text(
        device.description,
      ),
      onTap: () async {
        onSelectRepportResumeModel(device);
        repportProvider.selectedDevice = device;
        repportProvider.selectAllDevices = false;
        if (repportProvider.selectedRepport.index ==
            repportProvider.repportsType.first.index) {
          repportProvider.selectedRepport =
              repportProvider.repportsType.elementAt(1);
        }


        FocusScope.of(context).requestFocus(FocusNode());
        //lastPositionProvider.moveCamera(device, zoom: 8.5);
      },
      minVerticalPadding: 0,
    );
  }
}
