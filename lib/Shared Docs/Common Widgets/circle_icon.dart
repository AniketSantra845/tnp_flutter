import 'package:flutter/material.dart';

class CircleIconWidget extends StatelessWidget {
  const CircleIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.grey.shade300,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade600,
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.only(left: 10.0, right: 13.0),
      child: Icon(
        Icons.circle,
        color: Colors.grey.shade100,
        size: 44,
      ),
    );
  }
}
