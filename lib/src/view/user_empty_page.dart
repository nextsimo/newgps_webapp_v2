import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';

import 'navigation/top_app_bar.dart';

class UserEmptyPage extends StatelessWidget {
  const UserEmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
           const  Positioned(
              left: 0,
              top: 0,
              child:  Padding(
                padding: EdgeInsets.only(top: AppConsts.outsidePadding),
                child: LogoutButton(),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.block, size: 99, color: Colors.orange),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Acces interdit...",
                      style: Theme.of(context).textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "vous n'avez pas l'autorisation d'accéder contactez l'administrateur de votre compte",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
