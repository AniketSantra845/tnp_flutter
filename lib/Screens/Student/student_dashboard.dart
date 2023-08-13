import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Shared Docs/Constant Files/constants.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key, required this.user});

  final String user;

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          bool shouldExit = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Confirmation',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: const Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'No',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                    ),
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            },
          );
          if (shouldExit) {
            if (Platform.isAndroid || Platform.isIOS) {
              SystemNavigator.pop(); // Close the app on mobile platforms
            }
            if (kIsWeb) {
              SystemChannels.platform.invokeMethod(
                  'SystemNavigator.pop'); // Close the browser window/tab on the web
            }
            SystemNavigator.pop(); // Terminate the application
          }
          return false; // Prevent default back button behavior
        },
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  const Text("S T U D E N T  D A S H B O A R D"),
                  Text(widget.user),
                ],
              ),
            ),
          ),
        ),
      );
}
