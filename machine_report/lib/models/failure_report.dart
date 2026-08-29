enum FailureType {
  mechanical,
  electrical,
  hydraulic,
  software;

  String get label => switch (this) {
        FailureType.mechanical => 'Mechanical',
        FailureType.electrical => 'Electrical',
        FailureType.hydraulic => 'Hydraulic',
        FailureType.software => 'Software',
      };

  String get description => switch (this) {
        FailureType.mechanical => 'Motors, bearings, gears, vibrations & tooling',
        FailureType.electrical => 'Circuits, wiring, sensors, power & fuses',
        FailureType.hydraulic => 'Fluid leaks, pumps, pressure loss & valves',
        FailureType.software => 'PLC, controller errors, firmware & UI faults',
      };
}

class FailureReport {
  FailureReport({
    String? id,
    required this.machineName,
    required this.failureType,
    required this.description,
    required this.reportedAt,
    this.reportedBy,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  final String id;
  final String machineName;
  final FailureType failureType;
  final String description;
  final DateTime reportedAt;
  final String? reportedBy;
}
