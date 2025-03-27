import 'package:frontend/features/expense/domain/entities/expense.dart';
import 'package:frontend/features/expense/domain/entities/expense_summary.dart';

abstract class ExpenseRemoteDataSource {
  Future<List<Expense>> getExpenses();
  Future<List<ExpenseSummary>> getSummary(String period);
  Future<void> addExpense(Expense expense);
  Future<void> deleteExpense(String id);
}
