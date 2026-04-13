import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:personal_money_tracker/providers/expense_provider.dart';
import 'package:personal_money_tracker/screens/home_screen.dart';
import 'package:personal_money_tracker/services/hive_service.dart';
import 'package:personal_money_tracker/utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await HiveService.instance.init();
    runApp(const CoinFlowApp());
  } catch (error) {
    runApp(
      InitializationErrorApp(
        message: 'The app could not start. Please restart and try again.',
        details: error.toString(),
      ),
    );
  }
}

class CoinFlowApp extends StatelessWidget {
  const CoinFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExpenseProvider()..loadExpenses(),
      child: MaterialApp(
        title: 'CoinFlow',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const HomeScreen(),
      ),
    );
  }
}

class InitializationErrorApp extends StatelessWidget {
  const InitializationErrorApp({
    required this.message,
    required this.details,
    super.key,
  });

  final String message;
  final String details;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      details,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
