// Widget que funciona como interfaz de formulario para crear o editar un
// registro tipo Todos mediante llamadas a la API.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';
import 'package:expandable/expandable.dart';

import '../../bloc/todos_bloc.dart';

class CUTodoForm extends StatefulWidget {
  const CUTodoForm({
    Key? key,
    this.entry,
    this.autoFocus = false,
  }) : super(key: key);

  final Map<String, dynamic>? entry;
  final bool autoFocus;

  @override
  CUTodoFormState createState() => CUTodoFormState();
}

class CUTodoFormState extends State<CUTodoForm> {
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        entry['is_completed'] = true;
      } else {
        entry['is_completed'] = false;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(children: <Widget>[
              SizedBox(
                width: 400,
                height: 80,
                child: TextFormField(
                  autofocus: widget.autoFocus,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  maxLength: 250,
                  initialValue: entry['title'].toString(),
                  validator: (String? data) {
                    // Validamos información mínimamente requerida
                    if (!isLength(data!, 6) && data != '') {
                      return 'Verifica este dato';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.source),
                    contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                    isDense: true,
                    labelText: 'Título',
                    hintMaxLines: 250,
                    errorMaxLines: 250,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String? data) {
                    entry['title'] = data!.trim();
                  },
                ),
              ),
              SizedBox(
                  width: 400,
                  height: 60,
                  child: CheckboxListTile(
                    title: const Text("Completada"),
                    value: entry['is_completed'] ?? false,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) {
                      setState(() {
                        entry['is_completed'] = value;
                      });
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: ExpandablePanel(
                      theme: const ExpandableThemeData(
                          iconColor: Colors.red, iconSize: 35),
                      header:
                          Text('Detalles', style: theme.textTheme.headline6),
                      collapsed: const Text(
                        'Descripción, comentarios y tags',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      expanded: Column(children: <Widget>[
                        SizedBox(
                          width: 400,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            autocorrect: false,
                            minLines: 3,
                            maxLines: 4,
                            maxLength: 500,
                            initialValue: entry['description'].toString(),
                            validator: (String? data) {
                              if (!isLength(data!, 3) && data != '') {
                                return 'Verifica este dato';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: 20.0, top: 8.0),
                                  child: Icon(Icons.sticky_note_2)),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20.0),
                              isDense: true,
                              labelText: 'Descripción',
                              hintMaxLines: 500,
                              errorMaxLines: 500,
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String? data) {
                              entry['description'] = data!.trim();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 400,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            autocorrect: false,
                            minLines: 3,
                            maxLines: 4,
                            maxLength: 500,
                            initialValue: entry['comments'].toString(),
                            validator: (String? data) {
                              if (!isLength(data!, 3) && data != '') {
                                return 'Verifica este dato';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: 20.0, top: 8.0),
                                  child: Icon(Icons.summarize)),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20.0),
                              isDense: true,
                              labelText: 'Comentarios',
                              hintMaxLines: 500,
                              errorMaxLines: 500,
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String? data) {
                              entry['comments'] = data!.trim();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 400,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            autocorrect: false,
                            minLines: 3,
                            maxLines: 4,
                            maxLength: 500,
                            initialValue: entry['tags'].toString(),
                            validator: (String? data) {
                              if (!isLength(data!, 3) && data != '') {
                                return 'Verifica este dato';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: 20.0, top: 8.0),
                                  child: Icon(Icons.label)),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20.0),
                              isDense: true,
                              labelText: 'Tags',
                              hintMaxLines: 500,
                              errorMaxLines: 500,
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String? data) {
                              entry['tags'] = data!.trim();
                            },
                          ),
                        ),
                      ]))),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    label: const Text('Guardar'),
                    icon: const Icon(
                      Icons.save,
                      size: 40.0,
                    ),
                    onPressed: validateForm,
                  )),
            ])));
  }

  // Verificación de que los datos introducidos por el usuarios no
  // se encuentren vacíos.
  // Si la información es correcta se actualiza o guarda el registro
  // mediante el BLoC.
  Future<void> validateForm() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate() &&
        entry['title'].toString().trim() != '') {
      if (entry['is_completed'] == true) {
        entry['is_completed'] = '1';
      } else {
        entry['is_completed'] = '0';
      }
      if (entry['id'].toString().trim().isNotEmpty) {
        BlocProvider.of<TodosCubit>(context).updateById(entry);
      } else {
        BlocProvider.of<TodosCubit>(context).newTodo(entry);
      }
    } else {
      SnackBar snackBar = SnackBar(
        content: const Text('Verifique información'),
        backgroundColor: theme.colorScheme.error,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
