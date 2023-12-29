import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../todo_list/todo_list_bloc.dart';
import '../../models/todo_model.dart';

part 'active_todo_count_event.dart';
part 'active_todo_count_state.dart';

class ActiveTodoCountBloc
    extends Bloc<ActiveTodoCountEvent, ActiveTodoCountState> {
  late final StreamSubscription todoListSubscription;
  final TodoListBloc todoListBloc;
  final int initialCount;
  ActiveTodoCountBloc({required this.todoListBloc, required this.initialCount})
      : super(ActiveTodoCountState(activeTodoCount: initialCount)) {
    todoListSubscription = todoListBloc.stream.listen(
      (TodoListState todoListState) {
        print('todoListState: $todoListState');
        final int currentActiveTodoCount = todoListState.todos
            .where((TodoModel todo) => !todo.completed)
            .length;
        add(CalculateActiveTodoCountEvent(
            activeTodoCount: currentActiveTodoCount));
      },
    );

    on<CalculateActiveTodoCountEvent>((event, emit) {
      emit(state.copyWith(activeTodoCount: event.activeTodoCount));
    });
  }

  @override
  Future<void> close() {
    todoListSubscription.cancel();
    return super.close();
  }
}
