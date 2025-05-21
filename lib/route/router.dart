import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';
import '../data/mock_data.dart' show students;

class Routes {
  Router get router {
    final router = Router();

    //获取所有学生
    router.get('/students', (Request request) {
      final queryStudents = students.values.toList();
      return Response.ok(
        jsonEncode(queryStudents),
        headers: {'Content-Type': 'application/json'},
      );
    });

    //获取单个学生
    router.get('/students/<id>', (Request request, String id) {
      final student = students[id];
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
      if (students.containsKey(student['id'])) {
        return Response.badRequest(body: 'Student already exists');
      }
      students[student['id']] = {
        'id': student['id'],
        'name': student['name'],
        'age': student['age'],
      };
      return Response.ok('Student added');
    });

    //删除学生
    router.delete('/students/<id>', (Request request, String id) {
      final student = students.remove(id);
      if (student == null) {
        return Response.notFound('Student not found');
      }
      return Response.ok('Student deleted');
    });

    return router;
  }
}
