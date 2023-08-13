// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:placements/Models/sessions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:placements/Screens/Coordinator/add_batch.dart';

import '../../Controllers/session_controller.dart';
import '../../Shared Docs/Common Widgets/circle_icon.dart';
import '../../Shared Docs/Common Widgets/error_dialog.dart';
import '../../Shared Docs/Common Widgets/generic_dialog.dart';
import '../../Shared Docs/Common Widgets/message_snackbar.dart';
import '../../Shared Docs/Common Widgets/search_text_field.dart';
import '../../Shared Docs/Common Widgets/speed_dial.dart';
import '../../Shared Docs/Constant Files/constants.dart';
import '../../Shared Docs/Constant Files/size_config.dart';

class BatchDetailsScreen extends StatefulWidget {
  const BatchDetailsScreen({super.key});

  @override
  State<BatchDetailsScreen> createState() => _BatchDetailsScreenState();
}

class _BatchDetailsScreenState extends State<BatchDetailsScreen> {
  final isDialOpen = ValueNotifier(false);
  final _searchController = TextEditingController();
  bool _isLoading = true;
  List<Session> _sessions = [];
  List<Session> _filteredSessions = [];

  @override
  void initState() {
    super.initState();
    fetchSessions();
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
            title: const Text("B A T C H    D E T A I L S"),
          ),
          body: RefreshIndicator(
            onRefresh: fetchSessions,
            color: kPrimaryColor,
            child: Column(
              children: [
                const SizedBox(height: 20),
                SearchTextField(
                  onChanged: filterSessions,
                  controller: _searchController,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Visibility(
                    visible: _isLoading,
                    replacement: Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: _filteredSessions.isEmpty
                          ? Text(
                              'N O  D A T A  F O U N D',
                              style: TextStyle(
                                fontSize: SizeConfig.screenWidth / 23,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : ListView.builder(
                              itemCount: _filteredSessions.length,
                              itemBuilder: (context, index) {
                                final session = _filteredSessions[index];
                                final sessionId = session.id;
                                return _sessionListItem(
                                    session, context, sessionId);
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
                label: "Add Batch",
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

  Future<void> fetchSessions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final sessions = await SessionController().getSessions();
      setState(() {
        _sessions = sessions;
        _filteredSessions = sessions;
        _isLoading = false;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMessage: 'Failed to fetch sessions: $e',
          );
        },
      );
    }
  }

  Future<void> deleteById(int id) async {
    try {
      bool result = await SessionController().deleteSession(id);

      if (result == true) {
        // Update company list
        showMessageSnackBar(
          context,
          'Batch details deleted successfully',
          Colors.green,
        );
        setState(() {
          _filteredSessions.removeWhere((session) => session.id == id);
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const ErrorDialog(
              errorMessage: 'Failed to delete batch. Please try again later.',
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
                'An error occurred while deleting the batch. Please try again later.',
          );
        },
      );
    }
  }

  Future<void> navigateToPage([Session? session]) async {
    final route = MaterialPageRoute(
      builder: (context) => session != null
          ? AddBatchDetails(session: session)
          : const AddBatchDetails(),
    );
    // Unfocus the search text field before navigating
    FocusScope.of(context).unfocus();
    // Wait for the detail page to be popped
    await Navigator.push(context, route);

    setState(() {
      _isLoading = true;
    });

    fetchSessions();
    _searchController.clear(); // Clear the search query
    filterSessions(''); // Reset the filtered companies
  }

  void filterSessions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSessions = _sessions;
      } else {
        _filteredSessions = _sessions
            .where((session) =>
                session.label.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Container _sessionListItem(
      Session session, BuildContext context, int sessionId) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Batch: ${session.label}",
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth / 23,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Start Date: ${DateFormat('dd-MM-yyyy').format(session.start_date)}",
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth / 32,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "End Date: ${DateFormat('dd-MM-yyyy').format(session.end_date)}",
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth / 32,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
                  navigateToPage(session);
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
                      content: 'Are you sure you want to delete this batch?',
                      confirmButtonText: 'Yes',
                      cancelButtonText: 'No',
                      onConfirm: () {
                        showDialog(
                          context: context,
                          builder: (context) => GenericDialogWidget(
                            title: 'Warning',
                            content:
                                'All the data related to this batch will be deleted.\nAre you sure want to delete it?',
                            confirmButtonText: 'Okay',
                            cancelButtonText: 'Cancel',
                            onConfirm: () {
                              deleteById(
                                sessionId,
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
