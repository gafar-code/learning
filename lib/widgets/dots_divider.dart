import 'package:flutter/material.dart';

class DotsDivider extends StatelessWidget {
  const DotsDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      width: MediaQuery.of(context).size.width,
      child: CustomPaint(
        painter: DottedLinePainter(),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 5;

    double currentX = dashWidth / 2;

    while (currentX < size.width) {
      canvas.drawLine(
        Offset(currentX, 0),
        Offset(currentX + dashWidth, 0),
        paint,
      );

      currentX += (dashWidth + dashSpace);
    }
  }

  @override
  bool shouldRepaint(DottedLinePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(DottedLinePainter oldDelegate) => false;
}
