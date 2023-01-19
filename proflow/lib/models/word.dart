// ignore_for_file: no_leading_underscores_for_local_identifiers

enum WordProperty {
  word,
  definitionAndExamples,
  pronounciation,
  audioUrl,
  partOfSpeech,
  // inflections,
  synonyms;

  String get text => name;
}

class Word {
  final String word;
  final Map<String, List<String>> defAndExamples;
  final String pronounciation;
  final String audioUrl;
  final String partOfSpeech;
  // final List<String> inflections; //states plural, singular, transitive
  final List<String> synonyms;
  const Word({
    required this.word,
    required this.defAndExamples,
    required this.pronounciation,
    required this.audioUrl,
    required this.partOfSpeech,
    // required this.inflections,
    required this.synonyms,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    final String? _word = json[WordProperty.word];
    final Map<String, List<String>>? _defAndExamples =
        json[WordProperty.definitionAndExamples];
    final String? _pronounciation = json[WordProperty.pronounciation];
    final String? _audioUrl = json[WordProperty.audioUrl];
    final String? _partOfSpeech = json[WordProperty.partOfSpeech];
    // final List<String> _inflections = json[WordProperty.inflections];
    final List<String>? _synonyms = json[WordProperty.word];

    return Word(
      word: _word ?? '',
      defAndExamples: _defAndExamples ?? {},
      pronounciation: _pronounciation ?? '',
      audioUrl: _audioUrl ?? '',
      partOfSpeech: _partOfSpeech ?? '',
      // inflections: _inflections,
      synonyms: _synonyms ?? [],
    );
  }
}
