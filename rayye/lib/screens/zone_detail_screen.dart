import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plant_zone.dart';
import '../services/irrigation/irrigation_service.dart';
import '../widgets/moisture_gauge.dart';
import '../widgets/pump_button.dart';
import '../theme/app_theme.dart';

class ZoneDetailScreen extends StatelessWidget {
  final String zoneId;
  const ZoneDetailScreen({Key? key, required this.zoneId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<IrrigationService>();
    final zone = svc.zones.firstWhere((z) => z.id == zoneId);
    final status = zone.status;

    return Scaffold(
      backgroundColor: AppTheme.sand,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: status.color,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white70),
              onPressed: () {
                svc.removeZone(zone.id);
                Navigator.pop(context);
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [status.color, status.color.withOpacity(0.7)])),
              child: Stack(children: [
                Positioned(right: -20, bottom: -20,
                    child: Text(zone.icon, style: const TextStyle(fontSize: 120))),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                  child: Column(mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(zone.name,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    Text(zone.plantType,
                        style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ]),
                ),
              ]),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // ── Status ─────────────────────────────────────────────────
              _Card(child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                MoistureGauge(value: zone.moisture, size: 130),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _InfoRow(Icons.water_drop, 'Moisture',
                      '${zone.moisture.toStringAsFixed(1)}%', status.color),
                  const SizedBox(height: 10),
                  _InfoRow(Icons.tune, 'Threshold',
                      '${zone.threshold.toInt()}%', AppTheme.leaf),
                  const SizedBox(height: 10),
                  _InfoRow(Icons.schedule, 'Last watered',
                      zone.lastIrrigated != null ? _ago(zone.lastIrrigated!) : 'Never',
                      AppTheme.water),
                ]),
              ])),

              const SizedBox(height: 14),

              // ── Zone details ────────────────────────────────────────────
              _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _SectionTitle('Zone Details'),
                const SizedBox(height: 12),
                _DetailRow('🌱 Plant', zone.plantType),
                const Divider(height: 20),
                _DetailRow('🪨 Soil', zone.soilType),
                const Divider(height: 20),
                _DetailRow('📡 Sensor', zone.sensorType),
              ])),

              const SizedBox(height: 14),

              // ── Pump ────────────────────────────────────────────────────
              _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _SectionTitle('Pump Control'),
                const SizedBox(height: 14),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(zone.pumpActive ? '💧 Watering now...' : '⏸ Pump is off',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                            color: zone.pumpActive ? AppTheme.water : AppTheme.bark)),
                    const SizedBox(height: 4),
                    Text('Tap to ${zone.pumpActive ? "stop" : "start"} manually',
                        style: Theme.of(context).textTheme.bodySmall),
                  ]),
                  PumpButton(isActive: zone.pumpActive,
                      onToggle: () => svc.togglePump(zone.id), size: 68),
                ]),
              ])),

              const SizedBox(height: 14),

              // ── Threshold ───────────────────────────────────────────────
              _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  _SectionTitle('Auto Threshold'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(color: AppTheme.mist,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('${zone.threshold.toInt()}%',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.moss)),
                  ),
                ]),
                const SizedBox(height: 4),
                Text('Auto-water when moisture drops below this level',
                    style: Theme.of(context).textTheme.bodySmall),
                Slider(value: zone.threshold, min: 10, max: 80, divisions: 70,
                    onChanged: (v) => svc.setThreshold(zone.id, v)),
              ])),

              const SizedBox(height: 24),
            ]),
          ),
        ),
      ]),
    );
  }

  String _ago(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.mist, width: 1.5)),
    child: child,
  );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.soil));
}

class _InfoRow extends StatelessWidget {
  final IconData icon; final String label; final String value; final Color color;
  const _InfoRow(this.icon, this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 16, color: color), const SizedBox(width: 6),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: 11, color: AppTheme.bark)),
      Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: color)),
    ]),
  ]);
}

class _DetailRow extends StatelessWidget {
  final String label; final String value;
  const _DetailRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 14, color: AppTheme.bark)),
      Flexible(child: Text(value, textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.soil))),
    ],
  );
}
