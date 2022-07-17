// Clase Todos
//
// Esta clase es fundamental para la presente App.
// En ella se le da estructura a los registros TODOS de la aplicación.
// Almancena las propuedades de cada uno de los registros obtenidos por medio de la API.

part of '../bloc/todos_bloc.dart';

class Todos {
  final int id;
  final String title;
  final int isCompleted;
  final String comments;
  final String description;
  final String tags;
  final String dueDate;

  Todos({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.comments = '',
    this.description = '',
    this.tags = '',
    this.dueDate = '',
  });

  factory Todos.fromJson(Map<String, dynamic> json) {
    return Todos(
      id: int.parse(json['id'].toString()),
      title: json['title'].toString(),
      isCompleted: int.parse(json['is_completed'].toString()),
      description:
          (json['description'] == null) ? '' : json['description'].toString(),
      comments: (json['comments'] == null) ? '' : json['comments'].toString(),
      tags: (json['tags'] == null) ? '' : json['tags'].toString(),
      dueDate: (json['due_date'] == null) ? '' : json['due_date'].toString(),
    );
  }
}

abstract class TodosState {
  const TodosState() : super();
}

class InitialState extends TodosState {
  const InitialState();
}

class LoadingState extends TodosState {
  const LoadingState();
}

class SearchState extends TodosState {
  const SearchState(this.id);

  final String id;
}

class LoadedState extends TodosState {
  LoadedState(this.todo);

  Todos todo;
}

class CreatedUpdatedState extends TodosState {
  const CreatedUpdatedState();
}

class DeletedState extends TodosState {
  const DeletedState();
}

class NotSavedState extends TodosState {
  const NotSavedState(this.message);

  final String message;
}

class FoundState extends TodosState {
  FoundState(this.items);

  List<Todos>? items;
}

class NotFoundState extends TodosState {
  const NotFoundState();
}

class EmptyState extends TodosState {
  const EmptyState();
}

class DoNotReInitState extends TodosState {
  const DoNotReInitState();
}

class ConnectionErrorState extends TodosState {
  const ConnectionErrorState(this.message);

  final String message;
}

class FatalErrorState extends TodosState {
  const FatalErrorState(this.message);

  final String message;
}
