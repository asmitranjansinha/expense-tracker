import 'package:frontend/features/expense/domain/entities/expense_summary.dart';

import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpenses();
  Future<List<ExpenseSummary>> getSummary(String period);
  Future<void> addExpense(Expense expense);
  Future<void> deleteExpense(String id);
}
