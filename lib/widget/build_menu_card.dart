import 'package:flutter/material.dart';
import 'package:sylph_ar/theme.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color backgroundColor;

  const MenuCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: defaultMargin, left: defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: semiBoldTextStyle18),
                Text(
                  subtitle,
                  style: backgroundColor == Colors.white ||
                          backgroundColor == addColor
                      ? regularTextStylePink
                      : regularTextStyleWhite,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Image.asset(imagePath, width: 130),
          ),
        ],
      ),
    );
  }
}
