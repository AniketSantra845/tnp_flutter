// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:placements/Controllers/department_controller.dart';
import 'package:placements/Models/departments.dart';
import 'package:placements/Shared%20Docs/Common%20Widgets/default_button.dart';

import '../../Shared Docs/Common Widgets/error_dialog.dart';
import '../../Shared Docs/Common Widgets/form_heading.dart';
import '../../Shared Docs/Common Widgets/message_snackbar.dart';
import '../../Shared Docs/Common Widgets/text_form_field.dart';
import '../../Shared Docs/Constant Files/constants.dart';
import '../../Shared Docs/Constant Files/size_config.dart';

class AddDepartmentDetails extends StatefulWidget {
  final Departments? department;
  const AddDepartmentDetails({super.key, this.department});

  @override
  State<AddDepartmentDetails> createState() => _AddDepartmentDetailsState();
}

class _AddDepartmentDetailsState extends State<AddDepartmentDetails> {
  final _formKey = GlobalKey<FormState>();

  int? _id;
  String? _department;
  String? _remarks;

  @override
  void initState() {
    super.initState();

    _id = widget.department?.id ?? 0;
    _department = widget.department?.department ?? '';
    _remarks = widget.department?.remarks ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.department == null
                ? "A D D    N E W    D E P A R T M E N T"
                : "U P D A T E    D E P A R T M E N T",
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  const FormHeading(text: 'Department Details'),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  _departmentFormLayoutBuilder(),
                  const SizedBox(height: 50),
                  DefaultButton(
                    text: widget.department == null ? "S A V E" : "U P D A T E",
                    onPressed: saveDepartment,
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

  Future<void> saveDepartment() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (widget.department == null) {
          await _insertNewDepartment();
        } else {
          await _updateExistingDepartment();
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              errorMessage: 'Failed to save department: $e',
            );
          },
        );
      }
    }
  }

  Future<void> _insertNewDepartment() async {
    final newDepartment = Departments(
      department: _department!,
      remarks: _remarks!,
    );
    bool result = await DepartmentController().createDepartment(newDepartment);

    if (result) {
      showMessageSnackBar(
          context, 'Department created successfully', Colors.green);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
            errorMessage: 'Department already exists!',
          );
        },
      );
    }
  }

  Future<void> _updateExistingDepartment() async {
    final updatedDepartment = Departments(
      id: _id!,
      department: _department!,
      remarks: _remarks!,
    );
    bool result =
        await DepartmentController().updateDepartment(updatedDepartment);

    if (result) {
      showMessageSnackBar(
          context, 'Department details updated successfully', Colors.green);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
            errorMessage:
                'Somthing went wrong: Failed to update department details',
          );
        },
      );
    }
  }

  LayoutBuilder _departmentFormLayoutBuilder() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Mobile view
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
                TextFormFieldWidget(
                  labelText: 'Department Name',
                  hintText: 'Enter Department Name',
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Department Name';
                    } else if (!alphaValidatorRegExp.hasMatch(value)) {
                      return 'Please Enter Only Characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _department = value;
                    });
                  },
                  initialValue: _department,
                ),
                const SizedBox(height: 25),
                TextFormFieldWidget(
                  labelText: 'Remarks',
                  hintText: 'Enter Any Remarks',
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 5,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return null;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _remarks = value;
                    });
                  },
                  initialValue: _remarks,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
