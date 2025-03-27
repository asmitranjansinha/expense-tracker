import 'package:frontend/features/expense/domain/repositories/expense_repository.dart';

class DeleteExpense {
  final ExpenseRepository _repository;

  DeleteExpense(this._repository);

  Future<void> call(String id) async {
    return await _repository.deleteExpense(id);
  }
}
