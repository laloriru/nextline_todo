// Este Widget regresa a su vez un Widget de visualización de un registro individual
// seleccionado el usuario para abrirlo. 
// Las opciones van desde un widget tipo 'Cargando' o vista de detalles.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/error_screen.dart';
import '../../bloc/todos_bloc.dart';
import 'view_todo_form.dart';

class ViewTodoBuilder extends StatefulWidget {
  const ViewTodoBuilder({Key? key}) : super(key: key);

  @override
  ViewTodoBuilderState createState() => ViewTodoBuilderState();
}

class ViewTodoBuilderState extends State<ViewTodoBuilder> {
  // Variable que almacena el registro individual con sus detalles de un TODOS
  Map<String, dynamic> entry = <String, dynamic>{
    'id': '',
    'title': '',
    'is_completed': 0,
    'comments': '',
    'description': '',
    'tags': '',
    'due_date': '',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosCubit, TodosState>(
      buildWhen: (TodosState previousState, TodosState state) {
        if (kDebugMode) {
          print(
              'Previous CU_Todo state value: ${previousState.toString()}, New state: ${state.toString()}');
        }
        if (state is DoNotReInitState) {
          return false;
        } else {
          return true;
        }
      },
      builder: (BuildContext context, TodosState? state) {
        if (kDebugMode) {
          print('Current CU_Todo BlocBuilder state value: ${state.toString()}');
        }
        if (state is InitialState) {
          return const ViewTodoForm(autoFocus: true);
        } else if (state is NotFoundState) {
          return const ViewTodoForm(autoFocus: true);
        } else if (state is SearchState) {
          BlocProvider.of<TodosCubit>(context).getById(state.id);
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoadedState) {
          final Todos? todo = state.todo;
          if (todo != null) {
            entry['id'] = todo.id;
            entry['title'] = todo.title;
            entry['is_completed'] = todo.isCompleted;
            entry['description'] = todo.description;
            entry['comments'] = todo.comments;
            entry['tags'] = todo.tags;
            entry['due_date'] = todo.dueDate;
          }
          return ViewTodoForm(entry: entry);
        } else if (state is CreatedUpdatedState) {
          const SnackBar snackBar = SnackBar(
            content: Text('¡Tarea guardada exitosamente!',
                textAlign: TextAlign.center),
          );
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            BlocProvider.of<TodosCubit>(context).emit(const InitialState());
            goBack();
          });
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FatalErrorState) {
          return ErrorScreen(title: 'Error fatal', description: state.message);
        } else if (state is ConnectionErrorState) {
          return ErrorScreen(
              title: 'Problema de Conexión',
              description: 'Código: ${state.message}');
        } else {
          return const ViewTodoForm(autoFocus: true);
        } //state
      },
    );
  }

  void goBack() async {
    Navigator.pop(context);
  }
}
