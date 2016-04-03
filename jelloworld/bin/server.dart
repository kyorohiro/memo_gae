import 'dart:io';
import 'package:appengine/appengine.dart' as engine;
import 'package:gcloud/db.dart' as gdb;
import 'package:gcloud/datastore.dart' as dst;
import 'dart:convert';

@gdb.Kind()
class ItemsRoot extends gdb.Model {}

@gdb.Kind()
class Item extends gdb.Model {
  @gdb.StringProperty()
  String name;

  @gdb.StringProperty()
  String content;

  @gdb.IntProperty()
  int counter;

  @gdb.DateTimeProperty()
  DateTime updated;

  @gdb.DateTimeProperty()
  DateTime created;
}


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
    Map vs = await request.transform(UTF8.decoder).transform(JSON.decoder).single;

    Item item = new Item()
      ..name = "test"
      ..content = "${vs['v']}"
      ..counter = 1
      ..updated = new DateTime.now()
      ..created = new DateTime.now()
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
    //gdb.DatastoreDB db = engine.context.services.db;
    //dst.Transaction t = await db.datastore.beginTransaction(); //.beginTransaction();
    // Partition partition, Key ancestorKey
    gdb.Query query = engine.context.services.db.query(Item, ancestorKey: itemsRoot);
    query.order("name");
    //..order('content');
    //
    // "LastName =", "Voski"
    //query.filter(filterString, comparisonObject)
    //query.f
    List<Item> items = await query.run().toList();
    var result = items.map((item) {
      var v = {"name": item.name, "content":item.content, "counter":item.counter};
      return v;
    }).toList();
    //
    try {
    items[0].counter = 1 + items[0].counter;
  } catch (e) {
    await request.response
      ..headers.set("Cache-Control", "no-cache")
      ..add(UTF8.encode(JSON.encode({"result": "${items[0]} ## ${e}"})))
      ..close();
    return;
  }

    var json = {'success': true, 'result': result};
    await request.response
      ..headers.set("Cache-Control", "no-cache")
      ..add(UTF8.encode(JSON.encode({"result": json})))
      ..close();
    //
    //
    engine.context.services.db.commit(inserts:[items[0]]);
  } else {
    request.response.close();
  }
}
