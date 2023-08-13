// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:placements/Controllers/session_controller.dart';
import 'package:placements/Models/sessions.dart';
import 'package:placements/Shared%20Docs/Common%20Widgets/default_button.dart';

import '../../Shared Docs/Common Widgets/date_form_field.dart';
import '../../Shared Docs/Common Widgets/error_dialog.dart';
import '../../Shared Docs/Common Widgets/form_heading.dart';
import '../../Shared Docs/Common Widgets/message_snackbar.dart';
import '../../Shared Docs/Common Widgets/text_form_field.dart';
import '../../Shared Docs/Constant Files/constants.dart';
import '../../Shared Docs/Constant Files/size_config.dart';

class AddBatchDetails extends StatefulWidget {
  final Session? session;
  const AddBatchDetails({super.key, this.session});

  @override
  State<AddBatchDetails> createState() => _AddBatchDetailsState();
}

class _AddBatchDetailsState extends State<AddBatchDetails> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  int? _id;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  String? _label;

  @override
  void initState() {
    super.initState();

    _id = widget.session?.id ?? 0;
    _selectedStartDate = widget.session?.start_date;
    _selectedEndDate = widget.session?.end_date;
    _label = widget.session?.label ?? '';
    _startDateController.text = _selectedStartDate != null
        ? DateFormat('dd-MM-yyyy').format(_selectedStartDate!)
        : '';

    _endDateController.text = _selectedEndDate != null
        ? DateFormat('dd-MM-yyyy').format(_selectedEndDate!)
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.session == null
                ? "A D D    N E W    B A T C H"
                : "U P D A T E    B A T C H",
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
                  const FormHeading(text: 'Batch Details'),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  _batchFormLayoutBuilder(),
                  const SizedBox(height: 50),
                  DefaultButton(
                    text: widget.session == null ? "SAVE" : "UPDATE",
                    onPressed: saveBatch,
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

  Future<void> saveBatch() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (widget.session == null) {
          await _insertNewBatch();
        } else {
          await _updateExistingBatch();
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              errorMessage: 'Failed to save batch: $e',
            );
          },
        );
      }
    }
  }

  Future<void> _insertNewBatch() async {
    final newSession = Session(
      start_date: _selectedStartDate!,
      end_date: _selectedEndDate!,
      label: _label!,
    );

    bool result = await SessionController().createSession(newSession);

    if (result) {
      showMessageSnackBar(context, 'Batch created successfully', Colors.green);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
            errorMessage: 'batch already exists with same name!',
          );
        },
      );
    }
  }

  Future<void> _updateExistingBatch() async {
    final updatedSession = Session(
      id: _id!,
      start_date: _selectedStartDate!,
      end_date: _selectedEndDate!,
      label: _label!,
    );

    bool result = await SessionController().updateSession(updatedSession);

    if (result) {
      showMessageSnackBar(
          context, 'Batch details updated successfully', Colors.green);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
            errorMessage: 'Somthing went wrong: Failed to update batch details',
          );
        },
      );
    }
  }

  LayoutBuilder _batchFormLayoutBuilder() {
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
                DateFormField(
                  controller: _startDateController,
                  labelText: 'Start Date',
                  hintText: 'Select Start Date',
                  selectedDate: _selectedStartDate,
                  onChanged: (newDate) {
                    setState(() {
                      _selectedStartDate = newDate;
                    });
                  },
                ),
                const SizedBox(height: 20),
                DateFormField(
                  controller: _endDateController,
                  labelText: 'End Date',
                  hintText: 'Select End Date',
                  selectedDate: _selectedEndDate,
                  onChanged: (newDate) {
                    setState(() {
                      _selectedEndDate = newDate;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  labelText: 'Batch Name',
                  hintText: 'Enter Batch Name',
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Batch Name';
                    } else if (!numericValidatorRegExp.hasMatch(value)) {
                      return 'Please Enter Only Numeric Values';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _label = value;
                    });
                  },
                  initialValue: _label,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
