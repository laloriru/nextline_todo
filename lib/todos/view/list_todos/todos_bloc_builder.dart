// Widget que regresa intefaz de tipo 'Cargando', interfaz de error, por problemas
// de conexión, o bien el 'happy path' de un listado con registros de la API
// de tipo TODOS.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextline_todo/widgets/error_screen.dart';

import 'todos_list_page.dart';
import '../../bloc/todos_bloc.dart';

class ListTodosBuilder extends StatefulWidget {
  const ListTodosBuilder({Key? key}) : super(key: key);

  @override
  ListTodosBuilderState createState() => ListTodosBuilderState();
}

class ListTodosBuilderState extends State<ListTodosBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosCubit, TodosState>(
        builder: (BuildContext context, TodosState? state) {
      if (kDebugMode) {
        print('Current Todos BlocBuilder state value: ${state.toString()}');
      }
      if (state is InitialState) {
        BlocProvider.of<TodosCubit>(context).getTodos();
        return const SizedBox(
            height: 500, child: Center(child: CircularProgressIndicator()));
      } else if (state is FoundState) {
        return TodosListPage(items: state.items);
      } else if (state is DeletedState) {
        BlocProvider.of<TodosCubit>(context).emit(const InitialState());
        const SnackBar snackBar = SnackBar(
          content: Text('¡Tarea eliminada exitosamente!',
              textAlign: TextAlign.center),
        );
        SchedulerBinding.instance?.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        return Container();
      } else if (state is FatalErrorState) {
        return ErrorScreen(title: 'Error fatal', description: state.message);
      } else if (state is ConnectionErrorState) {
        return ErrorScreen(
            title: 'Problema de Conexión',
            description: 'Código: ${state.message}');
      } else if (state is EmptyState) {
        return const SizedBox(
            height: 500, child: Center(child: Text('No existen registros')));
      } else {
        return Container();
      }
    });
  }
}
