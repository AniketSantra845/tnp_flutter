import 'package:flutter/material.dart';

import '../Constant Files/constants.dart';
import '../Constant Files/responsive.dart';
import '../Constant Files/size_config.dart';

class DashboardInfoCard extends StatelessWidget {
  final Icon icon;
  final String label;

  const DashboardInfoCard({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.isMobile(context)
          ? SizeConfig.screenWidth / 2 - 16.0
          : SizeConfig.screenWidth / 5 - 16.0,
      height: SizeConfig.screenHeight * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: Responsive.isMobile(context)
                  ? SizeConfig.screenWidth / 12
                  : SizeConfig.screenWidth / 40,
              width: Responsive.isMobile(context)
                  ? SizeConfig.screenWidth / 12
                  : SizeConfig.screenWidth / 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade600,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: icon,
            ),
            Text(
              label,
              style: TextStyle(
                color: kSecondaryColor,
                fontSize: Responsive.isMobile(context)
                    ? SizeConfig.screenWidth / 23
                    : SizeConfig.screenWidth / 65,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Icon(
              Icons.arrow_forward_outlined,
              color: kPrimaryColor,
              size: Responsive.isMobile(context)
                  ? SizeConfig.screenWidth / 15
                  : SizeConfig.screenWidth / 55,
            ),
          ],
        ),
      ),
    );
  }
}
