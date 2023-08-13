// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:placements/Controllers/sector_controller.dart';
import 'package:placements/Models/sector.dart';
import 'package:placements/Screens/Coordinator/add_sector.dart';

import '../../Shared Docs/Common Widgets/circle_icon.dart';
import '../../Shared Docs/Common Widgets/error_dialog.dart';
import '../../Shared Docs/Common Widgets/generic_dialog.dart';
import '../../Shared Docs/Common Widgets/message_snackbar.dart';
import '../../Shared Docs/Common Widgets/search_text_field.dart';
import '../../Shared Docs/Common Widgets/speed_dial.dart';
import '../../Shared Docs/Constant Files/constants.dart';
import '../../Shared Docs/Constant Files/size_config.dart';

class SectorDetailsScreen extends StatefulWidget {
  final Sectors? sector;
  const SectorDetailsScreen({super.key, this.sector});

  @override
  State<SectorDetailsScreen> createState() => _SectorDetailsScreenState();
}

class _SectorDetailsScreenState extends State<SectorDetailsScreen> {
  final isDialOpen = ValueNotifier(false);
  final _searchController = TextEditingController();
  bool _isLoading = true;
  List<Sectors> _sectors = [];
  List<Sectors> _filteredSectors = [];

  @override
  void initState() {
    super.initState();

    fetchSectors();
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
            title: const Text("S E C T O R S    D E T A I L S"),
          ),
          body: RefreshIndicator(
            onRefresh: fetchSectors,
            color: kPrimaryColor,
            child: Column(
              children: [
                const SizedBox(height: 20),
                SearchTextField(
                  onChanged: filterSectors,
                  controller: _searchController,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Visibility(
                    visible: _isLoading,
                    replacement: Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: _filteredSectors.isEmpty
                          ? Text(
                              'N O  D A T A  F O U N D',
                              style: TextStyle(
                                fontSize: SizeConfig.screenWidth / 23,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : ListView.builder(
                              itemCount: _filteredSectors.length,
                              itemBuilder: (context, index) {
                                final sector = _filteredSectors[index];
                                final sectorId = sector.id;
                                return _sectorListItem(
                                    sector, context, sectorId);
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
                label: "Add Sector",
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

  Future<void> fetchSectors() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final sectors = await SectorController().getSectors();
      setState(() {
        _sectors = sectors;
        _filteredSectors = sectors;
        _isLoading = false;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMessage: 'Failed to fetch sectors: $e',
          );
        },
      );
    }
  }

  Future<void> deleteById(int id) async {
    try {
      bool result = await SectorController().deleteSector(id);

      if (result == true) {
        // Update sector list
        showMessageSnackBar(
          context,
          'Sector details deleted successfully',
          Colors.green,
        );
        setState(() {
          _filteredSectors.removeWhere((sector) => sector.id == id);
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const ErrorDialog(
              errorMessage: 'Failed to delete sector. Please try again later.',
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
                'An error occurred while deleting the sector. Please try again later.',
          );
        },
      );
    }
  }

  Future<void> navigateToPage([Sectors? sector]) async {
    final route = MaterialPageRoute(
      builder: (context) => sector != null
          ? AddSectorDetails(sector: sector)
          : const AddSectorDetails(),
    );
    // Unfocus the search text field before navigating
    FocusScope.of(context).unfocus();
    // Wait for the detail page to be popped
    await Navigator.push(context, route);

    setState(() {
      _isLoading = true;
    });

    fetchSectors();
    _searchController.clear(); // Clear the search query
    filterSectors(''); // Reset the filtered companies
  }

  void filterSectors(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSectors = _sectors;
      } else {
        _filteredSectors = _sectors
            .where((sector) =>
                sector.sector.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Container _sectorListItem(
      Sectors sector, BuildContext context, int sectorId) {
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
              sector.sector,
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
                  navigateToPage(sector);
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
                      content: 'Are you sure you want to delete this sector?',
                      confirmButtonText: 'Yes',
                      cancelButtonText: 'No',
                      onConfirm: () {
                        showDialog(
                          context: context,
                          builder: (context) => GenericDialogWidget(
                            title: 'Warning',
                            content:
                                'All the data related to this sector will be deleted.\nAre you sure want to delete it?',
                            confirmButtonText: 'Okay',
                            cancelButtonText: 'Cancel',
                            onConfirm: () {
                              deleteById(
                                sectorId,
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
