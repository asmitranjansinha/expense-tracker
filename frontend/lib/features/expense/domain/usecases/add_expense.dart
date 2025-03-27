import 'package:frontend/features/expense/domain/entities/expense.dart';
import 'package:frontend/features/expense/domain/repositories/expense_repository.dart';

class AddExpense {
  final ExpenseRepository repository;

  AddExpense({required this.repository});

  Future<void> call(Expense expense) async {
    return await repository.addExpense(expense);
  }
}
