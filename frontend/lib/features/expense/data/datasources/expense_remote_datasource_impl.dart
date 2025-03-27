// expense_remote_data_source.dart
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:frontend/features/expense/domain/entities/expense_summary.dart';
import '../../domain/entities/expense.dart';

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final ApiService apiService;

  ExpenseRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<Expense>> getExpenses() async {
    final response = await apiService.get('expenses/');
    return (response['data'] as List).map((e) => Expense.fromJson(e)).toList();
  }

  @override
  Future<List<ExpenseSummary>> getSummary(String period) async {
    final response = await apiService.get('expenses/summary?period=$period');
    return (response['data'] as List)
        .map((e) => ExpenseSummary.fromJson(e))
        .toList();
  }

  @override
  Future<void> addExpense(Expense expense) async {
    await apiService.post('expenses/', expense.toJson());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await apiService.delete('api/expenses/$id');
  }
}
