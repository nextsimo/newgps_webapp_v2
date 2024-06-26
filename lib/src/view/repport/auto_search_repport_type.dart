import 'package:flutter/material.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/repport/rapport_provider.dart';
import 'package:newgps/src/view/repport/repport_type_model.dart';
import 'package:provider/provider.dart';

class AutoSearchType extends StatelessWidget {
  const AutoSearchType({super.key});

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
    context.select<RepportProvider, RepportTypeModel>((p) => p.selectedRepport);
    return GestureDetector(
      onTap: () => repportProvider.handleRepportType(),
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.topLeft,
        child: Container(
          width: 270,
          margin: const EdgeInsets.all(AppConsts.outsidePadding),
          child: Autocomplete<RepportTypeModel>(
            initialValue: const TextEditingValue(text: 'Rapport résumé'),
            fieldViewBuilder: (BuildContext context, TextEditingController _,
                FocusNode focusNode, Function onFieldSubmitted) {
              repportProvider.repportTextController = _;
              repportProvider.handleRepportType();
              return fieldViewBuilderWidget(
                repportProvider,
                outlineInputBorder,
                focusNode,
                onFieldSubmitted,
              );
            },
            displayStringForOption: (d) => d.title,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return repportProvider.repportsType;
              }
              return repportProvider.repportsType.where(
                (repportModel) {
                  return repportModel.title
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                },
              );
            },
            optionsViewBuilder: (BuildContext context,
                void Function(RepportTypeModel repportTypeModel) deviceFunc,
                repportsType) {
              return OptionViewBuilderWidget(
                repports: repportsType.toList(),
                onSelectDevice: deviceFunc,
                repportProvider: repportProvider,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget fieldViewBuilderWidget(
      RepportProvider repportProvider,
      OutlineInputBorder outlineInputBorder,
      FocusNode focusNode,
      Function onFieldSubmitted) {
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
          repportProvider.repportTextController.text = '';
          repportProvider.handleSelectDevice();
        },
        onFieldSubmitted: repportProvider.ontapEnterRepportType,
        decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          filled: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          border: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          enabledBorder: outlineInputBorder,
        ),
        controller: repportProvider.repportTextController,
        focusNode: focusNode,
      ),
    );
  }
}

class OptionViewBuilderWidget extends StatelessWidget {
  final List<RepportTypeModel> repports;
  final void Function(RepportTypeModel) onSelectDevice;
  final RepportProvider repportProvider;

  const OptionViewBuilderWidget({
    super.key,
    required this.repports,
    required this.onSelectDevice,
    required this.repportProvider,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        repportProvider.handleRepportType();
      },
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 270,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: AppConsts.mainColor, width: AppConsts.borderWidth),
                borderRadius: BorderRadius.circular(AppConsts.mainradius)),
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: repports.map<Widget>((repport) {
                  return OptionItem(
                    onSelectDevice: onSelectDevice,
                    repportProvider: repportProvider,
                    repportTypeModel: repport,
                  );
                }).toList()),
          ),
        ),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final RepportTypeModel repportTypeModel;
  const OptionItem({
    super.key,
    required this.onSelectDevice,
    required this.repportProvider,
    required this.repportTypeModel,
  });

  final void Function(RepportTypeModel p1) onSelectDevice;
  final RepportProvider repportProvider;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        repportTypeModel.title,
      ),
      onTap: () async {
        onSelectDevice(repportTypeModel);
        FocusScope.of(context).requestFocus(FocusNode());
        if (repportTypeModel.index == 0 && !repportProvider.selectAllDevices) {
          repportProvider.selectAllDevices = true;
          repportProvider.handleSelectDevice();
        } else if (repportTypeModel.index == 4) {
          if (repportProvider.selectAllDevices) {
            repportProvider.selectedDevice = deviceProvider.devices.first;
          }
          repportProvider.handleSelectDevice();
        } else if (repportTypeModel.index != 0 &&
            repportProvider.selectAllDevices) {
          repportProvider.selectedDevice = repportProvider.devices.first;
          repportProvider.selectAllDevices = false;
          repportProvider.handleSelectDevice();
        }
                repportProvider.selectedRepport = repportTypeModel;

      },
      minVerticalPadding: 0,
    );
  }
}
