// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:random_words/random_words.dart';
import '../models/dictionary_m.dart';

int maxRecomCount = 6;
String appId = "84637d78";
String appKey = "4cc1f58e0029897d6a6712db54275144";
String baseUri = "od-api.oxforddictionaries.com";
String sourceLang = "en-us";

Future<DictionaryM?> getDefinition(String word) async {
  debugPrint("search word: $word");
  String endpoints = "/api/v2/words/$sourceLang";

  Map<String, String> query = {
    "q": word,
  };
  Map<String, String> _headers = {
    "Accept": "application/json",
    "app_id": appId,
    "app_key": appKey,
  };

  Uri uri = Uri.https(baseUri, endpoints, query);

  final response = await http.get(uri, headers: _headers);

  // debugPrint(response.body.toString());
  if (response.statusCode == 200) {
    return DictionaryM.fromJson(jsonDecode(response.body));
  } else {
    return null;
  }
}

Future<List<String>> getWordRecommends(String headWord) async {
  String endpoints = "/api/v2/search/thesaurus/$sourceLang";

  Map<String, String> query = {
    "q": headWord,
    "limit": maxRecomCount.toString(),
  };
  Map<String, String> _headers = {
    "Accept": "application/json",
    "app_id": appId,
    "app_key": appKey,
  };
  Uri uri = Uri.https(baseUri, endpoints, query);

  final response = await http.get(uri, headers: _headers);
  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);

    List<String> recs = [];
    body['results'].forEach((res) => recs.add(res['word']));

    return recs;
  } else {
    throw Exception('Failed to load definition');
  }
}
