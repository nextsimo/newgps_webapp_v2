import 'package:flutter/material.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';

class CustomAppBar extends PreferredSize {
  final double height;
  final void Function()? onTap;
  final List<Widget>? actions;

  const CustomAppBar(
      {Key? key, this.height = kToolbarHeight, this.actions, this.onTap})
      : super(
          key: key,
          child: const SizedBox(),
          preferredSize: const Size.fromHeight(kToolbarHeight),
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          actions: actions,
          backgroundColor: Colors.white,
          leading: Row(
            children: [
              Image.network('https://api.newgps.ma/api/icons/logo.svg'),
            ],
          ),
          title: MainButton(
            width: 300,
            height: 40,
            icon: Icons.call,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return Dialog(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 12),
                          MainButton(
                            width: 260,
                            onPressed: () {},
                            icon: Icons.phone_forwarded_rounded,
                            label: '0662782694',
                          ),
                          const SizedBox(height: 12),
                          MainButton(
                            width: 260,
                            onPressed: () {},
                            icon: Icons.phone_forwarded_rounded,
                            label: '‎0522304810',
                          ),
                          const SizedBox(height: 12),
                          MainButton(
                            width: 260,
                            onPressed: () {},
                            icon: Icons.phone_forwarded_rounded,
                            label: '0661599392',
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            label: 'Service aprés ventes',
          ),
        ),
      ),
    );
  }
}
