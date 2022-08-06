import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uuid/uuid.dart';
import 'todo.dart';

final _uuid = Uuid();

List<Todo> _todos = List.empty(growable: true);

Response readHelp(Request req) {
  return Response.ok('Welcome to Todo Beast!\n');
}

Future<Response> createTodo(Request request) async {
  final json = await request.readAsString();
  print(json);
  final Map<String, dynamic> map = jsonDecode(json);
  final todo = Todo.fromMap(map);
  todo.id = _uuid.v4();
  _todos.add(todo);
  return Response.ok("Todo created!");
}

Response readTodos(Request request) {
  final map = _todos.map((e) => e.toMap()).toList();
  print(map);
  final json = jsonEncode(map);
  print(json);
  return Response.ok(json);
}

Future<Response> updateTodo(Request request) async {
  final id = request.params['id'];
  try {
    final todo = _todos.firstWhere((e) => e.id == id);
    final json = await request.readAsString();
    final map = jsonDecode(json);
    final newTodo = todo.copyWith(
      title: map['title'],
    );
    final index = _todos.indexWhere((e) => e.id == id);
    _todos[index] = newTodo;
    return Response.ok("Todo updated!");
  } on StateError {
    return Response.notFound("Todo with id $id was not found!");
  }
}

Response deleteTodo(Request request) {
  final id = request.params['id'];
  try {
    final index = _todos.indexWhere((e) => e.id == id);
    _todos.removeAt(index);
    return Response.ok("Todo deleted!");
  } on StateError {
    return Response.notFound("Todo with id $id was not found!");
  }
}
