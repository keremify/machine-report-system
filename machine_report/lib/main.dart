import 'package:flutter/material.dart';

import 'screens/create_failure_page.dart';
import 'screens/failure_list_page.dart';
import 'screens/login_page.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MachineReportApp());
}

class MachineReportApp extends StatelessWidget {
  const MachineReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MachinePulse - Industrial Incident System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute:
          AuthService.instance.currentUser == null ? '/login' : '/reports',
      routes: {
        '/login': (_) => const LoginPage(),
        '/reports': (_) => const FailureListPage(),
        '/create': (_) => const CreateFailurePage(),
      },
    );
  }
}