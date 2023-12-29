import 'package:flutter/material.dart';

import 'create_todo.dart';
import 'search_and_filter_todo.dart';
import 'show_todos.dart';
import 'todo_header.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              TodoHeader(),
              CreateTodo(),
              SizedBox(
                height: 20,
              ),
              SearchAndFilterTodo(),
              ShowTodos()
            ],
          ),
        ),
      ),
    );
  }
}
