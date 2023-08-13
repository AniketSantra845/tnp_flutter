// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:placements/Screens/actor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constant Files/constants.dart';
import '../Constant Files/size_config.dart';

class LogoutSection extends StatefulWidget {
  const LogoutSection({
    super.key,
  });

  @override
  State<LogoutSection> createState() => _LogoutSectionState();
}

class _LogoutSectionState extends State<LogoutSection> {
  void _logoutAndNavigate(BuildContext context) {
    _logout(context);
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Actor()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          onTap: () => _logoutAndNavigate(context),
          leading: const Icon(Icons.logout, color: kPrimaryColor),
          title: Text(
            "Log Out",
            style: TextStyle(
                fontSize: SizeConfig.screenWidth / 23,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
