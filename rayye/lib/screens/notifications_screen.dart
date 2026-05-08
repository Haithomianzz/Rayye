import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/irrigation/irrigation_service.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<IrrigationService>();
    final notes = svc.notifications;
    return Scaffold(
      backgroundColor: AppTheme.sand,
      appBar: AppBar(
        title: const Text('Alerts & Log'),
        backgroundColor: AppTheme.moss,
        actions: [
          if (notes.isNotEmpty)
            TextButton(onPressed: svc.clearNotifications,
                child: const Text('Clear', style: TextStyle(color: Colors.white70))),
        ],
      ),
      body: notes.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('🌿', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 10),
              const Text('All quiet in the garden.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.soil)),
              const Text('Notifications will appear here.',
                  style: TextStyle(color: AppTheme.bark)),
            ]))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final n = notes[i];
                final isWarning = n['isWarning'] as bool;
                final time = n['time'] as DateTime;
                return Container(
                  decoration: BoxDecoration(color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: isWarning ? AppTheme.amber.withOpacity(0.3) : AppTheme.mist,
                          width: 1.5)),
                  child: ListTile(
                    leading: Container(width: 38, height: 38, decoration: BoxDecoration(
                        color: isWarning ? AppTheme.amber.withOpacity(0.15) : AppTheme.mist,
                        shape: BoxShape.circle),
                        child: Icon(isWarning ? Icons.warning_amber_rounded : Icons.info_outline,
                            color: isWarning ? AppTheme.amber : AppTheme.leaf, size: 20)),
                    title: Text(n['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.soil)),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(n['body'] as String, style: const TextStyle(fontSize: 12, color: AppTheme.bark)),
                      const SizedBox(height: 2),
                      Text('${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}:${time.second.toString().padLeft(2,'0')}',
                          style: const TextStyle(fontSize: 10, color: AppTheme.bark)),
                    ]),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
