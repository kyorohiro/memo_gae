import 'dart:html' as html;
import 'dart:convert' as conv;
import 'dart:async';
import 'dart:typed_data';

void main() {
  html.Element d = new html.Element.html([
    "<table>", //
    "<tr><td>AAA</td><td><input type=text value='aa' id='a'></td></tr>", //
    "<tr><td>POST</td><td><input type=button value='bb' id='b'></tr>", //
    "<tr><td>GET</td><td><input type=button value='bb' id='c'></tr>", //
    "</table>"
  ].join("\n"));
  html.document.body.children.add(d);
  d.querySelector("#c").onClick.listen((html.MouseEvent e) async {
    html.HttpRequest req = new html.HttpRequest();
    req.responseType = "arraybuffer";
    Completer c = new Completer();
    req.onReadyStateChange.listen((html.ProgressEvent e) {
      if (req.readyState == html.HttpRequest.DONE) {
        c.complete(req.response);
      }
    });
    req.onError.listen((html.ProgressEvent e) {
      c.completeError(e);
    });
    req.open("GET", "${html.window.location.protocol}//${html.window.location.host}/item");
    req.send();
    await c.future;
    print("#>G> ${conv.UTF8.decode((req.response as ByteBuffer).asUint8List())}");
  });

  d.querySelector("#b").onClick.listen((html.MouseEvent e) async {
    String v = (d.querySelector("#a") as html.InputElement).value;
    String vv = conv.JSON.encode({"v": v});

    html.HttpRequest req = new html.HttpRequest();
    req.responseType = "arraybuffer";
    Completer c = new Completer();
    req.onReadyStateChange.listen((html.ProgressEvent e) {
      if (req.readyState == html.HttpRequest.DONE) {
        c.complete(req.response);
      }
    });
    req.onError.listen((html.ProgressEvent e) {
      c.completeError(e);
    });
    req.open("POST", "${html.window.location.protocol}//${html.window.location.host}/item");
    req.send(vv);
    await c.future;
    print("#>P> ${conv.UTF8.decode((req.response as ByteBuffer).asUint8List())}");
  });
}
