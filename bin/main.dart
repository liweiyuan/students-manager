import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'package:student_manager/route/router.dart';

void main(List<String> arguments) async {
  final routes = Routes();
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(routes.router.call);
  final server = await serve(handler, '0.0.0.0', 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}
