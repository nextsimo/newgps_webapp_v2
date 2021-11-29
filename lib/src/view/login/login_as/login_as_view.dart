import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/view/historic/historic_provider.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:newgps/src/view/login/login_as/save_account_provider.dart';
import 'package:provider/provider.dart';

class LoginAsView extends StatelessWidget {
  const LoginAsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SavedAcountProvider>(
        create: (_) => SavedAcountProvider(),
        builder: (BuildContext proContext, __) {
          return Consumer<SavedAcountProvider>(
              builder: (context, provider, __) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                if (provider.savedAcounts.isNotEmpty)
                  const Text(
                    'Se connecter en tant que',
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    runSpacing: 7,
                    alignment: WrapAlignment.spaceBetween,
                    children: provider.savedAcounts
                        .map(
                          (account) =>
                              _BuildLoginAsWidget(savedAccount: account),
                        )
                        .toList(),
                  ),
                ),
              ],
            );
          });
        });
  }
}

class _BuildLoginAsWidget extends StatefulWidget {
  final SavedAccount savedAccount;
  const _BuildLoginAsWidget({
    Key? key,
    required this.savedAccount,
  }) : super(key: key);

  @override
  State<_BuildLoginAsWidget> createState() => _BuildLoginAsWidgetState();
}

class _BuildLoginAsWidgetState extends State<_BuildLoginAsWidget> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final SavedAcountProvider provider =
        Provider.of<SavedAcountProvider>(context, listen: false);
    return SizedBox(
      width: 195,
      child: ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.blueAccent),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
        onPressed: () async {
          // log('Bearer ${savedAccount.key}');
          setState(() => loading = true);
          Account? account;
          if (widget.savedAccount.underUser != null &&
              widget.savedAccount.underUser!.isNotEmpty) {
            account = await api.underAccountLogin(
              accountId: widget.savedAccount.user ?? "",
              password: widget.savedAccount.key ?? "",
              underAccountLogin: widget.savedAccount.underUser ?? "",
            );
          } else {
            account = await api.login(
              accountId: widget.savedAccount.user ?? "",
              password: widget.savedAccount.key ?? "",
            );
          }
          if (account != null) {
            final HistoricProvider historicProvider =
                Provider.of<HistoricProvider>(context, listen: false);
            final LastPositionProvider lastPositionProvider =
                Provider.of<LastPositionProvider>(context, listen: false);
            lastPositionProvider.fresh();
            await shared.saveAccount(account);
            await fetchInitData(
                historicProvider: historicProvider,
                lastPositionProvider: lastPositionProvider,
                context: context);
            setState(() => loading = false);

            Navigator.of(context).pushNamed('/');
          } else {
            ///errorText = 'Mot de passe ou account est inccorect';
          }
/*           String src = await api.post(
              body: {
                'accountId': savedAccount.user,
                'userID': savedAccount.underUser,
              },
              url: '/profile',
              newHeader: {
                HttpHeaders.authorizationHeader: 'Bearer ${savedAccount.key}'
              });
          Account? account = accountFromMap(src);
          account!.token = savedAccount.key;
          final HistoricProvider historicProvider =
              Provider.of<HistoricProvider>(context, listen: false);
                        final LastPositionProvider lastPositionProvider =
              Provider.of<LastPositionProvider>(context, listen: false);
          shared.saveAccount(account);
          fetchInitData(historicProvider: historicProvider,lastPositionProvider: lastPositionProvider, context: context);
          nav.pushNamedAndRemoveUntil(Routes.customNavigationView); */
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (loading)
              const SizedBox(
                width: 15,
                height: 15,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            if (!loading)
              const Icon(
                Icons.account_circle,
              ),
            Text(
              widget.savedAccount.underUser!.isNotEmpty
                  ? widget.savedAccount.underUser!.toUpperCase()
                  : widget.savedAccount.user!.toUpperCase(),
            ),
            IconButton(
              iconSize: 19,
              icon: const Icon(Icons.close),
              onPressed: () => provider.deleteAcount(widget.savedAccount.user),
            ),
          ],
        ),
      ),
    );
  }
}
