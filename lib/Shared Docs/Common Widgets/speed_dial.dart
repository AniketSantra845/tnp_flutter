import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../Constant Files/constants.dart';

class SpeedDialWidget extends StatefulWidget {
  final ValueNotifier<bool> isDialOpen;
  final List<SpeedDialChildInfo> children;

  const SpeedDialWidget({
    super.key,
    required this.isDialOpen,
    required this.children,
  });

  @override
  _SpeedDialWidgetState createState() => _SpeedDialWidgetState();
}

class _SpeedDialWidgetState extends State<SpeedDialWidget> {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: kPrimaryColor,
      overlayColor: Colors.black,
      overlayOpacity: 0.4,
      spacing: 12,
      spaceBetweenChildren: 12,
      onClose: () {},
      openCloseDial: widget.isDialOpen,
      children: widget.children.map((child) {
        return SpeedDialChild(
          child: Icon(
            child.icon,
            color: child.iconColor,
          ),
          label: child.label,
          onTap: child.onTap,
        );
      }).toList(),
    );
  }
}

class SpeedDialChildInfo {
  final String label;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  SpeedDialChildInfo({
    required this.label,
    required this.icon,
    this.iconColor = kPrimaryColor,
    required this.onTap,
  });
}
