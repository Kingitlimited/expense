import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../app_router.dart';

class Home extends StatelessWidget {
  const Home({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _indexFromLocation(location);
    final appState = context.watch<AppStateProvider>();

    if (appState.selectedIndex != selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        context.read<AppStateProvider>().setIndex(selectedIndex);
      });
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: appState.selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Convert',
          ),
        ],
        onTap: (index) {
          if (index == appState.selectedIndex) return;
          context.go(_routeForIndex(index));
          context.read<AppStateProvider>().setIndex(index);
        },
      ),
    );
  }

  int _indexFromLocation(String location) {
    if (location.startsWith(AppRoutes.addTransaction)) return 1;
    if (location.startsWith(AppRoutes.analytics)) return 2;
    if (location.startsWith(AppRoutes.converter)) return 3;
    return 0;
  }

  String _routeForIndex(int index) {
    switch (index) {
      case 1:
        return AppRoutes.addTransaction;
      case 2:
        return AppRoutes.analytics;
      case 3:
        return AppRoutes.converter;
      default:
        return AppRoutes.dashboard;
    }
  }
}
