import 'package:flutter/material.dart';
import 'package:newgps/src/models/user_model.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/navigation/top_app_bar.dart';
import 'package:newgps/src/view/user/user_drois_ui.dart';
import 'package:newgps/src/view/user/user_provider.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

import 'user_devices_ui.dart';

class UsersView extends StatelessWidget {
  const UsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (_) => UserProvider(),
      builder: (BuildContext context, Widget? child) {
        return child ?? const SizedBox();
      },
      child: UserDataView(),
    );
  }
}

class UserDataView extends StatelessWidget {
  UserDataView({Key? key}) : super(key: key);

  final List<String> _items = [
    'Utilisateur',
    'Nom complet',
    'Téléphone',
    'Mot de passe utilisateur',
    'Droits utilisateur',
    'Véhicules',
    'Enregistrement',
    'Supression',
  ];

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    List<User> users = userProvider.users;
    return Scaffold(
        appBar: const CustomAppBar(
          actions: [],
        ),
        body: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MainButton(
                          width: 200,
                          onPressed: () async {
                            userProvider.addUserUi();
                          },
                          height: 30,
                          label: 'Ajuoter utilisateur',
                          backgroundColor: AppConsts.mainColor,
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.only(right: AppConsts.outsidePadding),
                        child: LogoutButton(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Table(
                        border: TableBorder.all(color: Colors.grey),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        children: [
                          TableRow(
                              decoration: BoxDecoration(
                                  color: AppConsts.mainColor.withOpacity(0.2)),
                              children: _items.map<Widget>((item) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    item,
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }).toList()),
                          ...users.map<TableRow>((user) {
                            return TableRow(children: [
                              EditableCell(
                                content: user.userId,
                                autofocus: user.userId.isEmpty,
                                onchanged: (_) => user.newUserId = _,
                              ),
                              EditableCell(
                                content: user.displayName,
                                onchanged: (_) => user.displayName = _,
                              ),
                              EditableCell(
                                content: user.contactPhone,
                                onchanged: (_) => user.contactPhone = _,
                              ),
                              EditableCell(
                                content: user.password,
                                onchanged: (_) => user.password = _,
                              ),
                              UserDroitsUi(
                                userDroits: userProvider.userDroits
                                    .elementAt(user.index),
                              ),
                              UserDevicesUi(
                                user: user,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MainButton(
                                  onPressed: () async {
                                    await userProvider.onSave(
                                        user, context, user.index);
                                  },
                                  label: 'Enregistrer',
                                  backgroundColor: Colors.green,
                                  height: 30,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MainButton(
                                  onPressed: () async {
                                    // Supprimer
                                    await userProvider.deleteUser(user);
                                  },
                                  label: 'Supprimer',
                                  backgroundColor: Colors.red,
                                  height: 30,
                                ),
                              )
                            ]);
                          }).toList()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

/*         const SizedBox(

            width: ,

        ), */
          ],
        ));
  }
}

class EditableCell extends StatelessWidget {
  final bool autofocus;
  final String content;
  final void Function(String val) onchanged;
  EditableCell(
      {Key? key,
      required this.content,
      required this.onchanged,
      this.autofocus = false})
      : super(key: key);

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _controller.text = content;
    return TextField(
      autofocus: autofocus,
      controller: _controller,
      onChanged: onchanged,
      onTap: () => {
        _controller.selection =
            TextSelection(baseOffset: 0, extentOffset: _controller.text.length)
      },
      maxLines: 1,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
      ),
    );
  }
}

class BuildTextCell extends StatelessWidget {
  final String content;
  final Color color;

  const BuildTextCell(this.content, {Key? key, this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        content,
        textAlign: TextAlign.center,
      ),
    );
  }
}
