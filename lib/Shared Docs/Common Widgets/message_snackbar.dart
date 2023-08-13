import 'package:flutter/material.dart';

void showMessageSnackBar(
    BuildContext context, String message, Color backgroundColor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: backgroundColor,
    ),
  );
}
