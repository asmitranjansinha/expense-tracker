import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/expense/domain/entities/expense.dart';
import 'package:frontend/features/expense/presentation/providers/expense_provider.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  static const routeName = '/activity';

  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Color _getRandomColor(String initial) {
    final colors = [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.green,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.teal,
    ];
    final index = initial.codeUnitAt(0) % colors.length;
    return colors[index];
  }

  List<Expense> _filterTransactions(List<Expense> transactions) {
    if (_searchQuery.isEmpty) return transactions;

    final query = _searchQuery.toLowerCase();
    return transactions.where((transaction) {
      return transaction.beneficiary.toLowerCase().contains(query) ||
          transaction.amount.toString().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(builder: (context, provider, child) {
      final filteredTransactions = _filterTransactions(provider.expenses);

      return Scaffold(
        appBar: _isSearching ? _buildSearchAppBar() : _buildNormalAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (filteredTransactions.isEmpty)
                Center(
                  child: Text(
                    _searchQuery.isEmpty
                        ? "No expenses recorded yet, add one to get started."
                        : "No results found for '$_searchQuery'",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      final initial = transaction.beneficiary
                          .toString()
                          .substring(0, 1)
                          .toUpperCase();
                      final color = _getRandomColor(initial);

                      return _TransactionItem(
                        color: color,
                        initial: initial,
                        beneficiary: transaction.beneficiary,
                        amount: transaction.amount,
                        date: transaction.date,
                        category: transaction.category,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      );
    });
  }

  AppBar _buildNormalAppBar() {
    return AppBar(
      centerTitle: false,
      title: const Text(
        'activity',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.pie_chart),
          onPressed: () {
            Navigator.pushNamed(context, '/analytics');
          },
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 18.0,
            left: 8.0,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: CircleAvatar(
              backgroundImage: AssetImage(
                'assets/avatars/avatar1.png',
              ),
              radius: 15,
            ),
          ),
        ),
      ],
    );
  }

  AppBar _buildSearchAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(CupertinoIcons.xmark),
        onPressed: () {
          setState(() {
            _isSearching = false;
            _searchQuery = '';
            _searchController.clear();
          });
        },
      ),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Search by name or amount...',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
      actions: [
        if (_searchQuery.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
            },
          ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Color color;
  final String initial;
  final String beneficiary;
  final double amount;
  final DateTime date;
  final String category;

  const _TransactionItem({
    required this.color,
    required this.initial,
    required this.beneficiary,
    required this.amount,
    required this.date,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Initial with random color
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Beneficiary and category
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    beneficiary,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Amount and date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '-\$${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
