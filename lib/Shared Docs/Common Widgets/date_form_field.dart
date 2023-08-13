import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Constant Files/constants.dart';

class DateFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final DateTime? selectedDate;
  final Function(DateTime?) onChanged;

  const DateFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.selectedDate,
    required this.onChanged,
  });

  @override
  _DateFormFieldState createState() => _DateFormFieldState();
}

class _DateFormFieldState extends State<DateFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
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
      readOnly: true,
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: widget.selectedDate ?? DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 5),
          lastDate: DateTime(DateTime.now().year + 5),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: kPrimaryColor,
                  onPrimary: Colors.white,
                  onSurface: kPrimaryColor,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: kPrimaryColor,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        if (selectedDate != null) {
          widget.onChanged(selectedDate);
          widget.controller.text =
              DateFormat('dd-MM-yyyy').format(selectedDate);
        }
      },
    );
  }
}
