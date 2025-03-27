import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/features/expense/domain/entities/expense_summary.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/get_expenses.dart';
import '../../domain/usecases/get_summary.dart';

class ExpenseProvider with ChangeNotifier {
  final GetExpenses getExpenses;
  final GetSummary getSummary;
  final AddExpense addExpense;
  final DeleteExpense deleteExpense;

  ExpenseProvider({
    required this.getExpenses,
    required this.getSummary,
    required this.addExpense,
    required this.deleteExpense,
  });

  // State variables
  List<Expense> _expenses = [];
  List<ExpenseSummary> _dailySummary = [];
  List<ExpenseSummary> _weeklySummary = [];
  List<ExpenseSummary> _monthlySummary = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Expense> get expenses => _expenses;
  List<ExpenseSummary> get dailySummary => _dailySummary;
  List<ExpenseSummary> get weeklySummary => _weeklySummary;
  List<ExpenseSummary> get monthlySummary => _monthlySummary;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // State management methods
  Future<void> loadExpenses() async {
    _setLoading(true);
    try {
      _expenses = await getExpenses();
      _error = null;
      await loadSummary();
    } catch (e) {
      _error = e.toString();
      _expenses = [];
      _dailySummary = [];
      _weeklySummary = [];
      _monthlySummary = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadSummary() async {
    _setLoading(true);
    try {
      _dailySummary = await getSummary('daily');
      _weeklySummary = await getSummary('weekly');
      _monthlySummary = await getSummary('monthly');

      // Add debug prints
      log('Daily Summary: ${_dailySummary.length} items');
      log('Weekly Summary: ${_weeklySummary.length} items');
      log('Monthly Summary: ${_monthlySummary.length} items');
      _error = null;
    } catch (e) {
      _error = e.toString();
      _dailySummary = [];
      _weeklySummary = [];
      _monthlySummary = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createExpense(Expense expense) async {
    _setLoading(true);
    try {
      await addExpense(expense);
      await loadExpenses(); // Refresh data after adding
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeExpense(String id) async {
    _setLoading(true);
    try {
      await deleteExpense(id);
      _expenses.removeWhere((expense) => expense.id == id);
      await loadSummary(); // Refresh summary
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Filtering and utility methods
  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((expense) => expense.category == category).toList();
  }

  double getTotalExpenses() {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  Map<String, double> getCategoryTotals() {
    final Map<String, double> categoryTotals = {};
    for (var expense in _expenses) {
      categoryTotals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return categoryTotals;
  }

  // For the bottom sheet form
  final TextEditingController amountController = TextEditingController();
  final TextEditingController beneficiaryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = 'Other';
  DateTime selectedDate = DateTime.now();

  void resetForm() {
    amountController.clear();
    beneficiaryController.clear();
    descriptionController.clear();
    selectedCategory = 'Other';
    selectedDate = DateTime.now();
  }

  Future<void> submitExpenseForm(BuildContext context) async {
    if (beneficiaryController.text.isEmpty || amountController.text.isEmpty) {
      _error = 'Please fill all required fields';
      notifyListeners();
      return;
    }

    final expense = Expense(
      id: '',
      amount: double.parse(amountController.text),
      beneficiary: beneficiaryController.text,
      category: selectedCategory,
      description: descriptionController.text.isEmpty
          ? null
          : descriptionController.text,
      date: selectedDate,
      createdAt: DateTime.now(),
    );

    await createExpense(expense);
    if (_error == null) {
      resetForm();
      Navigator.pop(context);
    }
  }

  void updateSelectedCategory(String? category) {
    if (category != null) {
      selectedCategory = category;
      notifyListeners();
    }
  }

  Future<void> updateSelectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      notifyListeners();
    }
  }
}
