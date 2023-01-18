// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/dict_define.dart';

Future<DictionaryDefinition> getDefinition(String word) async {
  String baseUrl = "https://od-api.oxforddictionaries.com/api/v2";
  String sourceLang = "en-us";
  String endpoints = "/words/$sourceLang";

  Map<String, String> query = {
    "q": word,
  };
  Map<String, String> _headers = {
    "Accept": "application/json",
    "app_id": "84637d78",
    "app_key": "4cc1f58e0029897d6a6712db54275144",
  };
  Uri uri = Uri.https(baseUrl, endpoints, query);

  final response = await http.get(uri, headers: _headers);

  if (response.statusCode == 200) {
    return DictionaryDefinition.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load definition');
  }
}

Future<List<String>> getWordRecommends(String headWord) async {
  String baseUrl = "https://od-api.oxforddictionaries.com/api/v2";
  String sourceLang = "en-us";
  String endpoints = "/search/thesaurus/$sourceLang";

  Map<String, String> query = {
    "q": headWord,
    "limit": "6",
  };
  Map<String, String> _headers = {
    "Accept": "application/json",
    "app_id": "84637d78",
    "app_key": "4cc1f58e0029897d6a6712db54275144",
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
