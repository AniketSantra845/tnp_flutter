// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:placements/Screens/Coordinator/add_company.dart';
import 'package:placements/Shared%20Docs/Constant%20Files/constants.dart';

import '../../Controllers/company_controller.dart';
import '../../Models/company.dart';
import '../../Shared Docs/Common Widgets/circle_icon.dart';
import '../../Shared Docs/Common Widgets/error_dialog.dart';
import '../../Shared Docs/Common Widgets/generic_dialog.dart';
import '../../Shared Docs/Common Widgets/message_snackbar.dart';
import '../../Shared Docs/Common Widgets/search_text_field.dart';
import '../../Shared Docs/Constant Files/size_config.dart';

class CompanyDetailsScreen extends StatefulWidget {
  const CompanyDetailsScreen({super.key});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = true;
  List<Company> _companies = [];
  List<Company> _filteredCompanies = [];

  @override
  void initState() {
    super.initState();
    fetchCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("C O M P A N Y    D E T A I L S"),
        ),
        body: RefreshIndicator(
          onRefresh: fetchCompanies,
          color: kPrimaryColor,
          child: Column(
            children: [
              const SizedBox(height: 10),
              SearchTextField(
                onChanged: filterCompanies,
                controller: _searchController,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Visibility(
                  visible: _isLoading,
                  replacement: Padding(
                    padding: const EdgeInsets.only(left: 7, right: 7),
                    child: _filteredCompanies.isEmpty
                        ? Text(
                            'N O  D A T A  F O U N D',
                            style: TextStyle(
                              fontSize: SizeConfig.screenWidth / 23,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredCompanies.length,
                            itemBuilder: (context, index) {
                              final company = _filteredCompanies[index];
                              final companyId = company.id;
                              return _companyListItem(
                                  company, context, companyId);
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
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          backgroundColor: kPrimaryColor,
          onOpen: () => navigateToPage(),
        ),
      ),
    );
  }

  Future<void> fetchCompanies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final companies = await CompanyController().getCompanies();
      setState(() {
        _companies = companies;
        _filteredCompanies = companies;
        _isLoading = false;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMessage: 'Failed to fetch companies: $e',
          );
        },
      );
    }
  }

  Future<void> deleteById(int id) async {
    try {
      bool result = await CompanyController().deleteCompany(id);

      if (result == true) {
        // Update company list
        showMessageSnackBar(
          context,
          'Company details deleted successfully',
          Colors.green,
        );
        setState(() {
          _filteredCompanies.removeWhere((company) => company.id == id);
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const ErrorDialog(
              errorMessage: 'Failed to delete company. Please try again later.',
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
                'An error occurred while deleting the company. Please try again later.',
          );
        },
      );
    }
  }

  Future<void> navigateToPage([Company? company]) async {
    final route = MaterialPageRoute(
      builder: (context) => company != null
          ? AddCompanyDetails(company: company)
          : const AddCompanyDetails(),
    );
    // Unfocus the search text field before navigating
    FocusScope.of(context).unfocus();
    // Wait for the detail page to be popped
    await Navigator.push(context, route);

    setState(() {
      _isLoading = true;
    });

    fetchCompanies();
    _searchController.clear(); // Clear the search query
    filterCompanies(''); // Reset the filtered companies
  }

  void filterCompanies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCompanies = _companies;
      } else {
        _filteredCompanies = _companies
            .where((company) =>
                company.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Container _companyListItem(
      Company company, BuildContext context, int companyId) {
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
                  company.name,
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth / 23,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  company.about,
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
                company.contact,
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth / 32,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 19, 28, 66),
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
                      navigateToPage(company);
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
                                    companyId,
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
