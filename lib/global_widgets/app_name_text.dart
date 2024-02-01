import 'package:flutter/material.dart';
import 'package:instagram_app/global_widgets/title_text.dart';

class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget({
    super.key,
    this.fontSize = 26,
    required this.text,
  });

  final double fontSize;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TitlesTextWidget(
      label: text,
      fontSize: fontSize,
    );
  }
}
