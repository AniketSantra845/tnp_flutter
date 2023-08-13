import 'package:flutter/material.dart';

import '../Constant Files/constants.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade600,
              blurRadius: 5,
              offset: const Offset(2, 2),
            )
          ]),
      margin: const EdgeInsets.only(top: 10.0, right: 15.0),
      child: const Icon(
        Icons.download,
        color: kPrimaryColor,
        size: 44,
      ),
    );
  }
}
