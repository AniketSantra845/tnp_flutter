import 'package:flutter/material.dart';

import '../Shared Docs/Common Widgets/role_button.dart';
import '../Shared Docs/Constant Files/constants.dart';
import '../Shared Docs/Constant Files/size_config.dart';
import '../../Models/roles.dart';

class Actor extends StatefulWidget {
  const Actor({Key? key}) : super(key: key);

  @override
  State<Actor> createState() => _ActorState();
}

class _ActorState extends State<Actor> {
  List<Roles> roles = allRoles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 100,
                width: 150,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              const Text(
                'Placement',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 44,
                  color: kPrimaryColor,
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.03),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: roles.length,
                  itemBuilder: (context, index) {
                    final role = roles[index];
                    return RolesButton(role: role);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
