// Widget de maquetación que sirve para darle forma al contenido
// a mostrar dependiendo de la opción seleccionada por el usuario.
// Es un contenedor de Widgets que pueden ser elementos de tipo
// 'Cargando' o un formulario.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/todos_bloc.dart';
import 'cu_todo_bloc_builder.dart';

class CUTodoPage extends StatefulWidget {
  const CUTodoPage({Key? key}) : super(key: key);

  @override
  CUTodoPageState createState() => CUTodoPageState();
}

class CUTodoPageState extends State<CUTodoPage> {
  // Título principal del top del Widget
  String title = '';
  // ID del TODOS dentro de la API
  String entryID = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    // Descubriendo si vamos a editar o a crear un nuevo elemento
    if (arguments['id'] != null) {
      title = arguments['title'].toString();
      entryID = arguments['id'].toString();
      BlocProvider.of<TodosCubit>(context).emit(SearchState(entryID));
    }
    return WillPopScope(
        onWillPop: () {
          return goBack();
        },
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new), onPressed: goBack),
            title: Text(title),
          ),
          body: const SafeArea(child: CUTodoBuilder()),
        ));
  }

  Future<bool> goBack() async {
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
    BlocProvider.of<TodosCubit>(context).emit(const InitialState());
    return true;
  }
}
