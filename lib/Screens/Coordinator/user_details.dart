// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:placements/Controllers/user_controller.dart';

import 'package:placements/Shared%20Docs/Common%20Widgets/download_button.dart';

import '../../Models/users.dart';
import '../../Shared Docs/Common Widgets/circle_icon.dart';
import '../../Shared Docs/Common Widgets/error_dialog.dart';
import '../../Shared Docs/Common Widgets/generic_dialog.dart';
import '../../Shared Docs/Common Widgets/message_snackbar.dart';
import '../../Shared Docs/Common Widgets/search_text_field.dart';
import '../../Shared Docs/Common Widgets/speed_dial.dart';
import '../../Shared Docs/Constant Files/constants.dart';
import '../../Shared Docs/Constant Files/size_config.dart';
import 'add_user.dart';

class UsersDetailsScreen extends StatefulWidget {
  const UsersDetailsScreen({super.key});

  @override
  State<UsersDetailsScreen> createState() => _UsersDetailsScreenState();
}

class _UsersDetailsScreenState extends State<UsersDetailsScreen> {
  final isDialOpen = ValueNotifier(false);
  final _searchController = TextEditingController();
  bool _isLoading = true;
  List<Users> _users = [];
  List<Users> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("U S E R S    D E T A I L S"),
        ),
        body: RefreshIndicator(
          onRefresh: fetchUsers,
          color: kPrimaryColor,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SearchTextField(
                      onChanged: filterUsers,
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
                    child: _filteredUsers.isEmpty
                        ? Text(
                            'N O  D A T A  F O U N D',
                            style: TextStyle(
                              fontSize: SizeConfig.screenWidth / 23,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user =
                                  _filteredUsers[index] as UsersFromDBToUI;
                              final userId = user.id!;
                              return _userListItem(user, context, userId);
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
              label: "Add User",
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
    );
  }

  Future<void> fetchUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users = await UserController().getUsers();
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMessage: 'Failed to fetch users: $e',
          );
        },
      );
    }
  }

  Future<void> deleteById(int id) async {
    try {
      bool result = await UserController().deleteUser(id);

      if (result == true) {
        // Update company list
        showMessageSnackBar(
          context,
          'User details deleted successfully',
          Colors.green,
        );
        setState(() {
          _filteredUsers.removeWhere((user) => user.id == id);
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const ErrorDialog(
              errorMessage: 'Failed to delete user. Please try again later.',
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
                'An error occurred while deleting the user. Please try again later.',
          );
        },
      );
    }
  }

  Future<void> updateById(int id) async {
    try {
      final userData = await UserController().getUsers(id);
      final UserFromUIToDB user =
          UserFromUIToDB.fromJson(userData.first.toJson());

      // Now you can access the properties of the user instance
      // print('User ID: ${user.id}');
      // print('Session ID: ${user.session_id}');
      // print('Department ID: ${user.department_id}');
      // print('User Name: ${user.name}');
      // print('User Email: ${user.email}');

      navigateToPage(user);
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
            errorMessage:
                'An error occurred while getting the user record. Please try again later.',
          );
        },
      );
    }
  }

  Future<void> navigateToPage([UserFromUIToDB? user]) async {
    final route = MaterialPageRoute(
      builder: (context) =>
          user != null ? AddUserDetails(user: user) : const AddUserDetails(),
    );
    // Unfocus the search text field before navigating
    FocusScope.of(context).unfocus();
    // Wait for the detail page to be popped
    await Navigator.push(context, route);

    setState(() {
      _isLoading = true;
    });

    fetchUsers();
    _searchController.clear(); // Clear the search query
    filterUsers(''); // Reset the filtered companies
  }

  void filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = _users;
      } else {
        _filteredUsers = _users
            .where((user) =>
                user.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Container _userListItem(
      UsersFromDBToUI user, BuildContext context, int userId) {
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
                  user.department!,
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth / 32,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.name!,
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth / 23,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.email!,
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth / 32,
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
                user.label!,
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
                      updateById(
                        userId,
                      );
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
                                  deleteById(
                                    userId,
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
