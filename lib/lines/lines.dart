import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final bool type;
  final double x;
  final double y;

  LinePainter(this.type, this.x, this.y);
  //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(0, 0);
    final p2 = Offset(x, y);
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