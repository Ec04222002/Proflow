// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:proflow/models/word.dart';

enum OxfordResProperty {
  results,
  lexicalEntries,
  entries,
  //
  lexicalCategory,
  //
  text,
  //
  inflections,
  //
  pronunciations,
  audioFile,
  phoneticSpelling,
  //
  senses,
  definitions,
  examples,
  //
  synonyms;

  String get asStr => name;
}

class Dictionary {
  final List<Word> words;

  const Dictionary({required this.words});

  factory Dictionary.fromJson(Map<String, dynamic> json) {
    // print(json[OxfordResProperty.results.asStr]);
    List<dynamic> results = json[OxfordResProperty.results.asStr];
    List<Word> _words = [];
    for (var res in results) {
      List<dynamic> lexEntries = res[OxfordResProperty.lexicalEntries.asStr];

      for (var entry in lexEntries) {
        Map<String, dynamic> _entry = entry[OxfordResProperty.entries.asStr][0];
        List<dynamic> senses = _entry[OxfordResProperty.senses.asStr];

        final String? _text = entry[OxfordResProperty.text.asStr];

        final Map<String, List<String>> _defAndExamples = {};
        late List<String>? _synonyms;

        //definitions and examples
        for (var sense in senses) {
          String def = sense[OxfordResProperty.definitions.asStr][0];
          List<String> exs = [
            for (var ex in sense[OxfordResProperty.examples.asStr])
              ex[OxfordResProperty.text.asStr]
          ];
          _defAndExamples[def] = exs;
          if (sense.containsKey(OxfordResProperty.synonyms.asStr)) {
            _synonyms = [
              for (var synonym in sense[OxfordResProperty.synonyms.asStr])
                synonym[OxfordResProperty.text.asStr]
            ];
          }
        }

        final String? _partOfSpeech =
            entry[OxfordResProperty.lexicalCategory.asStr]
                [OxfordResProperty.text.asStr];

        final String? _pronounce =
            _entry[OxfordResProperty.pronunciations.asStr][0]
                [OxfordResProperty.phoneticSpelling.asStr];
        final String? _audioFile =
            _entry[OxfordResProperty.pronunciations.asStr][0]
                [OxfordResProperty.audioFile.asStr];

        _words.add(Word.fromJson({
          WordProperty.word.text: _text ?? "",
          WordProperty.definitionAndExamples.text: _defAndExamples,
          WordProperty.partOfSpeech.text: _partOfSpeech ?? "",
          WordProperty.pronounciation.text: _pronounce ?? "",
          WordProperty.audioUrl.text: _audioFile ?? "",
          WordProperty.synonyms.text: _synonyms ?? [],
        }));
      }
    }
    return Dictionary(words: _words);
  }
}
