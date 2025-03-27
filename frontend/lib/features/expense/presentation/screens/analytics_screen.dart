import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/expense/domain/entities/expense_summary.dart';
import 'package:frontend/features/expense/presentation/providers/expense_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart' as charts;

class AnalyticsScreen extends StatelessWidget {
  static const routeName = '/analytics';

  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.back),
          ),
          centerTitle: false,
          titleSpacing: -3,
          title: const Text(
            'Analytics',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCards(provider),
                    const SizedBox(height: 24),
                    _buildCategoryPieChart(provider.monthlySummary, 'Monthly'),
                    const SizedBox(height: 24),
                    _buildCategoryPieChart(provider.weeklySummary, 'Weekly'),
                    const SizedBox(height: 24),
                    _buildCategoryPieChart(provider.dailySummary, 'Daily'),
                    const SizedBox(height: 24),
                    _buildCategoryList(provider.monthlySummary),
                  ],
                ),
              ),
      );
    });
  }

  Widget _buildSummaryCards(ExpenseProvider provider) {
    return Row(
      children: [
        _buildSummaryCard(
          'Daily',
          _calculateTotal(provider.dailySummary),
          Icons.today,
        ),
        const SizedBox(width: 12),
        _buildSummaryCard(
          'Weekly',
          _calculateTotal(provider.weeklySummary),
          Icons.calendar_view_week,
        ),
        const SizedBox(width: 12),
        _buildSummaryCard(
          'Monthly',
          _calculateTotal(provider.monthlySummary),
          Icons.calendar_today,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String period, double amount, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 10),
                  const SizedBox(width: 5),
                  Text(
                    period,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '-\$${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPieChart(List<ExpenseSummary> summary, String title) {
    final chartData = _prepareChartData(summary);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title Category Breakdown',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: charts.PieChart(
                charts.PieChartData(
                  sections: chartData,
                  centerSpaceRadius: 0,
                  sectionsSpace: 4,
                  startDegreeOffset: -90,
                  pieTouchData: charts.PieTouchData(
                    touchCallback:
                        (charts.FlTouchEvent event, pieTouchResponse) {
                      // Handle touch events if needed
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(chartData),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(List<charts.PieChartSectionData> sections) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sections.map((section) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              color: section.color,
            ),
            const SizedBox(width: 4),
            Text(
              '${section.title} (${section.value.toStringAsFixed(0)})',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildCategoryList(List<ExpenseSummary> summary) {
    final categoryMap = {
      'Food': Icons.restaurant,
      'Travel': Icons.flight,
      'Transfers': Icons.swap_horiz,
      'Gift': Icons.card_giftcard,
      'Entertainment': Icons.movie,
      'Utilities': Icons.bolt,
      'Shopping': Icons.shopping_bag,
      'Healthcare': Icons.medical_services,
      'Education': Icons.school,
      'Other': Icons.category,
    };

    final data = _prepareChartData(summary);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...data.map((section) => ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: section.color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      categoryMap[section.title] ?? Icons.category,
                      color: section.color,
                    ),
                  ),
                  title: Text(section.title),
                  trailing: Text(
                    '-\$${section.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  List<charts.PieChartSectionData> _prepareChartData(
      List<ExpenseSummary> summary) {
    final colors = [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.green,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.teal,
      Colors.pinkAccent,
      Colors.amber,
      Colors.indigo,
      Colors.brown,
    ];

    return summary.asMap().entries.map((entry) {
      final index = entry.key % colors.length;
      final expense = entry.value;
      final value = (expense.totalAmount ?? 0).toDouble();
      final category = expense.iId?.category ?? 'Other';

      return charts.PieChartSectionData(
        color: colors[index],
        value: value,
        title: category,
        radius: 120,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  double _calculateTotal(List<ExpenseSummary> summary) {
    return summary
        .fold(0, (sum, item) => sum + (item.totalAmount ?? 0))
        .toDouble();
  }
}
