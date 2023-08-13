import 'dart:async';
import 'package:flutter/material.dart';
import 'package:placements/Screens/Coordinator/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Shared Docs/Constant Files/constants.dart';
import '../Shared Docs/Constant Files/size_config.dart';
import 'actor.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;
  bool _isLoggedIn = false; // Add this variable to track login status

  _SplashScreenState() {
    Timer(const Duration(milliseconds: 2000), () {
      if (_isLoggedIn) {
        // User is logged in, redirect to main screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const CoordinatorMainScreen()),
          (route) => false,
        );
      } else {
        // User is not logged in, redirect to actor page for login
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Actor()),
          (route) => false,
        );
      }
    });

    Timer(const Duration(milliseconds: 10), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // Function to check login status using shared preferences
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColor, kPrimaryColor],
          begin: FractionalOffset(0, 0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: const Duration(microseconds: 1200),
        child: Center(
            child: Container(
          height: 140.0,
          width: 140.0,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: bgColor, boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2.0,
              offset: const Offset(5.0, 3.0),
              spreadRadius: 2.0,
            )
          ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 100,
                width: 100,
              )
            ],
          ),
        )),
      ),
    );
  }
}
