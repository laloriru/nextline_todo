// Widget que funciona como interfaz de visualización de un
// registro individual tipo Todos mediante una llamada a la API.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';
import 'package:expandable/expandable.dart';

import '../../bloc/todos_bloc.dart';

class ViewTodoForm extends StatefulWidget {
  const ViewTodoForm({
    Key? key,
    this.entry,
    this.autoFocus = false,
  }) : super(key: key);

  final Map<String, dynamic>? entry;
  final bool autoFocus;

  @override
  ViewTodoFormState createState() => ViewTodoFormState();
}

class ViewTodoFormState extends State<ViewTodoForm> {
  // Variable que almacena el registro individual tipo TODOS. Se inicializa por default
  Map<String, dynamic> entry = <String, dynamic>{
    'id': '',
    'title': '',
    'is_completed': false,
    'description': '',
    'comments': '',
    'tags': '',
  };
  late ThemeData theme;

  // Asignamos valores a variable entry en caso de que se vaya a editar un registro
  @override
  void initState() {
    if (widget.entry?.isNotEmpty == true) {
      entry['id'] = widget.entry!['id'];
      entry['title'] = widget.entry!['title'];
      entry['description'] = widget.entry!['description'];
      entry['comments'] = widget.entry!['comments'];
      entry['tags'] = widget.entry!['tags'];
      if (widget.entry?['is_completed'] == 1) {
        entry['is_completed'] = 1;
      } else {
        entry['is_completed'] = 0;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: SizedBox(
            width: double.infinity,
            child: Column(children: <Widget>[
              Text('Título:', style: theme.textTheme.headline5),
              Text(entry['title'], style: theme.textTheme.headline3),
              const SizedBox(height: 30),
              Text('Completada:', style: theme.textTheme.headline5),
              Text(
                  entry['is_completed'] == 1 ? 'Si' : 'No',
                  style: theme.textTheme.headline3),
              const SizedBox(height: 30),
              Text('Descripción:', style: theme.textTheme.headline5),
              Text(entry['description'], style: theme.textTheme.headline3),
              const SizedBox(height: 30),
              Text('Comentarios:', style: theme.textTheme.headline5),
              Text(entry['comments'], style: theme.textTheme.headline3),
              const SizedBox(height: 30),
              Text('Tags:', style: theme.textTheme.headline5),
              Text(entry['tags'], style: theme.textTheme.headline3),
              const SizedBox(height: 30),
              Text('Fecha expiración:', style: theme.textTheme.headline5),
              Text(
                  entry['due_date'] == null ? '' : entry['due_date'].toString(),
                  style: theme.textTheme.headline3),
            ])));
  }
}
