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
      return DefaultTabController(
        length: 3,
        child: Scaffold(
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
            bottom: TabBar(
              tabs: const [
                Tab(text: 'Daily'),
                Tab(text: 'Weekly'),
                Tab(text: 'Monthly'),
              ],
              onTap: (index) {
                // You could add logic here if needed when tabs change
              },
            ),
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    _buildAnalyticsView(provider.dailySummary, 'Daily'),
                    _buildAnalyticsView(provider.weeklySummary, 'Weekly'),
                    _buildAnalyticsView(provider.monthlySummary, 'Monthly'),
                  ],
                ),
        ),
      );
    });
  }

  Widget _buildAnalyticsView(List<ExpenseSummary> summary, String period) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCardForPeriod(summary, period),
          const SizedBox(height: 24),
          _buildCategoryPieChart(summary, period),
          const SizedBox(height: 24),
          _buildCategoryList(summary),
        ],
      ),
    );
  }

  Widget _buildSummaryCardForPeriod(
      List<ExpenseSummary> summary, String period) {
    final icon = _getPeriodIcon(period);
    final amount = _calculateTotal(summary);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  period,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '-\$${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPeriodIcon(String period) {
    switch (period) {
      case 'Daily':
        return Icons.today;
      case 'Weekly':
        return Icons.calendar_view_week;
      case 'Monthly':
        return Icons.calendar_today;
      default:
        return Icons.category;
    }
  }

  Widget _buildCategoryPieChart(List<ExpenseSummary> summary, String period) {
    final chartData = _prepareChartData(summary);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$period Category Breakdown',
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
                  sectionsSpace: 2,
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
    final totalAmount = _calculateTotal(summary);

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
            ...data.map((section) {
              final percentage =
                  totalAmount > 0 ? (section.value / totalAmount * 100) : 0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
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
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(section.color),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '-\$${section.value.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
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
        radius: 100,
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
