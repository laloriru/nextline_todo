// Clase TodosCubit
//
// Esta clase es la encargada de estar haciendo los requests a la API
// de la aplicación.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../global/vars.dart' as global_vars;

part '../model/todos_model.dart';

class TodosCubit extends Cubit<TodosState> {
  TodosCubit() : super(const InitialState());

  // Obtener un listado de todos los registros tipo Task
  // Dentro de la aplicación llamados Todos
  Future<List> getTodos() async {
    List<Todos> todos = [];
    try {
      final queryParameters = {
        'token': global_vars.apiToken,
      };
      final url = Uri.parse(global_vars.apiBaseUrl + 'tasks');
      final finalUri = url.replace(queryParameters: queryParameters);
      var response = await http.get(finalUri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${global_vars.apiToken}',
      });
      if (kDebugMode) {
        print('getTodos Body: ${response.body.toString()}');
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          List<Todos> todos =
              data.map((item) => Todos.fromJson(item)).toList().cast<Todos>();
          emit(FoundState(todos));
          return todos;
        } else {
          emit(const EmptyState());
        }
      } else {
        emit(ConnectionErrorState(response.statusCode.toString()));
      }
    } catch (e) {
      emit(FatalErrorState(e.toString()));
    }
    return todos;
  }

  //Crea un nuevo registro mediante método POST a la API
  Future<bool> newTodo(Map<String, dynamic> todo) async {
    try {
      emit(const LoadingState());
      var url = Uri.parse(global_vars.apiBaseUrl + 'tasks');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${global_vars.apiToken}',
        },
        //encoding: Encoding.getByName('utf-8'),
        body: <String, String>{
          'title': todo['title'],
          'is_completed': todo['is_completed'],
          'description': todo['description'],
          'comments': todo['comments'],
          'tags': todo['tags'],
        },
      );
      if (kDebugMode) {
        print('newTodo Body: ${response.body.toString()}');
      }
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          emit(const CreatedUpdatedState());
          return true;
        } else {
          emit(NotSavedState(response.body.toString()));
          return false;
        }
      } else {
        emit(ConnectionErrorState(response.body.toString()));
        return false;
      }
    } catch (e) {
      emit(FatalErrorState(e.toString()));
      return false;
    }
  }

  // Obtiene un registro individual de tipo TODOS mediante el método GET
  // dirigido hacia la API
  Future<void> getById(String id) async {
    try {
      final queryParameters = {
        'task_id': id,
        'token': global_vars.apiToken,
      };
      final url = Uri.parse(global_vars.apiBaseUrl + 'tasks/$id');
      final finalUri = url.replace(queryParameters: queryParameters);
      var response = await http.get(finalUri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${global_vars.apiToken}',
      });
      if (kDebugMode) {
        print('getByToken Body: ${response.body.toString()}');
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          List<Todos> todos =
              data.map((item) => Todos.fromJson(item)).toList().cast<Todos>();
          emit(LoadedState(todos[0]));
        } else {
          emit(const EmptyState());
        }
      } else {
        emit(ConnectionErrorState(response.statusCode.toString()));
      }
    } catch (e) {
      emit(FatalErrorState(e.toString()));
    }
  }

  // Actualiza un registro individual por URL dentro de la API
  // Se utiliza el método PUT de HTTP
  Future<bool> updateById(Map<String, dynamic> todo) async {
    final queryParameters = {
      'task_id': todo['id'].toString(),
      'token': global_vars.apiToken,
    };
    final url = Uri.parse(global_vars.apiBaseUrl + 'tasks/${todo['id']}');
    final finalUri = url.replace(queryParameters: queryParameters);
    var response = await http.put(
      finalUri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${global_vars.apiToken}',
      },
      body: <String, String>{
        'title': todo['title'],
        'is_completed': todo['is_completed'],
        'description': todo['description'],
        'comments': todo['comments'],
        'tags': todo['tags'],
      },
    );
    if (kDebugMode) {
      print('updateByToken Body: ${response.body.toString()}');
    }
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        emit(const CreatedUpdatedState());
        return true;
      } else {
        emit(NotSavedState(response.body.toString()));
        return false;
      }
    } else {
      emit(ConnectionErrorState(response.body.toString()));
      return false;
    }
  }

  // Elimina un registro individual por medio del ID del registro
  // Se utiliza método DELETE de HTTP
  Future<bool> deleteById(String id) async {
    final queryParameters = {
      'task_id': id,
      'token': global_vars.apiToken,
    };
    final url = Uri.parse(global_vars.apiBaseUrl + 'tasks/$id');
    final finalUri = url.replace(queryParameters: queryParameters);
    var response = await http.delete(
      finalUri,
      headers: {
        'Authorization': 'Bearer ${global_vars.apiToken}',
      },
    );
    if (kDebugMode) {
      print('deleteByToken Body: ${response.body.toString()}');
    }
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        emit(const DeletedState());
        return true;
      } else {
        emit(NotSavedState(response.body.toString()));
        return false;
      }
    } else {
      emit(ConnectionErrorState(response.body.toString()));
      return false;
    }
  }
}
