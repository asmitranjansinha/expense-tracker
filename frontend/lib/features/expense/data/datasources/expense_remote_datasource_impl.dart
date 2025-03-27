// expense_remote_data_source.dart
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/features/expense/data/datasources/expense_remote_datasource.dart';
import '../../domain/entities/expense.dart';

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final ApiService apiService;

  ExpenseRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<Expense>> getExpenses() async {
    final response = await apiService.get('api/expenses');
    return (response as List).map((e) => Expense.fromJson(e)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getSummary(String period) async {
    final response =
        await apiService.get('api/expenses/summary?period=$period');
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<void> addExpense(Expense expense) async {
    await apiService.post('api/expenses', expense.toJson());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await apiService.delete('api/expenses/$id');
  }
}
