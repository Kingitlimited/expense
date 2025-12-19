import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/transaction_service.dart';
import '../services/currency_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/center_icon_app_bar.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: '1');
    _amountController.addListener(_onAmountChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CurrencyProvider>().setAmount(_amountController.text);
    });
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    context.read<CurrencyProvider>().setAmount(_amountController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TransactionService, CurrencyProvider>(
      builder: (context, service, currency, _) {
        final totalBalance = service.totalBalance;

        return Scaffold(
          appBar: const CenterIconAppBar(
            icon: Icons.currency_exchange,
            title: 'Currency Converter',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                BalanceCard(
                  title: 'Your Total Balance',
                  amount: '৳${totalBalance.toStringAsFixed(2)}',
                  gradientColors: [Colors.blue[400]!, Colors.blue[700]!],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Convert',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: currency.selectedFrom,
                        items: currency.supportedCurrencies
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text('${_getCurrencySymbol(c)} $c'),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            currency.setFrom(value);
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'From',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: currency.swapCurrencies,
                      icon: const Icon(Icons.swap_horiz),
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: currency.selectedTo,
                        items: currency.supportedCurrencies
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text('${_getCurrencySymbol(c)} $c'),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            currency.setTo(value);
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'To',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixText: _getCurrencySymbol(currency.selectedFrom),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: currency.loading
                            ? null
                            : currency.refreshRate,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh Rate'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: currency.loading ? null : currency.convert,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Convert'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (currency.loading)
                  const Center(child: CircularProgressIndicator())
                else if (currency.error != null)
                  Text(
                    currency.error!,
                    style: const TextStyle(color: Colors.red),
                  )
                else if (currency.exchangeRate != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Exchange Rate',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              '1 ${currency.selectedFrom} = ${currency.exchangeRate!.rate.toStringAsFixed(4)} ${currency.selectedTo}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        const Text(
                          'Converted Amount',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currency.convertedAmount != null
                              ? '${_getCurrencySymbol(currency.selectedTo)}${currency.convertedAmount!.toStringAsFixed(2)}'
                              : '--',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                if (currency.lastUpdated != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Last Updated: ${DateTime.now().difference(currency.lastUpdated!).inMinutes} mins ago',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getCurrencySymbol(String code) {
    const symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'AUD': 'A\$',
      'CAD': 'C\$',
      'CHF': 'CHF',
      'CNY': '¥',
      'INR': '₹',
      'MXN': '\$',
      'BDT': '৳',
    };
    return symbols[code] ?? code;
  }
}
