// Página principal (tipo Home) de la aplicación.
//
// En este archivo se manda llamar un Cubit tipo List de Todos para desplegar
// un listado de registros llamados desde la API.
// El listado permite editar y eliminar cada uno de los registros.
// Así como crear uno nuevo.

import 'package:flutter/material.dart';

import '../../todos/view/list_todos/todos_bloc_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nextline\'s TODOS'),
          centerTitle: true,
        ),
        body:
        // Llamamos el constructor de Widget tipo BloC
        const SingleChildScrollView(
          child:
              Padding(padding: EdgeInsets.all(15), child: ListTodosBuilder()),
        ),
        floatingActionButton: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            backgroundColor: Colors.blue[900],
            onPressed: () {
              Navigator.pushNamed(context, '/cu_todo',
                  arguments: <String, dynamic>{'title': 'Nueva tarea'});
            },
            tooltip: 'Nueva',
            child: const Icon(Icons.add, size: 50),
          ),
        ));
  }
}
