import 'package:flutter/material.dart';

const bgColor = Color(0xFFF5F5F5);
const kPrimaryColor = Color(0xFFFA5748);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kSecondaryColor = Color(0xFF2D4262);
const kTextColor = Color(0xFF757575);
const kSecondaryTextColor = Color(0xFF006600);

const kAnimationDuration = Duration(milliseconds: 200);
const defaultDuration = Duration(milliseconds: 250);

const defaultPadding = 16.0;

// My Text Styles
const kheadingStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  height: 1.5,
);

const kSubheadingextStyle = TextStyle(
  fontSize: 20,
  color: Color(0xFF61688B),
  height: 2,
);

// Form Error
const String kUserNameNullError = "Please Enter your Username";
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";

const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kLongPassError = "Password is too long";
const String kMatchPassError = "Passwords don't match";

const String kFirstNamelNullError = "Please Enter your first name";
const String kLastNamelNullError = "Please Enter your last name";
const String kPhoneNumberNullError = "Please Enter phone number";
const String kAddressNullError = "Please Enter your address";

const String kCIFError = "Please Enter Company's Identification number";
const String kCompanyName = "Please Enter Company Name";
const String kAboutCompany = "Please Enter Details About Company";

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp phoneNumberValidatorRegExp = RegExp(r'^(?:[+0][1-9])?[0-9]{10}$');
final RegExp alphaValidatorRegExp = RegExp(r'^[a-z A-Z()-.]+$');
final RegExp numericValidatorRegExp = RegExp(r'^[0-9-]+$');
