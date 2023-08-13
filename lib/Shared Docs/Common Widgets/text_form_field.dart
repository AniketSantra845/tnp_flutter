import 'package:flutter/material.dart';

import '../Constant Files/constants.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String) onChanged;
  final String? initialValue;
  final int? minLines;
  final int? maxLines;

  const TextFormFieldWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.keyboardType,
    required this.validator,
    required this.onChanged,
    this.initialValue,
    this.minLines,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        floatingLabelStyle: const TextStyle(color: kPrimaryColor),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
      initialValue: initialValue,
    );
  }
}
