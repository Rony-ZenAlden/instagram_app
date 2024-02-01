import 'package:flutter/material.dart';

class FollowButtonWidget extends StatelessWidget {
  const FollowButtonWidget({
    Key? key,
    this.function,
    required this.text,
    required this.color,
    required this.borderColor,
    required this.colorText,
  }) : super(key: key);
  final Function? function;
  final String text;
  final Color color;
  final Color borderColor;
  final Color colorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: () {},
        child: Container(
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          width: 250,
          height: 27,
          child: Text(
            text,
            style: TextStyle(
              color: colorText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
