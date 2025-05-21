import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';

import 'package:student_manager/student_data.dart' as mock_students;

//定义路由
Router get router {
  final router = Router();

  //获取所有学生
  router.get('/students', (Request request) {
    final students = mock_students.students.values.toList();
    return Response.ok(
      jsonEncode(students),
      headers: {'Content-Type': 'application/json'},
    );
  });

  //获取单个学生
  router.get('/students/<id>', (Request request, String id) {
    final student = mock_students.students[id];

    if (student == null) {
      return Response.notFound('Student not found');
    }
    return Response.ok(jsonEncode(student));
  });

  //添加学生
  router.post('/students', (Request request) async {
    final body = await request.readAsString();
    final student = jsonDecode(body);
    if (student['id'] == null ||
        student['name'] == null ||
        student['age'] == null) {
      return Response.badRequest(body: 'Invalid student data');
    }
    if (mock_students.students.containsKey(student['id'])) {
      return Response.badRequest(body: 'Student already exists');
    }
    mock_students.students[student['id']] = {
      'id': student['id'],
      'name': student['name'],
      'age': student['age'],
    };
    return Response.ok('Student added');
  });

  //删除学生
  router.delete('/students/<id>', (Request request, String id) {
    final student = mock_students.students.remove(id);
    if (student == null) {
      return Response.notFound('Student not found');
    }
    return Response.ok('Student deleted');
  });

  return router;
}

void main(List<String> arguments) async {
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);
  final server = await serve(handler, 'localhost', 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}
