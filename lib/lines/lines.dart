import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final bool type;

  LinePainter(this.type);
  //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(0, 0);
    final p2 = Offset(type ? -150 : 150 , 150);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}