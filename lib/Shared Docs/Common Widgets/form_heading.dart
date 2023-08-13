import 'package:flutter/material.dart';

import '../Constant Files/constants.dart';
import '../Constant Files/size_config.dart';

class FormHeading extends StatelessWidget {
  final String text;
  const FormHeading({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: SizeConfig.screenWidth / 15,
        color: kPrimaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
