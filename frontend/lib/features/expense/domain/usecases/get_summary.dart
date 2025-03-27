import 'package:frontend/features/expense/domain/repositories/expense_repository.dart';

class GetSummary {
  final ExpenseRepository repository;

  GetSummary(this.repository);

  Future<List<Map<String, dynamic>>> call(String period) async {
    return await repository.getSummary(period);
  }
}
