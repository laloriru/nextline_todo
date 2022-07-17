import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextline_todo/todos/bloc/todos_bloc.dart';
import 'package:nextline_todo/todos/view/cu_todo/cu_todo_page.dart';
import 'package:nextline_todo/todos/view/view_todo/view_todo_page.dart';

import 'home/view/home_page.dart';

void main() {
  runApp(const NextlineTodoApp());
}

class NextlineTodoApp extends StatelessWidget {
  const NextlineTodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: <BlocProvider>[
          BlocProvider<TodosCubit>(
            create: (_) => TodosCubit(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: (Colors.blue[900])!,
          ),
          routes: <String, Widget Function(BuildContext)>{
            '/': (_) => const HomePage(),
            '/cu_todo': (_) => const CUTodoPage(),
            '/view_todo': (_) => const ViewTodoPage(),
          },
        ));
  }
}
