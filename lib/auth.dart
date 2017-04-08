import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/services/oauth/oauth.dart';
import 'package:flutter/services.dart';

Future<File> getTokenFile() async {
  String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
  return new File("$dir/token.json");
}

Future<GitterToken> getSavedToken() async {
  File tokenFile = await getTokenFile();
  if (!await tokenFile.exists()) {
    return null;
  }
  return new GitterToken.fromJson(JSON.decode(await tokenFile.readAsString()));
}

Future<bool> isAuth() async {
  return (await getSavedToken()) != null ? true : false;
}

Future<GitterToken> auth() async {
  final GitterOAuth gitterOAuth = new GitterOAuth(new AppInformations(
    "26258fa3ccd13c487dd8b5ed7e2acbeb087d14eb",
    "9c2239a87cfcf51d43c2abb30eae7e1878e5f268",
    "http://localhost:8080/",
  ));
  GitterToken token = await gitterOAuth.signIn();
  File tokenFile = await getTokenFile();
  tokenFile.writeAsStringSync(JSON.encode(token.toMap()));
  return token;
}