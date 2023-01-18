class DictionaryDefinition {
  final String word;
  final List<Map<String, String>> defAndExs;
  final List<String> inflectionsWithGrammarType;
  final String partOfSpeech;
  final String pronounciation;
  final String audioUrl;

  const DictionaryDefinition({
    required this.word,
    required this.defAndExs,
    required this.inflectionsWithGrammarType,
    required this.partOfSpeech,
    required this.pronounciation,
    required this.audioUrl,
  });

  factory DictionaryDefinition.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> results = json['results'];
    List<Map<String, dynamic>> entries = res[0]['lexicalEntries'];
    List<String> _words;
    List<Map<String, String>> _defAndExs;
    //plural, singular, transitive
    List<String> _inflectionsWithGrammarType;
    String _partOfSpeech;
    String _pronounciation;
    String _audioUrl;

    results.forEach((res) {
      _words.add(res['word']);
    });

    return DictionaryDefinition(
      word: _word,
      defAndExs: _defAndExs,
      inflectionsWithGrammarType: _inflectionsWithGrammarType,
      partOfSpeech: _partOfSpeech,
      pronounciation: _pronounciation,
      audioUrl: _audioUrl,
    );
  }
}
