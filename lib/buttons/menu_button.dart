import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final IconData icon;
  final Function() onClick;

  const CircleButton({Key? key, this.width = 60, this.height = 60, this.color = Colors.red, required this.icon, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onClick,
        enableFeedback: true,
      ),
    );
  }
}
