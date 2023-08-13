import 'dart:async';

import 'package:flutter/material.dart';
import 'package:placements/Models/Company_hirings/hirings.dart';
import 'package:placements/Models/Company_hirings/ui_to_db_hirings.dart';
import 'package:placements/Models/company.dart';
import 'package:placements/Models/sessions.dart';
import 'package:placements/Shared%20Docs/Common%20Widgets/error_dialog.dart';

import 'package:placements/Shared%20Docs/Common%20Widgets/search_text_field.dart';
import 'package:placements/Shared%20Docs/Constant%20Files/constants.dart';

import '../../../Models/Company_hirings/view_hirings.dart';
import '../../../Controllers/hirings_controller.dart';
import '../../../Shared Docs/Common Widgets/circle_icon.dart';
import '../../../Shared Docs/Common Widgets/generic_dialog.dart';
import '../../../Shared Docs/Common Widgets/message_snackbar.dart';
import '../../../Shared Docs/Constant Files/size_config.dart';
import 'add_company_hirings.dart';

class CompanyHiringDetailsScreen extends StatefulWidget {
  const CompanyHiringDetailsScreen({super.key});

  @override
  State<CompanyHiringDetailsScreen> createState() =>
      _CompanyHiringDetailsScreenState();
}

class _CompanyHiringDetailsScreenState
    extends State<CompanyHiringDetailsScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = true;

  List<Hirings> _hirings = [];
  List<Session> _sessions = [];
  List<Company> _company = [];
  List<Hirings> _filteredHirings = [];

  @override
  void initState() {
    super.initState();
    fetchHirings();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("C O M P A N Y  H I R I N G  D E T A I L S"),
        ),
        body: RefreshIndicator(
          onRefresh: fetchHirings,
          color: kPrimaryColor,
          child: Column(
            children: [
              const SizedBox(height: 20),
              SearchTextField(
                onChanged: filterHirings,
                controller: _searchController,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Visibility(
                  visible: _isLoading,
                  replacement: Padding(
                    padding: const EdgeInsets.only(left: 7, right: 7),
                    child: _filteredHirings.isEmpty
                        ? const Text(
                            'N O  D A T A  F O U N D . . .',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredHirings.length,
                            itemBuilder: (context, index) {
                              Hirings hiring = _filteredHirings[index];
                              Iterable<Hirings> ihiring = _hirings;
                              Iterable<Session> isession = _sessions;
                              Iterable<Company> icompany = _company;
                              return _hiringListItem(hiring, ihiring, isession,icompany, context, hiring.id);
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

  Future<void> fetchHirings() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(
      const Duration(seconds: 2), // Simulate loading screen for 2 seconds
    );

    try {
      ViewHirings viewHirings = await HiringsController().getHirings();
      setState(() {
        _hirings = viewHirings.hiringDetails ?? [];
        _sessions = viewHirings.sessiondetails ?? [];
        _company = viewHirings.companydetails ?? [];
        _filteredHirings = viewHirings.hiringDetails ?? [];
        _isLoading = false;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMessage: 'Failed to fetch hiring details: $e',
          );
        },
      );
    }
  }

  void filterHirings(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHirings = _hirings;
      } else {
        _filteredHirings = _hirings
            .where((hirings) =>
                hirings.designation.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> deleteById(int id) async {
    try {
      bool result = await HiringsController().deleteHiring(id);

      if (result == true) {
        // Update company list
        showMessageSnackBar(
          context,
          'Hiring details deleted successfully',
          Colors.green,
        );
        setState(() {
          _filteredHirings.removeWhere((hiring) => hiring.id == id);
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const ErrorDialog(
              errorMessage:
                  'Failed to delete hiring details. Please try again later.',
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
                'An error occurred while deleting the hiring details. Please try again later.',
          );
        },
      );
    }
  }

  Future<void> navigateToPage([Hirings? hiring]) async {
    final route = MaterialPageRoute(
      builder: (context) => hiring != null
          ? AddCompanyHiringDetails(hiring: hiring)
          : const AddCompanyHiringDetails(),
    );
    // Unfocus the search text field before navigating
    FocusScope.of(context).unfocus();
    // Wait for the detail page to be popped
    await Navigator.push(context, route);

    setState(() {
      _isLoading = true;
    });

    fetchHirings();
    _searchController.clear(); // Clear the search query
    filterHirings(''); // Reset the filtered companies
  }

  Container _hiringListItem(
      Hirings hiring,
      Iterable<Hirings> ihiring,
      Iterable<Session> isession,
      Iterable<Company> icompany,
      BuildContext context,
      int hiringId) {
    Session? hiringSession;
    Company? hiringCompany;
    if (isession != null) {
      hiringSession = isession.firstWhere((s) => s.id == hiring.session_id);
    }
    if (icompany != null) {
      hiringCompany = icompany.firstWhere((c) => c.id == hiring.company_id);
    }
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
                  hiringCompany!.name,
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth / 23,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  hiringSession!.label,
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
                hiring.designation + " " + hiring.id.toString(),
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth / 32,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 19, 28, 66),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: kSecondaryTextColor,
                    ),
                    onPressed: () {
                      navigateToPage(hiring);
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
                              'Are you sure you want to delete this company?',
                          confirmButtonText: 'Yes',
                          cancelButtonText: 'No',
                          onConfirm: () {
                            showDialog(
                              context: context,
                              builder: (context) => GenericDialogWidget(
                                title: 'Warning',
                                content:
                                    'All the data related to this company will be deleted.\nAre you sure want to delete it?',
                                confirmButtonText: 'Okay',
                                cancelButtonText: 'Cancel',
                                onConfirm: () {
                                  deleteById(
                                    hiringId,
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
        ],
      ),
    );
  }
}
