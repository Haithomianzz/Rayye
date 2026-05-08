import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PumpButton extends StatefulWidget {
  final bool isActive;
  final VoidCallback onToggle;
  final double size;
  const PumpButton({Key? key, required this.isActive, required this.onToggle, this.size = 64})
      : super(key: key);

  @override
  State<PumpButton> createState() => _PumpButtonState();
}

class _PumpButtonState extends State<PumpButton> with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    if (widget.isActive) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(PumpButton old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !_pulse.isAnimating) _pulse.repeat(reverse: true);
    else if (!widget.isActive && _pulse.isAnimating) { _pulse.stop(); _pulse.reset(); }
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: widget.onToggle,
    child: AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) => Stack(alignment: Alignment.center, children: [
        if (widget.isActive)
          Container(
            width: widget.size + 16 + _pulse.value * 12,
            height: widget.size + 16 + _pulse.value * 12,
            decoration: BoxDecoration(shape: BoxShape.circle,
                color: AppTheme.water.withOpacity(0.15 - _pulse.value * 0.1)),
          ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: widget.size, height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isActive ? AppTheme.water : AppTheme.mist,
            boxShadow: widget.isActive
                ? [BoxShadow(color: AppTheme.water.withOpacity(0.4), blurRadius: 16, spreadRadius: 2)]
                : [],
          ),
          child: Icon(widget.isActive ? Icons.water_drop : Icons.water_drop_outlined,
              color: widget.isActive ? Colors.white : AppTheme.leaf, size: widget.size * 0.44),
        ),
      ]),
    ),
  );
}
