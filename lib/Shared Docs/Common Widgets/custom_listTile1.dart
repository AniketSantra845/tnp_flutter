import 'package:flutter/material.dart';

import '../Constant Files/constants.dart';
import '../Constant Files/size_config.dart';
import 'circle_icon.dart';

class CustomListTile1 extends StatelessWidget {
  const CustomListTile1({
    super.key,
    required this.heading,
    required this.subheading,
    required this.text1,
    this.icon1,
  });

  final String heading;
  final String subheading;
  final String text1;
  final Icon? icon1;

  @override
  Widget build(BuildContext context) {
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
      margin: const EdgeInsets.all(8.0),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(5),
        vertical: getProportionateScreenHeight(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleIconWidget(),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            heading,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: kPrimaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          text1,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: kSecondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 0.8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            subheading,
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Perform edit operation
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Perform delete operation
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
