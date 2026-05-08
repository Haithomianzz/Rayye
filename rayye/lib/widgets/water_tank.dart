import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WaterTank extends StatelessWidget {
  final double level;
  final double height;
  final double width;
  const WaterTank({Key? key, required this.level, this.height = 80, this.width = 36}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = level > 40 ? AppTheme.water : level > 20 ? AppTheme.amber : Colors.red;
    return Column(children: [
      SizedBox(width: width, height: height, child: CustomPaint(painter: _TankPainter(level: level, color: color))),
      const SizedBox(height: 4),
      Text('${level.toInt()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      Text('Tank', style: TextStyle(fontSize: 10, color: AppTheme.bark)),
    ]);
  }
}

class _TankPainter extends CustomPainter {
  final double level; final Color color;
  _TankPainter({required this.level, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height; const r = 6.0;
    final shell = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), const Radius.circular(r));
    canvas.drawRRect(shell, Paint()..color = AppTheme.mist);
    canvas.drawRRect(shell, Paint()..color = AppTheme.leaf.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    final fillH = h * (level / 100);
    if (fillH > 1) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(0, h - fillH, w, fillH), const Radius.circular(r)),
        Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [color.withOpacity(0.7), color])
            .createShader(Rect.fromLTWH(0, h - fillH, w, fillH)),
      );
    }
  }

  @override
  bool shouldRepaint(_TankPainter old) => old.level != level;
}
