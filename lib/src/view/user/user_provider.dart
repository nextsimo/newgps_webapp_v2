import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/user_droits.dart';
import 'package:newgps/src/models/user_model.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];

  List<UserDroits> userDroits = [];

  List<User> get users => _users;

  List<String> devices = [];

  set users(List<User> users) {
    _users = users;
    notifyListeners();
  }

  bool empyRowExist() {
    if (_users.isEmpty) return false;

    bool exist = _users.first.userId.isEmpty;

    return exist;
  }

  Future<void> deleteUser(User user) async {
    if (user.userId.isEmpty) {
      _users.remove(user);
    } else {
      Account? account = shared.getAccount();
      debugPrint("${user.toJson()}");
      String res = await api.post(url: '/user/delete', body: {
        'account_id': account?.account.accountId,
        'data': json.encode(user.toJson())
      });

      if (res.isNotEmpty) {
        _users.remove(user);
      }
    }
    notifyListeners();
  }

  Future<void> onSave(User newUser, BuildContext context, int index) async {
    bool res = false;
    if (newUser.userId.isEmpty) {
      res = await addNewuser(newUser, index);
    } else {
      res = await updateUser(newUser, index);
    }

    if (!res) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Nom utilisateur déja exister'),
          actions: [
            MainButton(
              onPressed: () => Navigator.of(context).pop(),
              label: 'Fermer',
            ),
          ],
        ),
      );
    } else {
      fetchUsers();
    }
  }

  Future<bool> addNewuser(User newUser, int index) async {
    // save the new matricule
    Account? account = shared.getAccount();
    debugPrint("${newUser.toJson()}");
    String res = await api.post(url: '/user/add', body: {
      'account_id': account?.account.accountId,
      'data': json.encode(newUser.toJson())
    });

    if (res.isEmpty) {
      // user exist
      log("user exist");
      return false;
    }
    await createNewUserDroits(index);
    return true;
  }

  Future<void> fetchUserDroits() async {
    Account? account = shared.getAccount();
    for (var user in users) {
      String res = await api.post(url: '/user/droits/show', body: {
        'account_id': account!.account.accountId,
        'user_id': user.userId,
      });
      userDroits.add(userDroitsFromJson(res));
    }
  }

  Future<bool> updateUser(User newUser, int index) async {
    Account? account = shared.getAccount();
    await updateUserDroits(index);
    String res = await api.post(url: '/user/update', body: {
      'account_id': account?.account.accountId,
      'data': json.encode(newUser.toJson()),
    });
    if (res.isEmpty) {
      log("user exist");
      return false;
    }
    return true;
  }

  Future<void> updateUserDroits(int index) async {
    debugPrint(json.encode(userDroits.elementAt(index)));

    await api.post(url: '/user/droits/update', body: {
      'droits': json.encode(userDroits.elementAt(index)),
    });
  }

  Future<void> createNewUserDroits(int index) async {
    debugPrint(json.encode(userDroits.elementAt(index)));
    await api.post(url: '/user/droits/create', body: {
      'droits': json.encode(userDroits.elementAt(index)),
    });
  }

  void addUserUi() {
    if (empyRowExist()) return;
    _users.insert(
      0,
      User(
        index: 0,
        userId: '',
        displayName: '',
        contactPhone: '',
        password: '',
        devices: [],
      ),
    );

    notifyListeners();
  }

  UserProvider() {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    Account? account = shared.getAccount();
    String res;
    res = await api.post(
      url: '/users/index',
      body: {'account_id': account?.account.accountId},
    );
    if (res.isNotEmpty) {
      _users = userFromJson(res);
      await fetchUserDroits();
      notifyListeners();
    }
  }
}
