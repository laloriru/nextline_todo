// Widget de maquetación que sirve para darle forma al contenido
// a mostrar un registro individual tipo vista de un registro TODO
// Es un contenedor de Widgets que pueden ser elementos de tipo
// 'Cargando' o un formulario.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/todos_bloc.dart';
import 'view_todo_bloc_builder.dart';

class ViewTodoPage extends StatefulWidget {
  const ViewTodoPage({Key? key}) : super(key: key);

  @override
  ViewTodoPageState createState() => ViewTodoPageState();
}

class ViewTodoPageState extends State<ViewTodoPage> {
  // Título principal del top del Widget
  String title = '';
  // ID del TODOS dentro de la API
  String entryID = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    // Obteniendo información del registro desde la pantalla anterior
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
            title: Text('Detalles de ${title.toUpperCase()}'),
          ),
          body: const SafeArea(child: ViewTodoBuilder()),
        ));
  }

  Future<bool> goBack() async {
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
    BlocProvider.of<TodosCubit>(context).emit(const InitialState());
    return true;
  }
}
