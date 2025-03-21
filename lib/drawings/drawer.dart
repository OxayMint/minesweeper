import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

enum DrawerRequest { flag, bomb, smile }

enum SmileState { happy, nervous, dead }

class PersonalDrawer extends CustomPainter {
  final DrawerRequest request;
  bool isExploded;
  SmileState? smileState;
  PersonalDrawer(this.request, {this.isExploded = false, this.smileState});
  factory PersonalDrawer.smile(SmileState state) {
    return PersonalDrawer(DrawerRequest.smile, smileState: state);
  }
  @override
  void paint(Canvas canvas, Size size) {
    switch (request) {
      case DrawerRequest.flag:
        drawFlag(canvas, size);
        break;
      case DrawerRequest.bomb:
        if (isExploded) {
          drawMine(canvas, size, red: true);
        }
        drawMine(canvas, size);
        break;
      case DrawerRequest.smile:
        drawSmile(canvas, size, smileState);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void drawMine(Canvas canvas, Size size, {bool red = false}) async {
    final body =
        Paint()
          ..color = red ? Colors.red : Colors.black
          ..style = PaintingStyle.fill;

    final spike =
        Paint()
          ..color = red ? Colors.red : Colors.black
          ..strokeWidth = red ? 6 : 4
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final shine =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    var linesLeft = 4;
    while (linesLeft > 0) {
      canvas.drawLine(Offset(-12, 0), Offset(12, 0), spike);
      canvas.rotate(45 * (3.1415927 / 180));

      linesLeft--;
    }

    canvas.restore();
    canvas.drawCircle(center, red ? 11 : 9, body);
    if (red) return;
    final shineOffset = Offset(center.dx - 3, center.dy - 3);
    canvas.drawCircle(shineOffset, 3, shine);
  }

  void drawFlag(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;
    final redFill =
        Paint()
          ..color = Colors.red
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.fill;
    final redPath =
        Path()
          ..moveTo(size.width / 2 + 2, size.height / 2)
          ..lineTo(size.width / 2 - 13, size.width / 2 - 6)
          ..lineTo(size.width / 2 + 2, size.width / 2 - 12)
          ..close();

    canvas.drawLine(Offset(10, 10), Offset(size.width - 10, 10), paint);
    canvas.drawLine(Offset(6, 7), Offset(size.width - 6, 7), paint);
    canvas.drawLine(
      Offset(size.width / 2, 10),
      Offset(size.width / 2, -8),
      paint,
    );
    canvas.drawPath(redPath, redFill);
    // canvas.drawLine(Offset(6, 5), Offset(size.width - 6, 5), paint);
  }

  void drawSmile(Canvas canvas, Size size, SmileState? smileState) {
    final black =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
    final blackFilled =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 1
          ..style = PaintingStyle.fill;
    final yellow =
        Paint()
          ..color = Colors.yellow
          ..strokeWidth = 2
          ..style = PaintingStyle.fill;
    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, yellow);
    canvas.drawCircle(center, size.width / 2, black);

    if (smileState == SmileState.dead) {
      canvas.drawLine(center + Offset(-8, -8), center + Offset(-4, -4), black);
      canvas.drawLine(center + Offset(-8, -4), center + Offset(-4, -8), black);

      canvas.drawLine(center + Offset(8, -8), center + Offset(4, -4), black);
      canvas.drawLine(center + Offset(8, -4), center + Offset(4, -8), black);
    } else {
      canvas.drawCircle(center + Offset(-6, -6), 2, blackFilled);
      canvas.drawCircle(center + Offset(6, -6), 2, blackFilled);
    }

    if (smileState == SmileState.dead) {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height * 0.85),
          width: size.width / 2,
          height: size.height / 2,
        ),
        -0.3,
        -pi + 0.6,
        false,
        black,
      );
    } else if (smileState == SmileState.happy) {
      canvas.drawArc(
        Rect.fromCenter(
          center: center,
          width: size.width / 2,
          height: size.height / 2,
        ),
        0.3,
        pi - 0.6,
        false,
        black,
      );
    } else {
      canvas.drawCircle(center + Offset(0, center.dy / 3), 4, black);
    }
    // canvas.drawCircle(c, radius, paint)
  }
}
