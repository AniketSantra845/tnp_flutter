import 'package:flutter/material.dart';
import 'package:placements/Screens/Coordinator/batch_details.dart';
import 'package:placements/Screens/Coordinator/department_details.dart';
import 'package:placements/Screens/Coordinator/sector_details.dart';
import 'package:placements/Screens/Coordinator/user_details.dart';

import '../../Shared Docs/Common Widgets/custom_card.dart';
import '../../Shared Docs/Common Widgets/logout_section.dart';
import '../../Shared Docs/Common Widgets/profile_header.dart';
import 'update_default_batch.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("M O R E"),
        ),
        body: ListView(
          children: <Widget>[
            ProfileHeader(
              image: const AssetImage('assets/images/profile.png'),
              name: "Gaurav Vaishnav",
              email: "gauravvaishnav3256@gmail.com",
              onEditProfile: () {
                // Implement your logic for editing the profile here
              },
            ),
            // const SizedBox(height: 10),
            const SizedBox(height: 30),
            Section(
              title: "Batch Details",
              cards: [
                CustomCard(
                  title: "View Batch Details",
                  icon: Icons.list,
                  iconColor: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BatchDetailsScreen(),
                      ),
                    );
                  },
                ),
                CustomCard(
                  title: "Update Current Batch",
                  icon: Icons.update,
                  iconColor: Colors.red,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const UpdateDefaultBatchScreen();
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            Section(
              title: "Department Details",
              cards: [
                CustomCard(
                  title: "View Department Details",
                  icon: Icons.work,
                  iconColor: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DepartmentDetailsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            Section(
              title: "Sector Details",
              cards: [
                CustomCard(
                  title: "View Sector Details",
                  icon: Icons.business,
                  iconColor: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SectorDetailsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            Section(
              title: "Users Details",
              cards: [
                CustomCard(
                  title: "View User Details",
                  icon: Icons.person,
                  iconColor: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UsersDetailsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            const LogoutSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
