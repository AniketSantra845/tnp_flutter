import 'package:flutter/material.dart';

import '../Constant Files/constants.dart';

class DropdownFormField<T> extends StatelessWidget {
  final String labelText;
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  DropdownFormField({
    required this.labelText,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
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
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      isExpanded: true,
    );
  }
}
