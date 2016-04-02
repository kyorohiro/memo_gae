import 'dart:io';
import 'package:appengine/appengine.dart' as engine;
import 'package:gcloud/db.dart' as gdb;
import 'dart:async';
import 'dart:convert';

@gdb.Kind()
class ItemsRoot extends gdb.Model {}
class Item extends gdb.Model {
  @gdb.StringProperty()
  String name;
}
Item deserialize(Map json) => new Item()..name = json['name'];
main(List<String> args) {
  int port = 8080;
  if (args.length > 0) port = int.parse(args[0]);

  engine.runAppEngine((HttpRequest request) async {
    if(request.uri.path =="/") {
      request.response.redirect(Uri.parse("/index.html"));
    } else {
      engine.context.assets.serve();
    }
      /*
    gdb.Key root = engine.context.services.db.emptyKey.append(ItemsRoot, id: 1);
    gdb.Query query =  engine.context.services.db.query(Item, ancestorKey: root);
    List<Item> items = await query.run().toList();
    var v= items.map((Item item)=>{"name":item.name});
    await request.response
    ..headers.set("Cache-Control" ,"no-cache")
    ..add(UTF8.encode(JSON.encode({"result":v})));
    await request.response.close();
    */
  },
  port: port);

  a(HttpRequest request) async {
    gdb.Key root = engine.context.services.db.emptyKey.append(ItemsRoot, id: 1);
    engine.Services s = engine.context.services;
//    s.logging.
//    s.memcache
    gdb.DatastoreDB d =  engine.context.services.db;
    gdb.Query query =  engine.context.services.db.query(Item, ancestorKey: root);
    query.order("name");
    List<Item> items = await query.run().toList();
    var v= items.map((Item item)=>{"name":item.name});
    await request.response
    ..headers.set("Cache-Control" ,"no-cache")
    ..add(UTF8.encode(JSON.encode({"result":v})));
    await request.response.close();
  }
}
