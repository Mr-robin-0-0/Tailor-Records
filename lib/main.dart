import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/db/isar_db.dart';
import 'core/db/isar_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/customers/presentation/customer_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final isar = await IsarDb.init();
    runApp(
      ProviderScope(
        overrides: [
          isarProvider.overrideWithValue(isar),
        ],
        child: const TailorRecordsApp(),
      ),
    );
  } catch (error) {
    runApp(LaunchErrorApp(message: error.toString()));
  }
}

class TailorRecordsApp extends StatelessWidget {
  const TailorRecordsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tailor Records',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      scrollBehavior: const CupertinoScrollBehavior(),
      home: const CustomerListScreen(),
    );
  }
}

class LaunchErrorApp extends StatelessWidget {
  const LaunchErrorApp({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tailor Records',
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                'Tailor Records could not start.\n\n$message',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
