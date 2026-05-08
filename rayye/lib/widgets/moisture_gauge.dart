import 'dart:math';
import 'package:flutter/material.dart';
import '../models/plant_zone.dart';
import '../theme/app_theme.dart';

class MoistureGauge extends StatefulWidget {
  final double value;
  final double size;
  final bool showLabel;
  const MoistureGauge({Key? key, required this.value, this.size = 120, this.showLabel = true})
      : super(key: key);

  @override
  State<MoistureGauge> createState() => _MoistureGaugeState();
}

class _MoistureGaugeState extends State<MoistureGauge> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  double _prev = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _anim = Tween<double>(begin: 0, end: widget.value)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
    _prev = widget.value;
  }

  @override
  void didUpdateWidget(MoistureGauge old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _anim = Tween<double>(begin: _prev, end: widget.value)
          .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
      _prev = widget.value;
      _ctrl..reset()..forward();
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final status = moistureStatusFromValue(widget.value);
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => SizedBox(
        width: widget.size, height: widget.size,
        child: CustomPaint(
          painter: _GaugePainter(value: _anim.value, status: status),
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('${_anim.value.toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: widget.size * 0.22,
                      fontWeight: FontWeight.w700, color: status.color)),
              if (widget.showLabel)
                Text('${status.emoji} ${status.label}',
                    style: TextStyle(fontSize: widget.size * 0.11, color: status.color)),
            ]),
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final MoistureStatus status;
  _GaugePainter({required this.value, required this.status});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const start = pi * 0.75;
    const sweep = pi * 1.5;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, sweep, false,
        Paint()..style = PaintingStyle.stroke..strokeWidth = 10..strokeCap = StrokeCap.round
            ..color = AppTheme.mist);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, sweep * (value / 100), false,
        Paint()..style = PaintingStyle.stroke..strokeWidth = 10..strokeCap = StrokeCap.round
            ..shader = SweepGradient(startAngle: start, endAngle: start + sweep,
                colors: [status.color.withOpacity(0.5), status.color], tileMode: TileMode.clamp)
                .createShader(Rect.fromCircle(center: center, radius: radius)));

    final angle = start + sweep * (value / 100);
    canvas.drawCircle(Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle)),
        6, Paint()..color = status.color);
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.value != value;
}
