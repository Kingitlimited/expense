import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';
import 'services/add_transaction_provider.dart';
import 'services/analytics_provider.dart';
import 'services/app_state_provider.dart';
import 'services/currency_provider.dart';
import 'services/transaction_service.dart';

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = createRouter();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionService()),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
        ChangeNotifierProvider(create: (_) => AddTransactionProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        title: 'Expense Tracker',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      ),
    );
  }
}
