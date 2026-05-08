import 'package:flutter/material.dart';

enum MoistureStatus { dry, optimal, wet }

extension MoistureStatusExt on MoistureStatus {
  String get label {
    switch (this) {
      case MoistureStatus.dry:     return 'Dry';
      case MoistureStatus.optimal: return 'Optimal';
      case MoistureStatus.wet:     return 'Wet';
    }
  }
  String get emoji {
    switch (this) {
      case MoistureStatus.dry:     return '🌵';
      case MoistureStatus.optimal: return '🌱';
      case MoistureStatus.wet:     return '💧';
    }
  }
  Color get color {
    switch (this) {
      case MoistureStatus.dry:     return const Color(0xFFD4860A);
      case MoistureStatus.optimal: return const Color(0xFF4A7C2F);
      case MoistureStatus.wet:     return const Color(0xFF4A9EBF);
    }
  }
  Color get bgColor {
    switch (this) {
      case MoistureStatus.dry:     return const Color(0xFFFFF3DC);
      case MoistureStatus.optimal: return const Color(0xFFEAF4DF);
      case MoistureStatus.wet:     return const Color(0xFFDCF2FA);
    }
  }
}

MoistureStatus moistureStatusFromValue(double v) {
  if (v < 30) return MoistureStatus.dry;
  if (v > 70) return MoistureStatus.wet;
  return MoistureStatus.optimal;
}

// ── Dropdown option lists ──────────────────────────────────────────────────

const List<String> kPlantTypes = [
  'Basil',
  'Mint',
  'Tomato',
  'Pepper',
  'Lettuce',
  'Spinach',
  'Lavender',
  'Rosemary',
  'Monstera',
  'Cactus',
  'Orchid',
  'Fern',
  'Other',
];

const List<String> kSoilTypes = [
  'Loamy (general purpose)',
  'Sandy (fast draining)',
  'Clay (slow draining)',
  'Peat / Coco Coir',
  'Potting mix',
  'Hydroponic medium',
];

const List<String> kSensorTypes = [
  'Capacitive (analog)',
  'Resistive (analog)',
  'DHT11 (temp + humidity)',
  'DHT22 (temp + humidity)',
  'SHT30 (I2C)',
  'Simulated / Demo',
];

// ── Zone model ────────────────────────────────────────────────────────────

class PlantZone {
  final String id;
  final String name;
  final String plantType;
  final String soilType;
  final String sensorType;
  final String icon;
  double moisture;
  double threshold;
  bool pumpActive;
  DateTime? lastIrrigated;
  List<double> moistureHistory;

  PlantZone({
    required this.id,
    required this.name,
    required this.plantType,
    required this.soilType,
    required this.sensorType,
    required this.icon,
    required this.moisture,
    required this.threshold,
    this.pumpActive = false,
    this.lastIrrigated,
    List<double>? moistureHistory,
  }) : moistureHistory = moistureHistory ?? [];

  MoistureStatus get status => moistureStatusFromValue(moisture);

  PlantZone copyWith({
    double? moisture,
    double? threshold,
    bool? pumpActive,
    DateTime? lastIrrigated,
    List<double>? moistureHistory,
  }) => PlantZone(
    id: id,
    name: name,
    plantType: plantType,
    soilType: soilType,
    sensorType: sensorType,
    icon: icon,
    moisture: moisture ?? this.moisture,
    threshold: threshold ?? this.threshold,
    pumpActive: pumpActive ?? this.pumpActive,
    lastIrrigated: lastIrrigated ?? this.lastIrrigated,
    moistureHistory: moistureHistory ?? this.moistureHistory,
  );
}

class SystemStatus {
  final bool connected;
  final double waterTankLevel;
  final int totalIrrigationsToday;
  final double waterUsedTodayLiters;

  const SystemStatus({
    required this.connected,
    required this.waterTankLevel,
    required this.totalIrrigationsToday,
    required this.waterUsedTodayLiters,
  });
}
