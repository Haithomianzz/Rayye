import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plant_zone.dart';
import '../services/irrigation/irrigation_service.dart';
import '../theme/app_theme.dart';

class AddZoneScreen extends StatefulWidget {
  const AddZoneScreen({Key? key}) : super(key: key);

  @override
  State<AddZoneScreen> createState() => _AddZoneScreenState();
}

class _AddZoneScreenState extends State<AddZoneScreen> {
  final _nameCtrl = TextEditingController();
  String _plantType = kPlantTypes.first;
  String _soilType  = kSoilTypes.first;
  String _sensorType = kSensorTypes.first;
  double _threshold = 35;
  final _formKey = GlobalKey<FormState>();

  static const _icons = ['🌿', '🍅', '💜', '🌴', '🌻', '🥦', '🍓', '🌾', '🪴', '🌵'];
  String _icon = '🌿';

  @override
  void dispose() { _nameCtrl.dispose(); super.dispose(); }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final zone = PlantZone(
      id: 'z${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      plantType: _plantType,
      soilType: _soilType,
      sensorType: _sensorType,
      icon: _icon,
      moisture: 30 + Random().nextDouble() * 40,
      threshold: _threshold,
    );
    context.read<IrrigationService>().addZone(zone);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.sand,
      appBar: AppBar(
        title: const Text('Add Zone'),
        backgroundColor: AppTheme.moss,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            // ── Icon picker ──────────────────────────────────────────────
            _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Label('Pick an icon'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10, runSpacing: 10,
                children: _icons.map((e) => GestureDetector(
                  onTap: () => setState(() => _icon = e),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: _icon == e ? AppTheme.mist : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _icon == e ? AppTheme.leaf : Colors.transparent, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(e, style: const TextStyle(fontSize: 24)),
                  ),
                )).toList(),
              ),
            ])),

            const SizedBox(height: 14),

            // ── Zone name ────────────────────────────────────────────────
            _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Label('Zone name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(hintText: 'e.g. Herb Garden, Balcony Pots'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a name' : null,
              ),
            ])),

            const SizedBox(height: 14),

            // ── Plant type dropdown ──────────────────────────────────────
            _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Label('Plant type'),
              const SizedBox(height: 8),
              _Dropdown<String>(
                value: _plantType,
                items: kPlantTypes,
                onChanged: (v) => setState(() => _plantType = v!),
              ),
            ])),

            const SizedBox(height: 14),

            // ── Soil type dropdown ───────────────────────────────────────
            _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Label('Soil type'),
              const SizedBox(height: 8),
              _Dropdown<String>(
                value: _soilType,
                items: kSoilTypes,
                onChanged: (v) => setState(() => _soilType = v!),
              ),
            ])),

            const SizedBox(height: 14),

            // ── Sensor type dropdown ─────────────────────────────────────
            _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Label('Sensor type'),
              const SizedBox(height: 8),
              _Dropdown<String>(
                value: _sensorType,
                items: kSensorTypes,
                onChanged: (v) => setState(() => _sensorType = v!),
              ),
            ])),

            const SizedBox(height: 14),

            // ── Threshold slider ─────────────────────────────────────────
            _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _Label('Auto-water threshold'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(color: AppTheme.mist, borderRadius: BorderRadius.circular(20)),
                  child: Text('${_threshold.toInt()}%',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.moss)),
                ),
              ]),
              const SizedBox(height: 4),
              Text('Pump turns on when moisture drops below this level',
                  style: Theme.of(context).textTheme.bodySmall),
              Slider(
                value: _threshold, min: 10, max: 80, divisions: 70,
                onChanged: (v) => setState(() => _threshold = v),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('10%', style: Theme.of(context).textTheme.bodySmall),
                Text('80%', style: Theme.of(context).textTheme.bodySmall),
              ]),
            ])),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Zone'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.moss,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.mist, width: 1.5)),
    child: child,
  );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(),
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
          letterSpacing: 0.8, color: AppTheme.moss));
}

class _Dropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  const _Dropdown({required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<T>(
    value: value,
    isExpanded: true,
    decoration: InputDecoration(
      filled: true,
      fillColor: AppTheme.sand,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.mist, width: 1.5)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.mist, width: 1.5)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.leaf, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
    dropdownColor: Colors.white,
    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.leaf),
    style: const TextStyle(fontSize: 14, color: AppTheme.charcoal),
    items: items.map((e) => DropdownMenuItem(value: e,
        child: Text(e.toString(), overflow: TextOverflow.ellipsis))).toList(),
    onChanged: onChanged,
  );
}
