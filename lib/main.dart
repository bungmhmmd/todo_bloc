import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Blocs/Blocs.dart';
import 'pages/todo_page/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodoListBloc(),
        ),
        BlocProvider(
          create: (context) => TodoFilterBloc(),
        ),
        BlocProvider(
          create: (context) => TodoSearchBloc(),
        ),
        BlocProvider(
          create: (context) => ActiveTodoCountBloc(
              initialCount: context.read<TodoListBloc>().state.todos.length,
              todoListBloc: BlocProvider.of<TodoListBloc>(context)),
        ),
        BlocProvider(
          create: (context) => FilteredTodosBloc(
            initialTodos: context.read<TodoListBloc>().state.todos,
            todoFilterBloc: BlocProvider.of<TodoFilterBloc>(context),
            todoListBloc: BlocProvider.of<TodoListBloc>(context),
            todoSearchBloc: BlocProvider.of<TodoSearchBloc>(context),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'todo Bloc',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: TodoPage(),
      ),
    );
  }
}
