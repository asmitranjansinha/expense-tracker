// expense_repository_impl.dart
import 'package:frontend/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:frontend/features/expense/domain/entities/expense_summary.dart';

import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Expense>> getExpenses() => remoteDataSource.getExpenses();

  @override
  Future<List<ExpenseSummary>> getSummary(String period) =>
      remoteDataSource.getSummary(period);

  @override
  Future<void> addExpense(Expense expense) =>
      remoteDataSource.addExpense(expense);

  @override
  Future<void> deleteExpense(String id) => remoteDataSource.deleteExpense(id);
}
