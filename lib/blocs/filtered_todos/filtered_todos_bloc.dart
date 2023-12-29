import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../todo_filter/todo_filter_bloc.dart';
import '../todo_list/todo_list_bloc.dart';
import '../todo_search/todo_search_bloc.dart';
import '../../models/todo_model.dart';

part 'filtered_todos_event.dart';
part 'filtered_todos_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  late StreamSubscription todoListSubscription;
  late StreamSubscription todoFilterSubscription;
  late StreamSubscription todoSearchSubscription;

  final TodoListBloc todoListBloc;
  final TodoFilterBloc todoFilterBloc;
  final TodoSearchBloc todoSearchBloc;

  final List<TodoModel> initialTodos;
  FilteredTodosBloc(
      {required this.todoListBloc,
      required this.todoFilterBloc,
      required this.todoSearchBloc,
      required this.initialTodos})
      : super(FilteredTodosState(filteredTodos: initialTodos)) {
    todoListSubscription = todoListBloc.stream.listen((TodoListState todoList) {
      setFilteredTodos();
    });

    todoFilterSubscription =
        todoFilterBloc.stream.listen((TodoFilterState todoFilterState) {
      setFilteredTodos();
    });

    todoSearchSubscription =
        todoSearchBloc.stream.listen((TodoSearchState todoSearchState) {
      setFilteredTodos();
    });
    on<SetFilteredTodosEvent>((event, emit) {
      emit(state.copyWith(filteredTodos: event.filteredTodos));
    });
  }

  void setFilteredTodos() {
    List<TodoModel> _filteredTodos;

    switch (todoFilterBloc.state.filter) {
      case Filter.all:
        _filteredTodos = todoListBloc.state.todos;
        break;
      case Filter.active:
        _filteredTodos = todoListBloc.state.todos
            .where((TodoModel todo) => !todo.completed)
            .toList();
        break;
      case Filter.completed:
        _filteredTodos = todoListBloc.state.todos
            .where((TodoModel todo) => todo.completed)
            .toList();
        break;
    }

    if (todoSearchBloc.state.searchTerm != '') {
      _filteredTodos = _filteredTodos
          .where((TodoModel todo) => todo.desc
              .toLowerCase()
              .contains(todoSearchBloc.state.searchTerm.toLowerCase()))
          .toList();
    }

    add(SetFilteredTodosEvent(filteredTodos: _filteredTodos));
  }

  @override
  Future<void> close() {
    todoListSubscription.cancel();
    todoFilterSubscription.cancel();
    todoSearchSubscription.cancel();
    return super.close();
  }
}
