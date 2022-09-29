import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/view/login/login_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:newgps/src/widgets/buttons/outlined_button.dart';
import 'package:newgps/src/widgets/inputs/main_input.dart';
import 'package:newgps/src/widgets/inputs/password_input.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import 'call_service_view.dart';
import 'change_password_view.dart';
import 'login_as/login_as_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginProvider provider = Provider.of<LoginProvider>(context, listen: false);
    final loginButton = MainButton(
        label: 'Se connecter', onPressed: () => provider.login(context));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 400,
          child: Form(
            key: provider.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network('${Utils.baseUrl}/icons/logo.svg',
                    width: 100),
                const SizedBox(height: 20),
                MainInput(
                  icon: Icons.folder,
                  hint: 'Compte',
                  controller: provider.compteController,
                  validator: FormValidatorService.isNotEmpty,
                  onEditeComplete: () => FocusScope.of(context).nextFocus(),
                ),
                const SizedBox(height: 10),
                PasswordInput(
                  icon: Icons.lock,
                  hint: 'Mot de passe',
                  controller: provider.passwordController,
                  validator: FormValidatorService.isNotEmpty,
                  onEditeComplete: () => loginButton.onPressed(),
                ),
                const SizedBox(height: 10),
                MainInput(
                  icon: Icons.person,
                  hint: 'Sous utilisateur',
                  controller: provider.underCompteController,
                  onEditeComplete: () => FocusScope.of(context).nextFocus(),
                ),
                const SizedBox(height: 20),
                loginButton,
                const SizedBox(height: 10),
                CustomOutlinedButton(
                  width: double.infinity,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        child: ChangePasswordView(
                          context: context,
                        ),
                      ),
                    );
                  },
                  label: 'Changer le mot de passe',
                ),
                const SizedBox(height: 10),
                const LoginAsView(),
                const SizedBox(height: 10),
                Selector<LoginProvider, String>(
                  builder: (_, String error, __) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        error,
                        style:  GoogleFonts.roboto(
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                  selector: (_, __) => __.errorText,
                ),
                const SizedBox(height: 10),
                const CallServiceView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
