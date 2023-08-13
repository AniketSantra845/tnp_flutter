import 'package:flutter/material.dart';
import '../Constant Files/size_config.dart';
import 'custom_suffix_icon.dart';

class SearchTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const SearchTextField({
    super.key,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
          ),
        ],
      ),
      margin: const EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
      ),
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 20.0),
            child: const CustomSuffixIcon(
              svgIcon: "assets/icons/search.svg",
            ),
          ),
          labelText: "Search here...",
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
