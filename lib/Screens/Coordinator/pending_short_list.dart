import 'package:flutter/material.dart';
import 'package:placements/Models/Student_Applications/pendinglistdb_to_ui.dart';

import '../../Controllers/student_application_controller.dart';
import '../../Shared Docs/Common Widgets/circle_icon.dart';
import '../../Shared Docs/Common Widgets/download_button.dart';
import '../../Shared Docs/Common Widgets/error_dialog.dart';
import '../../Shared Docs/Common Widgets/generic_dialog.dart';
import '../../Shared Docs/Common Widgets/search_text_field.dart';
import '../../Shared Docs/Constant Files/constants.dart';
import '../../Shared Docs/Constant Files/size_config.dart';

class PendingListView extends StatefulWidget {
  final int hid;
  final String? company;

  PendingListView({required this.hid, required this.company});
  @override
  _PendingListViewState createState() => _PendingListViewState();
}

class _PendingListViewState extends State<PendingListView> {
  // Add your state and other logic here

  bool _isLoading = true;
  List<PendingList> _pendingList = [];
  List<PendingList> _filterpendingList = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPendingShortList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('P E N D I N G   L I S T   S T U D E N T S'),
            SizedBox(height: 10),
            Text(
              widget.company!,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: getPendingShortList,
        color: kPrimaryColor,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SearchTextField(
                    onChanged: filterStudents,
                    controller: _searchController,
                  ),
                ),
                const DownloadButton(),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Visibility(
                visible: _isLoading,
                replacement: Padding(
                  padding: const EdgeInsets.only(left: 7, right: 7),
                  child: _filterpendingList.isEmpty
                      ? Text(
                          'N O  D A T A  F O U N D',
                          style: TextStyle(
                            fontSize: SizeConfig.screenWidth / 23,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filterpendingList.length,
                          itemBuilder: (context, index) {
                            final student =
                                _filterpendingList[index] as PendingList;
                            final studentId = student.id!;
                            return _studentListItem(
                                student, context, studentId);
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
    );
  }

  Future<void> getPendingShortList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final students =
          await StudentApplicationController().getPendingShortList(widget.hid);
      setState(() {
        _pendingList = students;
        _filterpendingList = students;
        _isLoading = false;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMessage: 'Failed to fetch students: $e',
          );
        },
      );
    }
  }

  void filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filterpendingList = _pendingList;
      } else {
        _filterpendingList = _pendingList
            .where((student) =>
                student.first_name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Container _studentListItem(
      PendingList student, BuildContext context, int studentId) {
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
                  student.enrollment!,
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth / 34,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  student.surname! +
                      " " +
                      student.first_name! +
                      " " +
                      student.last_name!,
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth / 30,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  student.pan!,
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth / 34,
                  ),
                  maxLines: 1,
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
                student.contact!,
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth / 30,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 19, 28, 66),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.thumb_up_alt,
                      color: kSecondaryTextColor,
                    ),
                    onPressed: () {
                      // updateById(
                      //   userId,
                      //);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.thumb_down_alt,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => GenericDialogWidget(
                          title: 'Confirmation',
                          content: 'Are you sure you want to delete this user?',
                          confirmButtonText: 'Yes',
                          cancelButtonText: 'No',
                          onConfirm: () {
                            showDialog(
                              context: context,
                              builder: (context) => GenericDialogWidget(
                                title: 'Warning',
                                content:
                                    'All the data related to this user will be deleted.\nAre you sure want to delete it?',
                                confirmButtonText: 'Okay',
                                cancelButtonText: 'Cancel',
                                onConfirm: () {
                                  // deleteById(
                                  //   userId,
                                  // );
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
