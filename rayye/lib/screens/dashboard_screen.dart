import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plant_zone.dart';
import '../services/irrigation/irrigation_service.dart';
import '../widgets/moisture_gauge.dart';
import '../widgets/pump_button.dart';
import '../widgets/water_tank.dart';
import '../theme/app_theme.dart';
import 'zone_detail_screen.dart';
import 'add_zone_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<IrrigationService>();
    final zones = svc.zones;
    final status = svc.systemStatus;
    final activePumps = zones.where((z) => z.pumpActive).length;
    final avgMoisture = zones.isEmpty ? 0.0
        : zones.map((z) => z.moisture).reduce((a, b) => a + b) / zones.length;

    return Scaffold(
      backgroundColor: AppTheme.sand,
      body: CustomScrollView(slivers: [
        // ── Header ──────────────────────────────────────────────────────
        SliverAppBar(
          expandedHeight: 150,
          pinned: true,
          backgroundColor: AppTheme.moss,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: AppTheme.moss,
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 14),
              child: Column(mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Text('🌿', style: TextStyle(fontSize: 26)),
                  const SizedBox(width: 8),
                  const Text('Rayye Garden',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: status.connected ? AppTheme.sprout.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: status.connected ? AppTheme.sprout : Colors.red, width: 1),
                    ),
                    child: Row(children: [
                      Container(width: 7, height: 7, decoration: BoxDecoration(
                          shape: BoxShape.circle, color: status.connected ? AppTheme.sprout : Colors.red)),
                      const SizedBox(width: 5),
                      Text(status.connected ? 'Online' : 'Offline',
                          style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ]),
                  ),
                ]),
                const SizedBox(height: 6),
                Text(_greeting(), style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ]),
            ),
          ),
        ),

        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ── Summary ──────────────────────────────────────────────────
            Row(children: [
              Expanded(child: _StatCard('💧', 'Avg Moisture',
                  '${avgMoisture.toStringAsFixed(0)}%', AppTheme.water)),
              const SizedBox(width: 10),
              Expanded(child: _StatCard('⚙️', 'Active Pumps',
                  '$activePumps', activePumps > 0 ? AppTheme.water : AppTheme.leaf)),
              const SizedBox(width: 10),
              Expanded(child: _StatCard('🪣', 'Water Used',
                  '${status.waterUsedTodayLiters}L', AppTheme.leaf)),
              const SizedBox(width: 10),
              WaterTank(level: status.waterTankLevel, height: 70, width: 28),
            ]),

            const SizedBox(height: 16),

            // ── Auto mode ────────────────────────────────────────────────
            _AutoBar(enabled: svc.autoMode, onChanged: svc.setAutoMode),

            const SizedBox(height: 22),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Zones', style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(color: AppTheme.soil, fontSize: 22)),
              TextButton.icon(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AddZoneScreen())),
                icon: const Icon(Icons.add_circle_outline, color: AppTheme.leaf, size: 18),
                label: const Text('Add zone',
                    style: TextStyle(color: AppTheme.leaf, fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 10),
          ]),
        )),

        // ── Zone cards ──────────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(delegate: SliverChildBuilderDelegate(
            (context, i) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ZoneCard(zone: zones[i]),
            ),
            childCount: zones.length,
          )),
        ),

        if (zones.isEmpty)
          SliverToBoxAdapter(child: Center(
            child: Padding(padding: const EdgeInsets.all(40), child: Column(children: [
              const Text('🌱', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              const Text('No zones yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.soil)),
              const SizedBox(height: 6),
              const Text('Tap "Add zone" to get started', style: TextStyle(color: AppTheme.bark)),
            ])),
          )),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ]),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning. Your plants are waiting.';
    if (h < 17) return 'Good afternoon. Keep the garden thriving.';
    return 'Good evening. Plants are resting.';
  }
}

// ── Zone card ─────────────────────────────────────────────────────────────────

class _ZoneCard extends StatelessWidget {
  final PlantZone zone;
  const _ZoneCard({required this.zone});

  @override
  Widget build(BuildContext context) {
    final status = zone.status;
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ZoneDetailScreen(zoneId: zone.id))),
      child: Container(
        decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: status.color.withOpacity(0.25), width: 1.5),
            boxShadow: [BoxShadow(color: status.color.withOpacity(0.06),
                blurRadius: 14, offset: const Offset(0, 4))]),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Header
            Row(children: [
              Text(zone.icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(zone.name, style: const TextStyle(fontWeight: FontWeight.w600,
                    fontSize: 15, color: AppTheme.soil), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(zone.plantType, style: const TextStyle(fontSize: 12, color: AppTheme.bark)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: status.bgColor, borderRadius: BorderRadius.circular(20)),
                child: Text('${status.emoji} ${status.label}',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: status.color)),
              ),
            ]),

            const SizedBox(height: 14),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              MoistureGauge(value: zone.moisture, size: 96),
              Column(children: [
                Consumer<IrrigationService>(builder: (ctx, svc, _) => PumpButton(
                  isActive: zone.pumpActive,
                  onToggle: () => svc.togglePump(zone.id), size: 50)),
                const SizedBox(height: 5),
                Text(zone.pumpActive ? 'Pump ON' : 'Pump OFF',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                        color: zone.pumpActive ? AppTheme.water : AppTheme.bark)),
              ]),
            ]),

            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 6),

            // Meta row
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                const Icon(Icons.tune, size: 13, color: AppTheme.leaf),
                const SizedBox(width: 4),
                Text('Threshold: ${zone.threshold.toInt()}%',
                    style: const TextStyle(fontSize: 11, color: AppTheme.moss)),
              ]),
              Row(children: [
                const Icon(Icons.sensors, size: 13, color: AppTheme.leaf),
                const SizedBox(width: 4),
                Text(zone.sensorType.split(' ').first,
                    style: const TextStyle(fontSize: 11, color: AppTheme.moss)),
              ]),
            ]),
          ]),
        ),
      ),
    );
  }
}

// ── Stat card ─────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String icon, label, value;
  final Color color;
  const _StatCard(this.icon, this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2), width: 1)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(icon, style: const TextStyle(fontSize: 16)),
      const SizedBox(height: 5),
      Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: color)),
      Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.bark),
          maxLines: 1, overflow: TextOverflow.ellipsis),
    ]),
  );
}

// ── Auto bar ──────────────────────────────────────────────────────────────────

class _AutoBar extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;
  const _AutoBar({required this.enabled, required this.onChanged});

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      gradient: enabled ? const LinearGradient(
          colors: [AppTheme.moss, AppTheme.leaf],
          begin: Alignment.centerLeft, end: Alignment.centerRight) : null,
      color: enabled ? null : Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: enabled ? Colors.transparent : AppTheme.mist, width: 1.5),
    ),
    child: Row(children: [
      Icon(Icons.auto_mode, color: enabled ? Colors.white : AppTheme.bark, size: 20),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Auto Irrigation', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,
            color: enabled ? Colors.white : AppTheme.soil)),
        Text(enabled ? 'Watering automatically by threshold' : 'Manual control only',
            style: TextStyle(fontSize: 11, color: enabled ? Colors.white70 : AppTheme.bark)),
      ])),
      Switch(
        value: enabled, onChanged: onChanged,
        thumbColor: WidgetStateProperty.all(Colors.white),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppTheme.sprout : Colors.grey[300]),
      ),
    ]),
  );
}
