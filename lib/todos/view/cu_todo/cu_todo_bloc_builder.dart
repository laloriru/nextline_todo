// Este Widget regresa a su vez un Widget dependiendo de la opción que haya
// seleccionado el usuario. Las opciones van desde un widget tipo 'Cargando'
// hasta un formulario para crear un nuevo registro o editar un registro mediante su ID.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/error_screen.dart';
import '../../bloc/todos_bloc.dart';
import 'cu_todo_form.dart';

class CUTodoBuilder extends StatefulWidget {
  const CUTodoBuilder({Key? key}) : super(key: key);

  @override
  CUTodoBuilderState createState() => CUTodoBuilderState();
}

class CUTodoBuilderState extends State<CUTodoBuilder> {
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
          return const CUTodoForm(autoFocus: true);
        } else if (state is NotFoundState) {
          return const CUTodoForm(autoFocus: true);
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
          return CUTodoForm(entry: entry);
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
          return const CUTodoForm(autoFocus: true);
        } //state
      },
    );
  }

  void goBack() async {
    Navigator.pop(context);
  }
}
