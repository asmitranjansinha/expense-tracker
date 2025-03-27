import 'package:frontend/features/expense/domain/repositories/expense_repository.dart';

class DeleteExpense {
  final ExpenseRepository repository;

  DeleteExpense({required this.repository});

  Future<void> call(String id) async {
    return await repository.deleteExpense(id);
  }
}
