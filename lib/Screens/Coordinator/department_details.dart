// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:placements/Controllers/department_controller.dart';
import 'package:placements/Models/departments.dart';
import 'package:placements/Screens/Coordinator/add_department.dart';

import '../../Shared Docs/Common Widgets/circle_icon.dart';
import '../../Shared Docs/Common Widgets/error_dialog.dart';
import '../../Shared Docs/Common Widgets/generic_dialog.dart';
import '../../Shared Docs/Common Widgets/message_snackbar.dart';
import '../../Shared Docs/Common Widgets/search_text_field.dart';
import '../../Shared Docs/Common Widgets/speed_dial.dart';
import '../../Shared Docs/Constant Files/constants.dart';
import '../../Shared Docs/Constant Files/size_config.dart';

class DepartmentDetailsScreen extends StatefulWidget {
  const DepartmentDetailsScreen({super.key});

  @override
  State<DepartmentDetailsScreen> createState() =>
      _DepartmentDetailsScreenState();
}

class _DepartmentDetailsScreenState extends State<DepartmentDetailsScreen> {
  final isDialOpen = ValueNotifier(false);
  final _searchController = TextEditingController();
  bool _isLoading = true;
  List<Departments> _departments = [];
  List<Departments> _filteredDepartments = [];

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          // close speed dial
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("D E P A R T M E N T    D E T A I L S"),
          ),
          body: RefreshIndicator(
            onRefresh: fetchDepartments,
            color: kPrimaryColor,
            child: Column(
              children: [
                const SizedBox(height: 20),
                SearchTextField(
                  onChanged: filterDepartments,
                  controller: _searchController,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Visibility(
                    visible: _isLoading,
                    replacement: Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: _filteredDepartments.isEmpty
                          ? Text(
                              'N O  D A T A  F O U N D',
                              style: TextStyle(
                                fontSize: SizeConfig.screenWidth / 23,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : ListView.builder(
                              itemCount: _filteredDepartments.length,
                              itemBuilder: (context, index) {
                                final department = _filteredDepartments[index];
                                final departmentId = department.id;
                                return _departmentListItem(
                                    department, context, departmentId);
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
          floatingActionButton: SpeedDialWidget(
            isDialOpen: isDialOpen,
            children: [
              SpeedDialChildInfo(
                label: "Add Department",
                icon: FontAwesomeIcons.plus,
                onTap: () => navigateToPage(),
              ),
              SpeedDialChildInfo(
                label: "Upload CSV",
                icon: FontAwesomeIcons.fileCsv,
                iconColor: Colors.green[800],
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchDepartments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final departments = await DepartmentController().getDepartments();
      setState(() {
        _departments = departments;
        _filteredDepartments = departments;
        _isLoading = false;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMessage: 'Failed to fetch departments: $e',
          );
        },
      );
    }
  }

  Future<void> deleteById(int id) async {
    try {
      bool result = await DepartmentController().deleteDepartment(id);

      if (result == true) {
        // Update company list
        showMessageSnackBar(
          context,
          'Department details deleted successfully',
          Colors.green,
        );
        setState(() {
          _filteredDepartments.removeWhere((department) => department.id == id);
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const ErrorDialog(
              errorMessage:
                  'Failed to delete department. Please try again later.',
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
            errorMessage:
                'An error occurred while deleting the department. Please try again later.',
          );
        },
      );
    }
  }

  Future<void> navigateToPage([Departments? department]) async {
    final route = MaterialPageRoute(
      builder: (context) => department != null
          ? AddDepartmentDetails(department: department)
          : const AddDepartmentDetails(),
    );
    // Unfocus the search text field before navigating
    FocusScope.of(context).unfocus();
    // Wait for the detail page to be popped
    await Navigator.push(context, route);

    setState(() {
      _isLoading = true;
    });

    fetchDepartments();
    _searchController.clear(); // Clear the search query
    filterDepartments(''); // Reset the filtered companies
  }

  void filterDepartments(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDepartments = _departments;
      } else {
        _filteredDepartments = _departments
            .where((department) => department.department
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Container _departmentListItem(
      Departments department, BuildContext context, int departmentId) {
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
        vertical: getProportionateScreenHeight(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleIconWidget(),
          Expanded(
            child: Text(
              department.department,
              style: TextStyle(
                fontSize: SizeConfig.screenWidth / 23,
                color: Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical! * 0.8,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: kSecondaryTextColor,
                ),
                onPressed: () {
                  navigateToPage(department);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => GenericDialogWidget(
                      title: 'Confirmation',
                      content:
                          'Are you sure you want to delete this department?',
                      confirmButtonText: 'Yes',
                      cancelButtonText: 'No',
                      onConfirm: () {
                        showDialog(
                          context: context,
                          builder: (context) => GenericDialogWidget(
                            title: 'Warning',
                            content:
                                'All the data related to this department will be deleted.\nAre you sure want to delete it?',
                            confirmButtonText: 'Okay',
                            cancelButtonText: 'Cancel',
                            onConfirm: () {
                              deleteById(
                                departmentId,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
