import 'package:frontend/features/expense/domain/entities/expense.dart';

abstract class ExpenseRemoteDataSource {
  Future<List<Expense>> getExpenses();
  Future<List<Map<String, dynamic>>> getSummary(String period);
  Future<void> addExpense(Expense expense);
  Future<void> deleteExpense(String id);
}
