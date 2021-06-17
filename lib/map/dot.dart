import 'package:flutter/cupertino.dart';

class Dot extends StatelessWidget {
  final Color dotColor;
  final Color dotBorderColor;
  final double dotSize;

  const Dot({Key? key, required this.dotColor, required this.dotBorderColor, this.dotSize = 25.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dotColor,
        border: Border.all(color: dotBorderColor, width: dotSize * 0.1),
      ),
      width: dotSize,
      height: dotSize,
    );
  }

}