import 'dart:io';
import 'package:appengine/appengine.dart' as engine;
import 'package:gcloud/db.dart' as gdb;
import 'dart:convert';
import 'package:check/model.dart';

gdb.Key get itemsRoot => engine.context.services.db.emptyKey.append(ItemsRoot, id: 1);

main(List<String> args) {
  engine.runAppEngine((HttpRequest request) async {
    switch (request.uri.path) {
      case "/item":
        bb(request);
        break;
      default:
        engine.context.assets.serve();
    }
  }, port: (args.length > 0 ? int.parse(args[0]) : 8080));
}

bb(HttpRequest request) async {
  if (request.method == "POST") {
    Item item = new Item()
      ..name = "test"
      ..parentKey = itemsRoot;
    try {
      await engine.context.services.db.commit(inserts: [item]);
      await request.response
        ..headers.set("Cache-Control", "no-cache")
        ..add(UTF8.encode(JSON.encode({"result": "ok"})))
        ..close();
    } catch (e) {
      await request.response
        ..headers.set("Cache-Control", "no-cache")
        ..add(UTF8.encode(JSON.encode({"result": "${item} ## ${e}"})))
        ..close();
    }
  } else if (request.method == "GET") {
    gdb.Query query = engine.context.services.db.query(Item, ancestorKey: itemsRoot)..order('name');
    List<Item> items = await query.run().toList();
    var result = items.map((item) => {"name": item.name}).toList();
    var json = {'success': true, 'result': result};
    await request.response
      ..headers.set("Cache-Control", "no-cache")
      ..add(UTF8.encode(JSON.encode({"result": json})))
      ..close();
  } else {
    request.response.close();
  }
}
