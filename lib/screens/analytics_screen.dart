import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/transaction_service.dart';
import '../services/analytics_provider.dart';
import '../widgets/center_icon_app_bar.dart';
import '../widgets/filter_button.dart';
import '../widgets/category_item.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<TransactionService, AnalyticsProvider>(
      builder: (context, service, analytics, _) {
        final expenses = service.getExpensesByCategoryForPeriod(
          analytics.selectedPeriod,
        );
        final expenseEntries = expenses.entries.toList();
        final maxExpense = expenseEntries.isEmpty
            ? 0.0
            : expenseEntries
                  .map((entry) => entry.value)
                  .reduce((a, b) => a > b ? a : b);
        final colors = [
          const Color(0xFFEF5350),
          const Color(0xFF42A5F5),
          const Color(0xFFAB47BC),
          const Color(0xFFFFA726),
          const Color(0xFF29B6F6),
        ];

        return Scaffold(
          appBar: const CenterIconAppBar(
            icon: Icons.bar_chart,
            title: 'Analytics',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Filter by Period',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    FilterButton(
                      label: 'Week',
                      isSelected: analytics.selectedPeriod == 'week',
                      onTap: () => analytics.setPeriod('week'),
                    ),
                    const SizedBox(width: 8),
                    FilterButton(
                      label: 'Month',
                      isSelected: analytics.selectedPeriod == 'month',
                      onTap: () => analytics.setPeriod('month'),
                    ),
                    const SizedBox(width: 8),
                    FilterButton(
                      label: 'Year',
                      isSelected: analytics.selectedPeriod == 'year',
                      onTap: () => analytics.setPeriod('year'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  height: 280,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: expenseEntries.isEmpty
                      ? const Center(child: Text('No expenses data'))
                      : BarChart(
                          BarChartData(
                            maxY: expenseEntries.isEmpty
                                ? 5000
                                : maxExpense * 1.2,
                            barGroups: expenseEntries.asMap().entries.map((
                              entry,
                            ) {
                              final index = entry.key;
                              final categoryEntry = entry.value;
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: categoryEntry.value,
                                    color: colors[index % colors.length],
                                    width: 16,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(4),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final categories = expenses.keys.toList();
                                    if (value.toInt() < categories.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          categories[value.toInt()],
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      '৳${(value ~/ 1000)}k',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Top Categories',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...expenseEntries.asMap().entries.map((entry) {
                  final categoryColors = [
                    Colors.yellow[100]!,
                    Colors.blue[100]!,
                    Colors.pink[100]!,
                    Colors.orange[100]!,
                    Colors.green[100]!,
                  ];
                  return CategoryItem(
                    name: entry.value.key,
                    amount: '৳${entry.value.value.toStringAsFixed(2)}',
                    backgroundColor:
                        categoryColors[entry.key % categoryColors.length],
                  );
                  // ignore: unnecessary_to_list_in_spreads
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
