part of 'filtered_todos_bloc.dart';

class FilteredTodosState extends Equatable {
  final List<TodoModel> filteredTodos;

  FilteredTodosState({required this.filteredTodos});

  factory FilteredTodosState.initial() {
    return FilteredTodosState(filteredTodos: []);
  }

  @override
  List<Object> get props => [filteredTodos];

  FilteredTodosState copyWith({
    List<TodoModel>? filteredTodos,
  }) {
    return FilteredTodosState(
      filteredTodos: filteredTodos ?? this.filteredTodos,
    );
  }

  @override
  String toString() {
    return 'FilteredTodosState(filteredTodos: $filteredTodos)';
  }
}
