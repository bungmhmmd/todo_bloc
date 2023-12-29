import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Blocs/Blocs.dart';
import '../../models/todo_model.dart';

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<FilteredTodosBloc>().state.filteredTodos;
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: todos.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: ValueKey(todos[index].id),
          background: showBackground(0),
          secondaryBackground: showBackground(1),
          onDismissed: (_) {
            context
                .read<TodoListBloc>()
                .add(RemoveTodoEvent(todo: todos[index]));
          },
          confirmDismiss: (_) => showDeleteConfirmationDialog(context),
          child: TodoItem(todo: todos[index]),
        );
      },
    );
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Todo'),
              content:
                  const Text('Are you sure you want to delete this todo item?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  // onPressed: () => Navigator.of(context).pop(false),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Widget showBackground(int direction) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.red,
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  final TodoModel todo;
  const TodoItem({super.key, required this.todo});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late TextEditingController todoDescController;

  @override
  void initState() {
    super.initState();
    todoDescController = TextEditingController();
  }

  @override
  void dispose() {
    todoDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              bool _error = false;
              todoDescController.text = widget.todo.desc;

              return StatefulBuilder(
                builder: (BuildContext context, setState) {
                  return AlertDialog(
                      title: Text('Edit'),
                      content: TextField(
                        controller: todoDescController,
                        autofocus: true,
                        decoration: InputDecoration(
                            hintText: 'Type something',
                            errorText: _error ? 'Can\'t be empty' : null),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Edit'),
                          onPressed: () {
                            if (todoDescController.text.isEmpty) {
                              setState(() {
                                _error = true;
                              });
                            } else {
                              context.read<TodoListBloc>().add(EditTodoEvent(
                                  id: widget.todo.id,
                                  newDesc: todoDescController.text));
                              Navigator.of(context).pop();
                            }
                          },
                        )
                      ]);
                },
              );
            });
      },
      leading: Checkbox(
        value: widget.todo.completed,
        onChanged: (bool? value) {
          context.read<TodoListBloc>().add(ToggleTodoEvent(id: widget.todo.id));
        },
      ),
      title: Text(
        widget.todo.desc,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
