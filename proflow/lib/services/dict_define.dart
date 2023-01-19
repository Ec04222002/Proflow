// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_words/random_words.dart';
import '../models/dictionary.dart';

int maxRecomCount = 6;
String appId = "84637d78";
String appKey = "4cc1f58e0029897d6a6712db54275144";
String baseUrl = "od-api.oxforddictionaries.com";
String sourceLang = "en-us";

String getRandomWord() {
  bool isNoun = Random().nextInt(2) == 1;

  if (isNoun) return nouns.take(1).first;
  return adjectives.take(1).first;
}

Future<Dictionary> getDefinition(String word) async {
  String endpoints = "/api/v2/words/$sourceLang";

  Map<String, String> query = {
    "q": word,
  };
  Map<String, String> _headers = {
    "Accept": "application/json",
    "app_id": appId,
    "app_key": appKey,
  };

  Uri uri = Uri.https(baseUrl, endpoints, query);

  final response = await http.get(uri, headers: _headers);
  debugPrint(response.toString());
  if (response.statusCode == 200) {
    return Dictionary.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load definition');
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
  Uri uri = Uri.https(baseUrl, endpoints, query);

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
