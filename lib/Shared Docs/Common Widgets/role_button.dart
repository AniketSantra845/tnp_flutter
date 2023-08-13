import 'package:flutter/material.dart';

import '../../Screens/Login.dart';
import '../Constant Files/constants.dart';
import '../Constant Files/size_config.dart';
import '../../Models/roles.dart';

class RolesButton extends StatelessWidget {
  const RolesButton({
    super.key,
    required this.role,
  });

  final Roles role;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 400,
        height: getProportionateScreenHeight(56),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: kPrimaryColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(role: role),
              ),
            );
          },
          child: Text(
            role.role,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
