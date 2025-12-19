import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/transaction_service.dart';
import '../models/transaction.dart';
import '../widgets/center_icon_app_bar.dart';
import '../widgets/stat_card.dart';
import '../widgets/transaction_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CenterIconAppBar(icon: Icons.home, title: 'Dashboard'),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: Consumer<TransactionService>(
          builder: (context, service, _) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Total Balance Card
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 6,
                      child: StatCard(
                        label: 'Total Balance',
                        amount: '৳${service.totalBalance.toStringAsFixed(2)}',
                        backgroundColor: Colors.blue[50]!,
                        textColor: Colors.blue[900]!,
                        fontSize: 32,
                      ),
                    ),
                    if (service.totalBalance < 0) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          border: Border.all(color: Colors.red[200]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.red[700]),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Warning: Expenses are higher than your balance.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Expense and Income Cards
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            label: 'Expenses',
                            amount:
                                '৳${service.totalExpenses.toStringAsFixed(2)}',
                            backgroundColor: Colors.red[100]!,
                            textColor: Colors.red[700]!,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            label: 'Income',
                            amount:
                                '৳${service.totalIncome.toStringAsFixed(2)}',
                            backgroundColor: Colors.green[100]!,
                            textColor: Colors.green[700]!,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Recent Transactions List
                    ...service.recentTransactions.map((t) {
                      return TransactionItem(
                        category: t.category,
                        date: DateFormat('dd MMM yyyy').format(t.date),
                        amount:
                            '${t.type == 'expense' ? '-' : '+'}৳${t.amount.toStringAsFixed(2)}',
                        isExpense: t.type == 'expense',
                        onTap: () =>
                            _showTransactionDetails(context, t, service),
                      );
                      // ignore: unnecessary_to_list_in_spreads
                    }).toList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showTransactionDetails(
    BuildContext context,
    Transaction t,
    TransactionService service,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Transaction Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _detailRow('Category', t.category),
            _detailRow('Amount', '৳${t.amount.toStringAsFixed(2)}'),
            _detailRow('Type', t.type.toUpperCase()),
            _detailRow('Date', DateFormat('dd MMM yyyy').format(t.date)),
            if (t.note != null) _detailRow('Note', t.note!),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      service.deleteTransaction(t.id);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
