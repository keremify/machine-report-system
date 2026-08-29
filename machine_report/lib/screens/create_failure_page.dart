import 'package:flutter/material.dart';

import '../models/failure_report.dart';
import '../services/auth_service.dart';
import '../services/failure_service.dart';
import '../theme/app_theme.dart';

class CreateFailurePage extends StatefulWidget {
  const CreateFailurePage({super.key});

  @override
  State<CreateFailurePage> createState() => _CreateFailurePageState();
}

class _CreateFailurePageState extends State<CreateFailurePage> {
  final _formKey = GlobalKey<FormState>();
  final _machineController = TextEditingController();
  final _descriptionController = TextEditingController();
  FailureType _selectedType = FailureType.mechanical;
  bool _isSubmitting = false;

  final List<String> _suggestedMachines = [
    'CNC Mill 01',
    'Conveyor Belt A',
    'Hydraulic Press 02',
    'Robotic Arm Station',
    'Lathe Machine 03',
    'Packaging Line 01',
  ];

  @override
  void dispose() {
    _machineController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 250));

    final report = FailureReport(
      machineName: _machineController.text.trim(),
      failureType: _selectedType,
      description: _descriptionController.text.trim(),
      reportedAt: DateTime.now(),
      reportedBy: AuthService.instance.currentUser?.username ?? 'Anonymous',
    );

    FailureService.instance.add(report);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Incident report for "${report.machineName}" submitted successfully.'),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Log New Incident'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section 1: Equipment Identification
                  _buildSectionHeader(
                    icon: Icons.precision_manufacturing_rounded,
                    title: 'Equipment Identification',
                    subtitle: 'Specify the machinery or line experiencing issues.',
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.slateBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _machineController,
                          decoration: const InputDecoration(
                            labelText: 'Machine Name / Asset ID *',
                            hintText: 'e.g. CNC Mill 01 or Conveyor Belt A',
                            prefixIcon: Icon(Icons.precision_manufacturing_outlined),
                          ),
                          validator: (value) => (value == null || value.trim().isEmpty)
                              ? 'Please provide a machine or asset name'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Quick Suggestions:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.slateLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _suggestedMachines.map((machine) {
                            final isSelected = _machineController.text == machine;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _machineController.text = machine;
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.primaryLight
                                      : AppTheme.backgroundLight,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.primary
                                        : AppTheme.slateBorder,
                                  ),
                                ),
                                child: Text(
                                  machine,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? AppTheme.primary : AppTheme.slateMedium,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section 2: Failure Classification
                  _buildSectionHeader(
                    icon: Icons.category_rounded,
                    title: 'Incident Classification',
                    subtitle: 'Categorize the failure nature to dispatch proper maintenance.',
                  ),
                  const SizedBox(height: 12),
                  _buildTypeSelector(),

                  const SizedBox(height: 24),

                  // Section 3: Issue Description
                  _buildSectionHeader(
                    icon: Icons.description_rounded,
                    title: 'Failure Symptoms & Description',
                    subtitle: 'Detail observed anomalies, sounds, leakages, or error codes.',
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.slateBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Detailed Description *',
                            hintText: 'e.g. Grinding noise from spindle bearing, motor trips breaker during startup, or fluid leakage observed...',
                            alignLabelWithHint: true,
                          ),
                          validator: (value) => (value == null || value.trim().isEmpty)
                              ? 'Please provide a detailed incident description'
                              : null,
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Icon(Icons.info_outline_rounded, size: 14, color: AppTheme.slateLight),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Include any relevant error codes, symptoms, and urgency notes.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: AppTheme.slateLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Reporter Info Strip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person_pin_rounded, color: AppTheme.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Reporting as: ${user?.username ?? 'Anonymous'} (${user?.role.label ?? 'Technician'})',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryDark,
                            ),
                          ),
                        ),
                        const Text(
                          'Auto-timestamped',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle_rounded, size: 18),
                                    SizedBox(width: 8),
                                    Text('Submit Report'),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.slateDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12.5,
            color: AppTheme.slateLight,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      children: FailureType.values.map((type) {
        final isSelected = _selectedType == type;
        final color = AppTheme.getTypeColor(type);
        final icon = AppTheme.getTypeIcon(type);

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => setState(() => _selectedType = type),
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected ? color.withValues(alpha: 0.07) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? color : AppTheme.slateBorder,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color
                          : color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.white : color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type.label,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? color : AppTheme.slateDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          type.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.slateLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? color : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? color : AppTheme.slateBorder,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
