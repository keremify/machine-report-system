import '../models/failure_report.dart';

class FailureService {
  static final FailureService instance = FailureService._();

  FailureService._() {
    _reports.addAll([
      FailureReport(
        id: 'rep-001',
        machineName: 'CNC Mill 01',
        failureType: FailureType.mechanical,
        description: 'Spindle bearing making abnormal grinding noise and overheating after 20 minutes of continuous operation.',
        reportedAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
        reportedBy: 'admin',
      ),
      FailureReport(
        id: 'rep-002',
        machineName: 'Conveyor Belt A',
        failureType: FailureType.electrical,
        description: 'Drive motor trips the main circuit breaker intermittently when starting under full payload.',
        reportedAt: DateTime.now().subtract(const Duration(hours: 5, minutes: 40)),
        reportedBy: 'tech',
      ),
      FailureReport(
        id: 'rep-003',
        machineName: 'Hydraulic Press 02',
        failureType: FailureType.hydraulic,
        description: 'Significant hydraulic fluid leakage observed around the main cylinder seal with noticeable pressure drop.',
        reportedAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        reportedBy: 'admin',
      ),
      FailureReport(
        id: 'rep-004',
        machineName: 'Robotic Arm Station',
        failureType: FailureType.software,
        description: 'Axis 4 controller throws watchdog timeout error code ERR_E402 during rapid positioning cycles.',
        reportedAt: DateTime.now().subtract(const Duration(days: 2)),
        reportedBy: 'tech',
      ),
    ]);
  }

  final List<FailureReport> _reports = [];

  List<FailureReport> get reports => List.unmodifiable(_reports);

  void add(FailureReport report) {
    _reports.insert(0, report);
  }

  bool remove(String id) {
    final index = _reports.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reports.removeAt(index);
      return true;
    }
    return false;
  }
}
