import 'package:flutter/material.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:provider/provider.dart';

import '../../widgets/inputs/main_input.dart';
import 'login_provider.dart';

class SousUserCheck extends StatelessWidget {
  const SousUserCheck({super.key});

  @override
  Widget build(BuildContext context) {
    LoginProvider provider = context.read<LoginProvider>();
    bool val =
        context.select((LoginProvider provider) => provider.isUnderCompte);
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Sous utilisateur'),
          value: val,
          onChanged: provider.setUnderCompte,
        ),
        if (val)
          Column(
            children: [
              const SizedBox(height: 10),
              MainInput(
                icon: Icons.person,
                hint: 'Sous utilisateur',
                controller: provider.underCompteController,
                validator:FormValidatorService.isNotEmpty,
                onEditeComplete: () => FocusScope.of(context).nextFocus(),
              ),
            ],
          ),
      ],
    );
  }
}
