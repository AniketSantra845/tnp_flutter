// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../../Controllers/session_controller.dart';
import '../../Models/sessions.dart';
import '../../Shared Docs/Common Widgets/error_dialog.dart';
import '../../Shared Docs/Common Widgets/message_snackbar.dart';
import '../../Shared Docs/Constant Files/constants.dart';
import '../../Shared Docs/Constant Files/size_config.dart';

class UpdateDefaultBatchScreen extends StatefulWidget {
  const UpdateDefaultBatchScreen({super.key});

  @override
  _UpdateDefaultBatchScreenState createState() =>
      _UpdateDefaultBatchScreenState();
}

class _UpdateDefaultBatchScreenState extends State<UpdateDefaultBatchScreen> {
  var _selectedSession;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Update Current Batch",
        style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
      ),
      content: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          _buildSessionDropdown(),
          const SizedBox(height: 30),
          _buildUpdateButton(),
        ],
      ),
    );
  }

  Widget _buildSessionDropdown() {
    return Row(
      children: [
        Text(
          "Batch:",
          style: TextStyle(fontSize: SizeConfig.screenWidth / 23),
        ),
        const SizedBox(width: 10),
        FutureBuilder<List<Session>>(
          future: SessionController().getSessions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            } else if (snapshot.hasError) {
              return ErrorDialog(
                errorMessage: 'Failed to fetch sessions: ${snapshot.error}',
              );
            } else if (!snapshot.hasData) {
              return Text(
                'No Data Found',
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth / 23,
                  fontWeight: FontWeight.bold,
                ),
              );
            } else {
              // Find the session with default_year equal to 1
              Session? defaultSession;
              for (Session session in snapshot.data!) {
                if (session.default_year == 1) {
                  defaultSession = session;
                  break;
                }
              }
              return Container(
                height: getProportionateScreenHeight(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButton(
                  hint: const Text("Select Start Date"),
                  value: _selectedSession ?? defaultSession?.id.toString(),
                  items: snapshot.data!.map((e) {
                    return DropdownMenuItem(
                      value: e.id.toString(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e.label),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _selectedSession = value;
                    setState(() {});
                  },
                  underline: Container(),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: getProportionateScreenWidth(120),
      height: getProportionateScreenHeight(40),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: kPrimaryColor,
        ),
        onPressed: updateDefaultBatch,
        child: Text(
          "U P D A T E",
          style: TextStyle(fontSize: SizeConfig.screenWidth / 28),
        ),
      ),
    );
  }

  Future<void> updateDefaultBatch() async {
    try {
      bool result = await SessionController()
          .updateDefaultBatchStatus(int.parse(_selectedSession));

      if (result) {
        showMessageSnackBar(
            context, 'Default batch updated successfully', Colors.green);
      } else {
        showMessageSnackBar(
            context, 'Failed to update default batch', Colors.red);
      }
      // Navigate back to the previous screen after saving
      Navigator.pop(context);
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
              errorMessage: 'Failed to update default batch: $e');
        },
      );
    }
  }
}
