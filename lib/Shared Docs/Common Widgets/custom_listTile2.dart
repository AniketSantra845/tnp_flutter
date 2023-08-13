import 'package:flutter/material.dart';

import '../Constant Files/constants.dart';
import '../Constant Files/size_config.dart';
import 'circle_icon.dart';

class CustomListTile2 extends StatelessWidget {
  const CustomListTile2({
    super.key,
    required this.heading,
    required this.subheading,
    required this.text1,
    required this.text2,
    this.text3,
    this.icon1,
    this.icon2,
  });

  final String heading;
  final String subheading;
  final String text1;
  final String text2;
  final String? text3;
  final Icon? icon1;
  final Icon? icon2;

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
                          "Year: $text1",
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (icon1 != null) Container(child: icon1),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal! * 0.5,
                        ),
                        if (icon2 != null) Container(child: icon2),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 0.2,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            text2,
                            style: const TextStyle(
                              fontSize: 11.0,
                              color: kSecondaryTextColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (text3 != null)
                          Text(
                            text3!,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: kSecondaryTextColor,
                            ),
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
