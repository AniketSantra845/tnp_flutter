// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:placements/Controllers/department_controller.dart';
import 'package:placements/Models/departments.dart';

import '../../Controllers/session_controller.dart';
import '../../Controllers/user_controller.dart';
import '../../Models/sessions.dart';
import '../../Models/users.dart';
import '../../Shared Docs/Common Widgets/default_button.dart';
import '../../Shared Docs/Common Widgets/dropdown_field.dart';
import '../../Shared Docs/Common Widgets/error_dialog.dart';
import '../../Shared Docs/Common Widgets/form_heading.dart';
import '../../Shared Docs/Common Widgets/message_snackbar.dart';
import '../../Shared Docs/Common Widgets/text_form_field.dart';
import '../../Shared Docs/Constant Files/constants.dart';
import '../../Shared Docs/Constant Files/size_config.dart';

class AddUserDetails extends StatefulWidget {
  final UserFromUIToDB? user;
  const AddUserDetails({super.key, this.user});

  @override
  State<AddUserDetails> createState() => _AddUserDetailsState();
}

class _AddUserDetailsState extends State<AddUserDetails> {
  final _formKey = GlobalKey<FormState>();

  List<Session> _sessions = [];
  List<Departments> _departments = [];

  int? _id;
  int? _sessionId;

  int? _departmentId;
  String? _userName;
  String? _password;
  String? _email;

  @override
  void initState() {
    super.initState();

    _id = widget.user?.id ?? 0;
    _sessionId = widget.user?.session_id;
    _departmentId = widget.user?.department_id;
    _userName = widget.user?.name ?? '';
    _password = widget.user?.password ?? '';
    _email = widget.user?.email ?? '';

    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user == null
              ? "A D D    N E W    U S E R"
              : "U P D A T E    U S E R"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  const FormHeading(text: 'User Details'),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  _userFormLayoutBuilder(),
                  const SizedBox(height: 50),
                  DefaultButton(
                    text: widget.user == null ? "SAVE" : "UPDATE",
                    onPressed: saveUser,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (widget.user == null) {
          await _insertNewUser();
        } else {
          await _updateExistingUser();
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              errorMessage: 'Failed to save user: $e',
            );
          },
        );
      }
    }
  }

  Future<void> _insertNewUser() async {
    final newUser = UserFromUIToDB(
      session_id: _sessionId!,
      department_id: _departmentId!,
      name: _userName!,
      password: _password!,
      email: _email!,
      role: 1,
    );
    bool result = await UserController().createUser(newUser);

    if (result) {
      showMessageSnackBar(context, 'User created successfully', Colors.green);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
            errorMessage: 'User already exists!',
          );
        },
      );
    }
  }

  Future<void> _updateExistingUser() async {
    final updatedUser = UserFromUIToDB(
      id: _id!,
      session_id: _sessionId!,
      department_id: _departmentId!,
      name: _userName!,
      password: _password!,
      email: _email!,
    );
    bool result = await UserController().updateUser(updatedUser);

    if (result) {
      showMessageSnackBar(
          context, 'User details updated successfully', Colors.green);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
            errorMessage: 'Somthing went wrong: Failed to update user details',
          );
        },
      );
    }
  }

  LayoutBuilder _userFormLayoutBuilder() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownFormField<int>(
                  labelText: 'Batch',
                  hintText: 'Select Batch',
                  value: _sessionId,
                  items: _sessions
                      .map((e) => DropdownMenuItem<int>(
                            value: e.id,
                            child: Text(e.label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _sessionId = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please Select Batch' : null,
                ),
                const SizedBox(height: 20),
                DropdownFormField<int>(
                  labelText: 'Department',
                  hintText: 'Select Department',
                  value: _departmentId,
                  items: _departments
                      .map((e) => DropdownMenuItem<int>(
                            value: e.id,
                            child: Text(
                              e.department,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 1,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _departmentId = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please Select Department' : null,
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  labelText: 'User Name',
                  hintText: 'Enter User Name',
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter User Name';
                    } else if (!alphaValidatorRegExp.hasMatch(value)) {
                      return 'Please Enter Only Characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _userName = value;
                    });
                  },
                  initialValue: _userName,
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  labelText: 'Email Id',
                  hintText: 'Enter Email Id',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return kEmailNullError;
                    } else if (!emailValidatorRegExp.hasMatch(value)) {
                      return kInvalidEmailError;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  initialValue: _email,
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  labelText: 'Password',
                  hintText: 'Enter Password',
                  keyboardType: TextInputType.text,
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
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  initialValue: _password,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _fetchData() async {
    try {
      final sessions = await SessionController().getSessions();
      final departments = await DepartmentController().getDepartments();

      setState(() {
        _sessions = sessions;
        _departments = departments;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMessage: 'Failed to fetch data: $e',
          );
        },
      );
    }
  }
}
