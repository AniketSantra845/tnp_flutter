import 'package:flutter/material.dart';
import '../Constant Files/size_config.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const CustomCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: SizeConfig.screenWidth / 23,
          ),
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String? title;
  final List<CustomCard> cards;

  const Section({
    super.key,
    this.title,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: double.infinity,
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth / 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              const SizedBox(height: 10),
              ..._buildCardList(), // Add the Divider here
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCardList() {
    List<Widget> cardList = [];

    for (int i = 0; i < cards.length; i++) {
      cardList.add(cards[i]);
      if (i < cards.length - 1) {
        cardList.add(const Divider(thickness: 1.0));
      }
    }

    return cardList;
  }
}
