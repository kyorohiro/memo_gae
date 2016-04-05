import 'dart:io';
import 'package:appengine/appengine.dart' as engine;

main(List<String> args) {
  int port = 8080;
  if (args.length > 0) port = int.parse(args[0]);
  engine.runAppEngine((HttpRequest request) async {
    if (request.uri.path == "/") {
      request.response.redirect(Uri.parse("/index.html"));
    } else {
      engine.context.assets.serve();
    }
  }, port: port);
}
