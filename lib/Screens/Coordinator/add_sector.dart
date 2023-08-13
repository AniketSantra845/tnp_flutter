// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:placements/Controllers/sector_controller.dart';
import 'package:placements/Models/sector.dart';
import 'package:placements/Shared%20Docs/Common%20Widgets/default_button.dart';

import '../../Shared Docs/Common Widgets/error_dialog.dart';
import '../../Shared Docs/Common Widgets/form_heading.dart';
import '../../Shared Docs/Common Widgets/message_snackbar.dart';
import '../../Shared Docs/Common Widgets/text_form_field.dart';
import '../../Shared Docs/Constant Files/constants.dart';
import '../../Shared Docs/Constant Files/size_config.dart';

class AddSectorDetails extends StatefulWidget {
  final Sectors? sector;
  const AddSectorDetails({super.key, this.sector});

  @override
  State<AddSectorDetails> createState() => _AddSectorDetailsState();
}

class _AddSectorDetailsState extends State<AddSectorDetails> {
  final _formKey = GlobalKey<FormState>();

  int? _id;
  String? _sector;
  String? _remarks;

  @override
  void initState() {
    super.initState();

    _id = widget.sector?.id ?? 0;
    _sector = widget.sector?.sector ?? '';
    _remarks = widget.sector?.remarks ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.sector == null
                ? "A D D    N E W    S E C T O R"
                : "U P D A T E    S E C T O R",
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
                  const FormHeading(text: 'Sector Details'),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  _sectorFormLayoutBuilder(),
                  const SizedBox(height: 50),
                  DefaultButton(
                    text: widget.sector == null ? "S A V E" : "U P D A T E",
                    onPressed: saveSector,
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

  Future<void> saveSector() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (widget.sector == null) {
          await _insertNewSector();
        } else {
          await _updateExistingSector();
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              errorMessage: 'Failed to save sector: $e',
            );
          },
        );
      }
    }
  }

  Future<void> _insertNewSector() async {
    final newSector = Sectors(
      sector: _sector!,
      remarks: _remarks!,
    );
    bool result = await SectorController().createSector(newSector);

    if (result) {
      showMessageSnackBar(context, 'Sector created successfully', Colors.green);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
            errorMessage: 'Sector already exists!',
          );
        },
      );
    }
  }

  Future<void> _updateExistingSector() async {
    final updatedSector = Sectors(
      id: _id!,
      sector: _sector!,
      remarks: _remarks!,
    );
    bool result = await SectorController().updateSector(updatedSector);

    if (result) {
      showMessageSnackBar(
          context, 'Sector details updated successfully', Colors.green);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
            errorMessage:
                'Somthing went wrong: Failed to update sector details',
          );
        },
      );
    }
  }

  LayoutBuilder _sectorFormLayoutBuilder() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormFieldWidget(
                  labelText: 'Sector Name',
                  hintText: 'Enter Sector Name',
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Sector Name';
                    } else if (!alphaValidatorRegExp.hasMatch(value)) {
                      return 'Please Enter Only Characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _sector = value;
                    });
                  },
                  initialValue: _sector,
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
