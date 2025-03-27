import 'package:frontend/features/expense/domain/entities/expense_summary.dart';
import 'package:frontend/features/expense/domain/repositories/expense_repository.dart';

class GetSummary {
  final ExpenseRepository repository;

  GetSummary({required this.repository});

  Future<List<ExpenseSummary>> call(String period) async {
    return await repository.getSummary(period);
  }
}
