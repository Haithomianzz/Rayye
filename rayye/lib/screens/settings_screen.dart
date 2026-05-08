import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/irrigation/irrigation_service.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../theme/app_theme.dart';
import '../utilities/dialogs/logout_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<IrrigationService>();
    return Scaffold(
      backgroundColor: AppTheme.sand,
      appBar: AppBar(title: const Text('Settings'), backgroundColor: AppTheme.moss),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _SectionHeader('System'),
        _Card(children: [
          SwitchListTile(
            secondary: const Icon(Icons.auto_mode, color: AppTheme.leaf),
            title: const Text('Auto Irrigation',
                style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.soil)),
            subtitle: const Text('Water automatically by threshold',
                style: TextStyle(fontSize: 12, color: AppTheme.bark)),
            value: svc.autoMode, onChanged: svc.setAutoMode,
          ),
        ]),

        const SizedBox(height: 16),
        _SectionHeader('Zone Thresholds'),
        _Card(children: svc.zones.asMap().entries.map((e) {
          final i = e.key; final z = e.value;
          return Column(children: [
            Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Row(children: [
              Text(z.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(z.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.soil)),
                Row(children: [
                  Expanded(child: Slider(value: z.threshold, min: 10, max: 80, divisions: 70,
                      onChanged: (v) => svc.setThreshold(z.id, v))),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppTheme.mist, borderRadius: BorderRadius.circular(8)),
                      child: Text('${z.threshold.toInt()}%',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.moss))),
                ]),
              ])),
            ])),
            if (i < svc.zones.length - 1) const Divider(height: 0),
          ]);
        }).toList()),

        const SizedBox(height: 16),
        _SectionHeader('About'),
        _Card(children: [
          _InfoTile(Icons.info_outline, 'Version', '1.0.0 MVP'),
          const Divider(height: 0),
          _InfoTile(Icons.developer_mode, 'Mode', 'Demo (Mock Data)'),
          const Divider(height: 0),
          _InfoTile(Icons.memory, 'Hardware', 'ESP32 / Arduino'),
          const Divider(height: 0),
          _InfoTile(Icons.wifi, 'Connection', 'Wi-Fi / BLE'),
        ]),

        const SizedBox(height: 16),
        _SectionHeader('Account'),
        _Card(children: [
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Log out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
            onTap: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              }
            },
          ),
        ]),

        const SizedBox(height: 32),
        Center(child: Column(children: [
          const Text('🌿', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 6),
          const Text('Smart Irrigation System',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.moss)),
          const Text('NASA, but for basil.',
              style: TextStyle(fontSize: 12, color: AppTheme.bark)),
        ])),
        const SizedBox(height: 24),
      ]),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 11,
        fontWeight: FontWeight.w600, letterSpacing: 1.2, color: AppTheme.moss)),
  );
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.mist, width: 1.5)),
    child: Column(children: children),
  );
}

class _InfoTile extends StatelessWidget {
  final IconData icon; final String title, trailing;
  const _InfoTile(this.icon, this.title, this.trailing);
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: AppTheme.leaf, size: 20),
    title: Text(title, style: const TextStyle(fontSize: 14, color: AppTheme.soil)),
    trailing: Text(trailing, style: const TextStyle(fontSize: 12, color: AppTheme.bark)),
  );
}
