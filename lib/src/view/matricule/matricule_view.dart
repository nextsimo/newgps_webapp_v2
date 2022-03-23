import 'package:flutter/material.dart';
import 'package:newgps/src/models/matricule.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/login/login_as/save_account_provider.dart';
import 'package:newgps/src/view/matricule/matricule_provider.dart';
import 'package:newgps/src/view/navigation/top_app_bar.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:newgps/src/widgets/inputs/search_widget.dart';
import 'package:provider/provider.dart';

class MatriculeView extends StatelessWidget {
  const MatriculeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MatriculeProvider>(
      create: (_) => MatriculeProvider(),
      builder: (BuildContext context, Widget? child) {
        return child ?? const SizedBox();
      },
      child: const MatriculeDataView(),
    );
  }
}

class MatriculeDataView extends StatelessWidget {

  const MatriculeDataView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    MatriculeProvider matriculeProvider =
        Provider.of<MatriculeProvider>(context);
    List<MatriculeModel> matricules = matriculeProvider.matricules;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: const CustomAppBar(
          actions: [],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SearchWidget(
                      hint: 'Entrer matricule',
                      onChnaged: matriculeProvider.search,
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(right: AppConsts.outsidePadding),
                  child: LogoutButton(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  const BuildHead(),
                  Expanded(
                    child: SizedBox(
                      width: size.width,
                      child: ListView.builder(
                        itemCount: matricules.length,
                        itemBuilder: (_, int index) {
                          MatriculeModel matricule =
                              matricules.elementAt(index);
                          return MatriculeRowContent(matricule: matricule);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ))
          ],
        ));
  }
}

class BuildHead extends StatelessWidget {
  const BuildHead({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[7];
    var borderSide = const BorderSide(
        color: AppConsts.mainColor, width: AppConsts.borderWidth);
    return Container(
      decoration: BoxDecoration(
        color: AppConsts.mainColor.withOpacity(0.2),
        border: Border(bottom: borderSide, top: borderSide),
      ),
      child: Row(
        children: [
          const BuildDivider(),
          const BuildTextCell('N'),
          const BuildDivider(),
          const BuildTextCell('WW', flex: 3),
          const BuildDivider(),
          const BuildTextCell('Marque', flex: 2),
          const BuildDivider(),
          const BuildTextCell('Couleur', flex: 2),
          const BuildDivider(),
          const BuildTextCell('Matricule', flex: 3),
          const BuildDivider(),
          const BuildTextCell('Nom chauffeur', flex: 3),
          const BuildDivider(),
          const BuildTextCell('Téléphone 1', flex: 3),
          const BuildDivider(),
          const BuildTextCell('Téléphone 2', flex: 3),
          const BuildDivider(),
          const BuildTextCell('Kilométrage actuel', flex: 3),
          const BuildDivider(),
          const BuildTextCell('Réservoir en litre', flex: 3),
          if (droit.write) const BuildDivider(),
          if (droit.write)
            const SizedBox(
                width: 120,
                child: Center(
                  child: Text(
                    'Enregistrement',
                  ),
                )),
          const BuildDivider(),
        ],
      ),
    );
  }
}

class MatriculeRowContent extends StatelessWidget {
  const MatriculeRowContent({
    Key? key,
    required this.matricule,
  }) : super(key: key);

  final MatriculeModel matricule;

  @override
  Widget build(BuildContext context) {
    MatriculeProvider provider =
        Provider.of<MatriculeProvider>(context, listen: false);
    var droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[7];
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppConsts.mainColor,
            width: AppConsts.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          const BuildDivider(),

          BuildTextCell('${matricule.index}'),
          const BuildDivider(),
          EditableCell(
            content: matricule.vehicleId,
            onchanged: (_) => matricule.vehicleId = _,
            flex: 3,
          ),
          const BuildDivider(),
          EditableCell(
            content: matricule.vehicleModel,
            onchanged: (_) => matricule.vehicleModel = _,
            flex: 2,
          ),
          const BuildDivider(),

          EditableCell(
            content: matricule.vehicleColor,
            onchanged: (_) => matricule.vehicleColor = _,
            flex: 2,
          ),
          const BuildDivider(),
          //BuildTextCell(matricule.description),
          EditableCell(
            content: matricule.description,
            onchanged: (_) => matricule.description = _,
            flex: 3,
          ),
          const BuildDivider(),
          EditableCell(
            content: matricule.driverName,
            onchanged: (_) => matricule.driverName = _,
            flex: 3,
          ),
          const BuildDivider(),
          EditableCell(
            content: matricule.phone1,
            onchanged: (_) => matricule.phone1 = _,
            flex: 3,
          ),
          const BuildDivider(),
          EditableCell(
            content: matricule.phone2,
            onchanged: (_) => matricule.phone2 = _,
            flex: 3,
          ),
          const BuildDivider(),
          EditableCell(
            content: '${matricule.lastOdometerKM}',
            onchanged: (_) => matricule.lastOdometerKM = double.parse(_),
            flex: 3,
          ),
          const BuildDivider(),
          EditableCell(
            content: '${matricule.fuelCapacity}',
            onchanged: (_) => matricule.fuelCapacity = int.parse(_),
            flex: 3,
          ),
          if (droit.write) const BuildDivider(),
          if (droit.write)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MainButton(
                onPressed: () async =>
                    await provider.onSave(matricule, context),
                height: 26,
                label: 'Enregister',
                backgroundColor: Colors.green,
                width: 104,
              ),
            ),
          const BuildDivider(),
        ],
      ),
    );
  }
}

class BuildDivider extends StatelessWidget {
  const BuildDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConsts.borderWidth,
      color: AppConsts.mainColor,
      height: 48,
    );
  }
}

class EditableCell extends StatelessWidget {
  final String content;
  final int flex;
  final void Function(String val) onchanged;
  EditableCell(
      {Key? key, required this.content, required this.onchanged, this.flex = 1})
      : super(key: key);

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[7];
    _controller.text = content;
    return Expanded(
      flex: flex,
      child: TextField(
        readOnly: !droit.write,
        controller: _controller,
        onChanged: onchanged,
        onTap: () => {
          _controller.selection = TextSelection(
              baseOffset: 0, extentOffset: _controller.text.length)
        },
        maxLines: 1,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class BuildTextCell extends StatelessWidget {
  final String content;
  final Color color;
  final int flex;

  const BuildTextCell(this.content,
      {Key? key, this.color = Colors.black, this.flex = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          content,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
