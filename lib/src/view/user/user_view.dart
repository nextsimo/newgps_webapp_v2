import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:newgps/src/models/user_model.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/navigation/top_app_bar.dart';
import 'package:newgps/src/view/user/user_drois_ui.dart';
import 'package:newgps/src/view/user/user_provider.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

import '../../widgets/loading_widget.dart';
import '../matricule/matricule_view.dart';
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
      child: const UserDataView(),
    );
  }
}

class UserDataView extends StatelessWidget {
  const UserDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    List<User> users = userProvider.users;
    return Scaffold(
      appBar: const CustomAppBar(
        actions: [],
      ),
      body: userProvider.loading
          ? const MyLoadingWidget()
          : _body(context, userProvider, users),
    );
  }

  Stack _body(
      BuildContext context, UserProvider userProvider, List<User> users) {
    return Stack(
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
                    padding: EdgeInsets.only(right: AppConsts.outsidePadding),
                    child: LogoutButton(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Column(
                  children: [
                    const _BuildHeader(),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: users.length,
                        itemBuilder: (BuildContext context, int index) {
                          return RowContent(
                            user: users[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BuildHeader extends StatelessWidget {
  const _BuildHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var borderSide =
        const BorderSide(color: Colors.black, width: AppConsts.borderWidth);
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        border: Border(bottom: borderSide, top: borderSide),
      ),
      child: Row(
        children: const [
          BuildDivider(),
          BuildTextCell('Utilisateur', flex: 2),
          BuildDivider(),
          BuildTextCell('Nom', flex: 2),
          BuildDivider(),
          BuildTextCell('Téléphone', flex: 2),
          BuildDivider(),
          BuildTextCell('Mot de passe', flex: 2),
          BuildDivider(),
          BuildTextCell('Droits', flex: 4),
          BuildDivider(),
          BuildTextCell('Véhicules', flex: 4),
          BuildDivider(),
          BuildTextCell('Actions', flex: 2),
          BuildDivider(),
        ],
      ),
    );
  }
}

class RowContent extends StatelessWidget {
  const RowContent({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: AppConsts.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          const BuildDivider(),
          EditableCell(
            content: user.userId,
            onchanged: (_) => user.newUserId = _,
            flex: 2,
          ),
          const BuildDivider(),
          EditableCell(
            content: user.displayName,
            onchanged: (_) => user.displayName = _,
            flex: 2,
          ),
          const BuildDivider(),
          EditableCell(
            content: user.contactPhone,
            onchanged: (_) => user.contactPhone = _,
            flex: 2,
          ),
          const BuildDivider(),
          EditableCellPassword(
            content: user.password,
            onchanged: (_) => user.password = _,
            flex: 2,
          ),
          const BuildDivider(),
          UserDroitsUi(
            userDroits: userProvider.userDroits.elementAt(user.index),
            flex: 4,
          ),
          const BuildDivider(),
          UserDevicesUi(
            user: user,
            flex: 4,
          ),
          const BuildDivider(),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        userProvider.confirmSaveUser(context, user, user.index);
                      },
                      icon: const Icon(Icons.save),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        userProvider.confirmDeleteUser(context, user);
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const BuildDivider(),
          /*  UserDevicesUi(
            user: user,
          ),
          const BuildDivider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MainButton(
              onPressed: () async {
                await userProvider.onSave(user, context, user.index);
              },
              label: 'Enregistrer',
              backgroundColor: Colors.green,
              height: 30,
            ),
          ),
          const BuildDivider(),
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
          ),
          const BuildDivider(), */
        ],
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.unknown,

        // etc.
      };
}

// editable cell password
class EditableCellPassword extends StatefulWidget {
  final String content;
  final int flex;
  final void Function(String val) onchanged;
  const EditableCellPassword(
      {Key? key, required this.content, required this.onchanged, this.flex = 1})
      : super(key: key);

  @override
  State<EditableCellPassword> createState() => _EditableCellPasswordState();
}

class _EditableCellPasswordState extends State<EditableCellPassword> {
  final TextEditingController _controller = TextEditingController();
  bool _isObscure = true;

  Widget _buildObscureButton() {
    return IconButton(
      icon: Icon(
        _isObscure ? Icons.visibility : Icons.visibility_off,
        color: Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _isObscure = !_isObscure;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.content;
    return Expanded(
      flex: widget.flex,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onchanged,
              onTap: () => {
                _controller.selection = TextSelection(
                    baseOffset: 0, extentOffset: _controller.text.length)
              },
              maxLines: 1,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                // add obscure button
              ),
              obscureText: _isObscure,
            ),
          ),
          _buildObscureButton(),
        ],
      ),
    );
  }
}
