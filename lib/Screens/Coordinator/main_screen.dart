import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:placements/Screens/Coordinator/account.dart';
import 'package:placements/Screens/Coordinator/dashboard_screen.dart';
import 'package:placements/Shared%20Docs/Common%20Widgets/custom_bottom_navigation.dart';

import '../../Shared Docs/Common Widgets/generic_dialog.dart';

class CoordinatorMainScreen extends StatefulWidget {
  const CoordinatorMainScreen({Key? key}) : super(key: key);

  @override
  _CoordinatorMainScreenState createState() => _CoordinatorMainScreenState();
}

class _CoordinatorMainScreenState extends State<CoordinatorMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const Account(),
  ];

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    showDialog(
      context: context,
      builder: (context) => GenericDialogWidget(
        title: 'Confirmation',
        content: 'Are you sure you want to exit?',
        confirmButtonText: 'Yes',
        cancelButtonText: 'No',
        onConfirm: () {
          SystemNavigator.pop(); // Directly exit the app here
        },
      ),
    );

    return false;
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: CustomBottomNavigation(
          currentIndex: _selectedIndex,
          onTabSelected: _onTabSelected,
        ),
      ),
    );
  }
}
