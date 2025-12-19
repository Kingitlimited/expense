import 'package:go_router/go_router.dart';
import 'screens/home.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/currency_converter_screen.dart';
import 'screens/dashboard_screen.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String addTransaction = '/add';
  static const String analytics = '/analytics';
  static const String converter = '/converter';
}

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      ShellRoute(
        builder: (context, state, child) => Home(
          // ignore: sort_child_properties_last
          child: child,
          location: state.uri.toString(),
        ),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.addTransaction,
            builder: (context, state) => const AddTransactionScreen(),
          ),
          GoRoute(
            path: AppRoutes.analytics,
            builder: (context, state) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: AppRoutes.converter,
            builder: (context, state) => const CurrencyConverterScreen(),
          ),
        ],
      ),
    ],
  );
}
