// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:placements/Shared%20Docs/Common%20Widgets/default_button.dart';

import '../../Controllers/company_controller.dart';
import '../../Models/company.dart';
import '../../Shared Docs/Common Widgets/error_dialog.dart';
import '../../Shared Docs/Common Widgets/form_heading.dart';
import '../../Shared Docs/Common Widgets/message_snackbar.dart';
import '../../Shared Docs/Common Widgets/text_form_field.dart';
import '../../Shared Docs/Constant Files/constants.dart';
import '../../Shared Docs/Constant Files/size_config.dart';

class AddCompanyDetails extends StatefulWidget {
  final Company? company;
  const AddCompanyDetails({super.key, this.company});

  @override
  State<AddCompanyDetails> createState() => _AddCompanyDetailsState();
}

class _AddCompanyDetailsState extends State<AddCompanyDetails> {
  final _formKey = GlobalKey<FormState>();

  int? _id;
  String? _cifNumber;
  String? _companyName;
  String? _mobileNumber;
  String? _alternateMobileNumber;
  String? _email;
  String? _alternateEmail;
  String? _description;

  @override
  void initState() {
    super.initState();

    _id = widget.company?.id ?? 0;
    _cifNumber = widget.company?.cif ?? '';
    _companyName = widget.company?.name ?? '';
    _mobileNumber = widget.company?.contact ?? '';
    _alternateMobileNumber = widget.company?.alt_contact ?? '';
    _email = widget.company?.email ?? '';
    _alternateEmail = widget.company?.alt_email ?? '';
    _description = widget.company?.about ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.company == null
                ? "A D D    N E W    C O M P A N Y"
                : "U P D A T E    C O M P A N Y",
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
                  const FormHeading(text: 'Company Details'),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  _companyFormLayoutBuilder(),
                  const SizedBox(height: 50),
                  DefaultButton(
                    text: widget.company == null ? "S A V E" : "U P D A T E",
                    onPressed: saveCompany,
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

  Future<void> saveCompany() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (widget.company == null) {
          await _insertNewCompany();
        } else {
          await _updateExistingCompany();
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              errorMessage: 'Failed to save company: $e',
            );
          },
        );
      }
    }
  }

  Future<void> _insertNewCompany() async {
    final newCompany = Company(
      cif: _cifNumber!,
      name: _companyName!,
      about: _description!,
      contact: _mobileNumber!,
      alt_contact: _alternateMobileNumber!,
      email: _email!,
      alt_email: _alternateEmail!,
    );

    bool result = await CompanyController().createCompany(newCompany);

    if (result) {
      showMessageSnackBar(
          context, 'Company created successfully', Colors.green);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
            errorMessage: 'Company already exists!',
          );
        },
      );
    }
  }

  Future<void> _updateExistingCompany() async {
    final updatedCompany = Company(
      id: _id!,
      cif: _cifNumber!,
      name: _companyName!,
      about: _description!,
      contact: _mobileNumber!,
      alt_contact: _alternateMobileNumber!,
      email: _email!,
      alt_email: _alternateEmail!,
    );
    bool result = await CompanyController().updateCompany(updatedCompany);

    if (result) {
      showMessageSnackBar(
          context, 'Company details updated successfully', Colors.green);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
            errorMessage:
                'Somthing went wrong: Failed to update company details',
          );
        },
      );
    }
  }

  LayoutBuilder _companyFormLayoutBuilder() {
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
                TextFormFieldWidget(
                  labelText: 'CIF Number',
                  hintText: 'Enter CIF Number',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter CIF Number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _cifNumber = value;
                    });
                  },
                  initialValue: _cifNumber,
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  labelText: 'Company Name',
                  hintText: 'Enter Company Name',
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Company Name';
                    } else if (!alphaValidatorRegExp.hasMatch(value)) {
                      return 'Please Enter Only Characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _companyName = value;
                    });
                  },
                  initialValue: _companyName,
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  labelText: 'Mobile Number',
                  hintText: 'Enter Mobile Number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Mobile Number';
                    } else if (!phoneNumberValidatorRegExp.hasMatch(value)) {
                      return 'Mobile Number Must Be of 10 Digits';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _mobileNumber = value;
                    });
                  },
                  initialValue: _mobileNumber,
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  labelText: 'Alternate Mobile Number',
                  hintText: 'Enter Mobile Number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return null;
                    } else if (!phoneNumberValidatorRegExp.hasMatch(value)) {
                      return 'Mobile Number Must Be of 10 Digits';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _alternateMobileNumber = value;
                    });
                  },
                  initialValue: _alternateMobileNumber,
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
                  labelText: 'Alternate Email Id',
                  hintText: 'Enter Email Id',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return null;
                    } else if (!emailValidatorRegExp.hasMatch(value)) {
                      return kInvalidEmailError;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _alternateEmail = value;
                    });
                  },
                  initialValue: _alternateEmail,
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  labelText: 'Company Description',
                  hintText: 'Enter Company Description',
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 5,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Company Description';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  initialValue: _description,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
