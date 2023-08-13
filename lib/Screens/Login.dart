// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:placements/Screens/Member/member_dashboard.dart';
import 'package:placements/Screens/Student/student_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Shared Docs/Common Widgets/custom_suffix_icon.dart';
import '../Shared Docs/Common Widgets/default_button.dart';
import '../Shared Docs/Constant Files/constants.dart';
import '../Shared Docs/Constant Files/size_config.dart';
import '../../Models/roles.dart';
import 'Coordinator/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.role});

  final Roles role;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.20),
              const Text(
                'Login',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 45,
                  color: kPrimaryColor,
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.01),
              Text(widget.role.role),
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              loginForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Padding loginForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(25),
        vertical: getProportionateScreenHeight(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            children: [
              buildEmailFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildPasswordFormField(),
              SizedBox(height: getProportionateScreenHeight(60)),
              DefaultButton(
                text: "Continue",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // If all are valid then go to success screen

                    /*
                      Role ids: 
                        1 = C O O R D I N A T O R
                        2 = M E M B E R
                        3 = S T U D E N T
                    */

                    var prefs = await SharedPreferences.getInstance();
                    prefs.setBool('isLoggedIn', true);

                    if (widget.role.id == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CoordinatorMainScreen(),
                        ),
                      );
                    } else if (widget.role.id == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemberDashboard(user: email!),
                        ),
                      );
                    } else if (widget.role.id == 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentDashboard(user: email!),
                        ),
                      );
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return kPassNullError;
        } else if (value.length < 8) {
          return kShortPassError;
        } else if (value.length > 15) {
          return kLongPassError;
        }
        return null;
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelStyle: TextStyle(color: kPrimaryColor),
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => email = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return kInvalidEmailError;
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelStyle: TextStyle(color: kPrimaryColor),
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
