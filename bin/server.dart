import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'handlers.dart' as handlers;

// Configure routes.
final _routers = Router()
  ..get('/', _readHelp)
  ..post('/todos', handlers.createTodo)
  ..get('/todos', handlers.readTodos)
  ..patch('/todos/<id>', handlers.updateTodo)
  ..delete('/todos/<id>', handlers.deleteTodo);

void main(List<String> args) async {
  // Use loopback ip address (usually `localhost`).
  final ip = InternetAddress.loopbackIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_routers);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

Response _readHelp(Request request) {
  return Response.ok(''' 
    +++++++++++++++++++++++++++++
    +++ Welcome to Todo Beast +++
    +++++++++++++++++++++++++++++ 
    
    With our API you are able to perform basic CRUD operation on your To-dos 

    1- GET /todos => read all todos
    2- POST /todos => create a new todo
    3- PATCH /todos/<id> => update an existing todo
    4- DELETE /todso/<id> => delete an existing todo
    ''');
}
