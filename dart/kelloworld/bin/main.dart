import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cryptoutils/cryptoutils.dart';

main(List<String> args) async {
  //String name = args[0];
  //String pass = args[1];
  //print('${name} ${pass}');
  http.Client client = new http.Client();
  gmail.GmailApi api = new gmail.GmailApi(client);
  gmail.Message message = new gmail.Message();

  String to = "kyorohiro@gmail.com";
  String subject = "test subject";
  String text = "test text";
  String mail = "To: $to\n"
      "Subject: =?utf-8?B?$subject?=\n"
      "MIME-Version: 1.0\n"
      "Content-Type: text/plain; charset=${UTF8.name}\n"
      "Content-Transfer-Encoding: 7bit\n"
      "\n"
      "$text";
  mail = CryptoUtils.bytesToBase64(UTF8.encode(mail));
  message.raw = mail;
  gmail.Message ret = await api.users.messages.send(message, "me");

}
