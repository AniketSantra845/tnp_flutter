import 'package:flutter/material.dart';
import 'package:placements/Screens/Coordinator/Hirings/company_hiring_details.dart';
import 'package:placements/Screens/Coordinator/user_details.dart';

import '../../Shared Docs/Common Widgets/dashboard_info_card.dart';
import '../../Shared Docs/Constant Files/responsive.dart';
import '../../Shared Docs/Constant Files/size_config.dart';

import 'company_details.dart';
import 'view_application_details.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "D A S H B O A R D",
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.all(getProportionateScreenHeight(30)),
          child: DashboardGridView(widget: widget),
        ),
      ),
    );
  }
}

class DashboardGridView extends StatelessWidget {
  const DashboardGridView({
    super.key,
    required this.widget,
  });

  final DashboardScreen widget;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: Responsive.isMobile(context)
          ? 2
          : Responsive.isTablet(context)
              ? 4
              : 5,
      crossAxisSpacing: 25.0,
      mainAxisSpacing: 25.0,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ViewApplicationDetailsScreen(),
              ),
            );
          },
          child: DashboardInfoCard(
            icon: Icon(
              Icons.description,
              color: Colors.yellow,
              size: Responsive.isMobile(context)
                  ? SizeConfig.screenWidth / 20
                  : SizeConfig.screenWidth / 60,
            ),
            label: "View Student Application",
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CompanyDetailsScreen(),
              ),
            );
          },
          child: DashboardInfoCard(
            icon: Icon(
              Icons.business,
              color: Colors.blue,
              size: Responsive.isMobile(context)
                  ? SizeConfig.screenWidth / 20
                  : SizeConfig.screenWidth / 60,
            ),
            label: "Company Details",
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CompanyHiringDetailsScreen(),
              ),
            );
          },
          child: DashboardInfoCard(
            icon: Icon(
              Icons.work,
              color: Colors.green,
              size: Responsive.isMobile(context)
                  ? SizeConfig.screenWidth / 20
                  : SizeConfig.screenWidth / 60,
            ),
            label: "Company Hiring Details",
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UsersDetailsScreen(),
              ),
            );
          },
          child: DashboardInfoCard(
            icon: Icon(
              Icons.person,
              color: Colors.purple,
              size: Responsive.isMobile(context)
                  ? SizeConfig.screenWidth / 20
                  : SizeConfig.screenWidth / 60,
            ),
            label: "View Users Details",
          ),
        ),
      ],
    );
  }
}
