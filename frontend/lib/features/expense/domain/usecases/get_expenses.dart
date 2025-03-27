import 'package:frontend/features/expense/domain/entities/expense.dart';
import 'package:frontend/features/expense/domain/repositories/expense_repository.dart';

class GetExpenses {
  final ExpenseRepository repository;

  GetExpenses({required this.repository});

  Future<List<Expense>> call() async {
    return await repository.getExpenses();
  }
}
