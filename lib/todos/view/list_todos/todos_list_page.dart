// Widget que funciona como enlistador principal de todos los registros
// de la API mediante el método GET por medio de un BLoC y Cubit
// Es la interfaz principal del listado y sus elementos como editar o botón de eliminar.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/todos_bloc.dart';

class TodosListPage extends StatefulWidget {
  const TodosListPage({Key? key, required this.items}) : super(key: key);

  final List<Todos>? items;

  @override
  State<TodosListPage> createState() => TodosListPageState();
}

class TodosListPageState extends State<TodosListPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.items?.length,
        shrinkWrap: true,
        physics: const PageScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onDoubleTap: () {
              Navigator.pushNamed(context, '/cu_todo',
                  arguments: <String, dynamic>{
                    'id': widget.items![index].id,
                    'title': 'Editar ${widget.items![index].title}'
                  });
            },
            child: SizedBox(
              height: 85,
              child: Card(
                elevation: 7,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/cu_todo',
                            arguments: <String, dynamic>{
                              'id': widget.items![index].id,
                              'title': 'Editar ${widget.items![index].title}'
                            });
                      },
                      icon: const Icon(Icons.edit, color: Colors.black54)),
                  title: Text(widget.items![index].title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 24)),
                  trailing: IconButton(
                      onPressed: () {
                        BlocProvider.of<TodosCubit>(context)
                            .deleteById(widget.items![index].id.toString());
                      },
                      icon: Icon(Icons.delete, color: Colors.red[300])),
                  onTap: () {
                    Navigator.pushNamed(context, '/view_todo',
                        arguments: <String, dynamic>{
                          'id': widget.items![index].id,
                          'title': widget.items![index].title
                        });
                  },
                ),
              ),
            ),
          );
        });
  }
}
