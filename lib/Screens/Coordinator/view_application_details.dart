import 'package:flutter/material.dart';
import 'package:placements/Controllers/student_application_controller.dart';
import 'package:placements/Models/Student_Applications/db_to_ui.dart';

import '../../Shared Docs/Common Widgets/circle_icon.dart';
import '../../Shared Docs/Common Widgets/error_dialog.dart';

import '../../Shared Docs/Constant Files/constants.dart';
import '../../Shared Docs/Constant Files/size_config.dart';

class ViewApplicationDetailsScreen extends StatefulWidget {
  const ViewApplicationDetailsScreen({super.key});

  @override
  State<ViewApplicationDetailsScreen> createState() =>
      _ViewApplicationDetailsScreenState();
}

class _ViewApplicationDetailsScreenState
    extends State<ViewApplicationDetailsScreen> {
  bool _isLoading = true;
  List<StudentApplicationDbToUi> _studentapplication = [];
  //List<StudentApplicationDbToUi> _filterstudentapplication = [];
  @override
  void initState() {
    super.initState();
    fetchStudentApplications();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("A P P L I C A T I O N    D E T A I L S"),
        ),
        body: RefreshIndicator(
          onRefresh: fetchStudentApplications,
          color: kPrimaryColor,
          child: Column(
            children: [
              const SizedBox(height: 30),
              Expanded(
                child: Visibility(
                  visible: _isLoading,
                  replacement: Padding(
                    padding: const EdgeInsets.only(left: 7, right: 7),
                    child: _studentapplication.isEmpty
                        ? Text(
                            'N O  D A T A  F O U N D',
                            style: TextStyle(
                              fontSize: SizeConfig.screenWidth / 23,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _studentapplication.length,
                            itemBuilder: (context, index) {
                              final stdapp = _studentapplication[index];
                              final stdappId = stdapp.id;
                              return _studentAppListItem(
                                  stdapp, context, stdappId!);
                            },
                          ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchStudentApplications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final studentapplication =
          await StudentApplicationController().getStudentApplication();
      setState(() {
        _studentapplication = studentapplication;
        _isLoading = false;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMessage: 'Failed to fetch student Application List: $e',
          );
        },
      );
    }
  }

  Container _studentAppListItem(
      StudentApplicationDbToUi stdapp, BuildContext context, int stdappId) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
          )
        ],
      ),
      margin: const EdgeInsets.all(10.0),
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleIconWidget(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  stdapp.name!,
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth / 23,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  stdapp.designation!,
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth / 32,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: SizeConfig.blockSizeVertical! * 0.8,
              ),
              Text(
                stdapp.contact!,
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth / 32,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 19, 28, 66),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
