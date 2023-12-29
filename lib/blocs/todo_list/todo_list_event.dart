// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'todo_list_bloc.dart';

sealed class TodoListEvent extends Equatable {
  const TodoListEvent();

  @override
  List<Object> get props => [];
}

class AddTodoEvent extends TodoListEvent {
  final String todoDesc;

  AddTodoEvent({required this.todoDesc});

  @override
  String toString() => 'AddTodoEvent(todoDesc: $todoDesc)';

  @override
  List<Object> get props => [todoDesc];
}

class RemoveTodoEvent extends TodoListEvent {
  final TodoModel todo;

  RemoveTodoEvent({required this.todo});

  @override
  String toString() => 'RemoveTodoEvent(todo: $todo)';

  @override
  List<Object> get props => [todo];
}

class ToggleTodoEvent extends TodoListEvent {
  final String id;

  ToggleTodoEvent({required this.id});

  @override
  String toString() => 'ToggleTodoEvent(todo: $id)';

  @override
  List<Object> get props => [id];
}

class EditTodoEvent extends TodoListEvent {
  final String id;
  final String newDesc;

  EditTodoEvent({required this.id, required this.newDesc});

  @override
  String toString() => 'EditTodoEvent(todo: $id, newDesc: $newDesc)';

  @override
  List<Object> get props => [id, newDesc];
}
