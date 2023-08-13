import 'package:flutter/material.dart';

import '../Constant Files/size_config.dart';

class ProfileHeader extends StatelessWidget {
  final AssetImage image;
  final String name;
  final String email;
  final VoidCallback onEditProfile;

  const ProfileHeader({
    super.key,
    required this.image,
    required this.name,
    required this.email,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListTile(
        leading: SizedBox(
          width: SizeConfig.screenWidth / 8,
          height: SizeConfig.screenWidth / 8,
          child: CircleAvatar(
            backgroundImage: image,
            radius: SizeConfig.screenWidth / 28,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.screenWidth / 23,
          ),
        ),
        subtitle: Text(
          email,
          style: TextStyle(
            fontSize: SizeConfig.screenWidth / 30,
          ),
        ),
        trailing: GestureDetector(
          onTap: onEditProfile,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.indigo),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.screenWidth / 60,
              vertical: SizeConfig.screenWidth / 120,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit,
                  color: Colors.indigo,
                  size: SizeConfig.screenWidth / 30,
                ),
                SizedBox(
                  width: SizeConfig.screenWidth / 75,
                ),
                Text(
                  "Edit",
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.screenWidth / 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
